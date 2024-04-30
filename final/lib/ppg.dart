import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:test2/firebase_options.dart';

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
  bool _toggled = false;
  bool _processing = false;
  List<SensorValue> _data = []; // Store sensor values
  double _bpmValue = 0; // Store computed BPM
  double _alpha = 0.3; // Smoothing factor for BPM
  double _progress = 0; // Progress indicator value

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() async {
    setState(() {
      _toggled = !_toggled; // Sets _toggled = true locally
      _processing = false;
    });
    if (_toggled) {
      await _initializeControllerFuture;
      _controller.setFlashMode(FlashMode.torch);
      _controller.startImageStream((image) {
        if (!_processing) {
          setState(() {
            _processing = true;
          });
          _scanImage(image);
        }
      });
      _startProgressIndicator();
      _updateBPM();
    } else {
      _controller.stopImageStream();
      _controller.setFlashMode(FlashMode.off);
      _progress = 0; // Reset the progress when toggled off
    }
  }

  void _scanImage(CameraImage image) {
    if (!_toggled)
      return; // Guard against processing after the button is toggled off
    double _avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;

    if (_data.length >= 50) {
      _data.removeAt(0);
    }
    setState(() {
      _data.add(SensorValue(DateTime.now(), _avg));
      _processing = false;
    });
  }

  void _startProgressIndicator() {
    _progress = 0;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_progress < 1) {
        setState(() {
          _progress += 0.2;
        });
      } else {
        timer.cancel();
        _controller.setFlashMode(FlashMode.off); // Turn off the flashlight

        // _finalizeBPM(); // Turns flashlight and camera off, finalizes the _bpmValue
        setState(() {
          _toggled = false; // Backup toggle off
        });
      }
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

      if (!_toggled) {
        print("Exiting _updateBPM early due to toggle off");
        break; // Break the loop if _toggled is false
      }
    }
  }

  // void _finalizeBPM() {
  //   double finalBpm = _bpmValue; // Assign the last recorded BPM value; idk
  //   setState(() {
  //     _toggled = false; // Stops further measurements
  //     _progress = 0; // Resets progress
  //     _controller.setFlashMode(FlashMode.off); // Turn off the flashlight
  //     _controller.stopImageStream(); // Stop camera stream
  //   });

  //   // Push to Firestore
  //   _submitDataToFirestore();
  // }

  // void _submitDataToFirestore() {
  //   FirebaseFirestore.instance.collection('health_sessions').add({
  //     'selectedDate':
  //         HealthSessionData().selectedDate, // Uses converted Timestamp
  //     'moodLevel': HealthSessionData().moodLevel,
  //     'sleepDuration': HealthSessionData().sleepHours,
  //     'bpmValue': HealthSessionData().bpmValue,
  //   }).then((value) {
  //     print('Data submitted to Firestore');
  //   }).catchError((error) {
  //     print('Failed to submit data: $error');
  //   });
  // }

// Using an asynchronous function
  Future<void> _submitDataToFirestore() async {
    try {
      // Prepare the data for submission
      var data = {
        'selectedDate': HealthSessionData()
            .selectedDate, // Assumes selectedDate is a DateTime
        'moodLevel': HealthSessionData().moodLevel,
        'sleepDuration': HealthSessionData().sleepHours,
        'bpmValue': HealthSessionData().bpmValue,
      };

      // Submit the data to Firestore
      await FirebaseFirestore.instance.collection('health_sessions').add(data);
      print('Data submitted to Firestore successfully');
    } catch (error) {
      print('Failed to submit data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141925),
      appBar: AppBar(
        title: const Text("Check Your Pulse"),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 260,
              height: 260,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value:
                        _toggled ? (_progress <= 1.0 ? _progress : null) : 0.0,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    strokeWidth: 6,
                  ),
                  Center(
                    child: Text(
                      _toggled
                          ? "Measuring heartrate"
                          : "Cover the flashlight and camera with your index finger. \n\nPress the heart to begin...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _toggle,
              icon: Icon(
                _toggled ? Icons.favorite : Icons.favorite_border,
                size: 40,
                color: Colors.white,
              ),
              label: Text(
                // Display the BPM value or start
                _bpmValue > 0 ? "${_bpmValue.toStringAsFixed(0)} BPM" : "Start",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: CircleBorder(),
                padding: EdgeInsets.all(40),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                HealthSessionData().bpmValue = _bpmValue;
                HapticFeedback.mediumImpact();
                await _submitDataToFirestore();
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Submit Data'),
            ),
          ],
        )),
      ),
    );
  }
}

class HealthSessionData {
  DateTime? selectedDate;
  int? moodLevel;
  double? sleepHours;
  num? bpmValue;
  // Named parameters can't start with an underscore
  //so I'm not using the variable name (_bpmValue)
  //idk what type bpm is

  void printData() {
    print('selectedDate: $selectedDate');
    print('moodLevel: $moodLevel');
    print('sleepDuration: $sleepHours');
    print('bpmValue: $bpmValue');
  }

  HealthSessionData._();

  static final HealthSessionData _instance = HealthSessionData._internal();
  factory HealthSessionData() => _instance;
  HealthSessionData._internal();

  void setSleepDuration(int hours, int minutes) {
    sleepHours = hours +
        minutes / 60.0; // Converts hours and minutes to a decimal hour format
  }

  // Method to convert selectedDate to Timestamp
  Timestamp? getTimestampFromDate(DateTime? date) {
    if (date != null) {
      return Timestamp.fromDate(date);
    }
    return null;
  }
}
