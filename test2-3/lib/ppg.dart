import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class SensorValue {
  final DateTime time;
  final double value;
  SensorValue(this.time, this.value);
}

class PPGScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const PPGScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _PPGScreenState createState() => _PPGScreenState();
}

class _PPGScreenState extends State<PPGScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  List<SensorValue> _data = [];
  double _alpha = 0.3;
  bool _toggled = false;
  bool _processing = false;
  double _bpmValue = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(
      widget.cameras[
          0], // Use the first camera from the list passed as a parameter
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    _controller.addListener(() {
      if (_controller.value.isInitialized && _toggled) {
        _controller.setFlashMode(FlashMode.torch);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() async {
    setState(() {
      _toggled = !_toggled;
      _processing = false;
    });
    if (_toggled) {
      await _initializeControllerFuture;
      _controller.startImageStream((image) {
        if (!_processing) {
          setState(() {
            _processing = true;
          });
          _scanImage(image);
        }
      });
      _updateBPM();
    } else {
      _controller.stopImageStream();
      _controller.setFlashMode(FlashMode.off);
    }
  }

  void _scanImage(CameraImage image) {
    double _avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;

    if (_data.length >= 50) {
      _data.removeAt(0);
    }

    setState(() {
      _data.add(SensorValue(DateTime.now(), _avg));
    });
    Future.delayed(Duration(milliseconds: 1000 ~/ 30)).then((onValue) {
      setState(() {
        _processing = false;
      });
    });
  }

  void _updateBPM() async {
    List<SensorValue> _values;
    double _avg;
    int _n;
    double _m;
    double _threshold;
    double _counter;
    int _previous;
    while (_toggled) {
      _values = List.from(_data);
      _avg = 0;
      _n = _values.length;
      _m = 0;
      _values.forEach((SensorValue value) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      });
      _threshold = (_m + _avg) / 2;
      _bpmValue = 0;
      _counter = 0;
      _previous = 0;
      for (int i = 1; i < _n; i++) {
        if (_values[i - 1].value < _threshold &&
            _values[i].value > _threshold) {
          if (_previous != 0) {
            _counter++;
            _bpmValue +=
                60000 / (_values[i].time.millisecondsSinceEpoch - _previous);
          }
          _previous = _values[i].time.millisecondsSinceEpoch;
        }
      }
      if (_counter > 0) {
        _bpmValue = _bpmValue / _counter;
        setState(() {
          _bpmValue = (1 - _alpha) * _bpmValue + _alpha * _bpmValue;
        });
      }
      await Future.delayed(Duration(milliseconds: (1000 * 50 / 30).round()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: _controller == null
                          ? Container()
                          : FutureBuilder<void>(
                              future: _initializeControllerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    _toggled) {
                                  return CameraPreview(_controller);
                                } else {
                                  return Container(
                                    color: Colors.grey,
                                    child: Center(
                                      child: Text(
                                          "Cover the flashlight and camera with your index finger. Press the heart to begin..."),
                                    ),
                                  );
                                }
                              },
                            ),
                    ),
                  ),
                  Expanded(
                    child: Center(child: Text("BPM: $_bpmValue")),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: IconButton(
                  icon: Icon(_toggled ? Icons.favorite : Icons.favorite_border),
                  color: Colors.red,
                  iconSize: 128,
                  onPressed: () {
                    _toggle();
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
