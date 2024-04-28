import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:camera/camera.dart';

late List<CameraDescription> _cameras;

// void main() => runApp(MyApp());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PPG',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageView createState() {
    return HomePageView();
  }
}

class SensorValue {
  final DateTime time;
  final double value;
  SensorValue(this.time, this.value);
}

class HomePageView extends State<HomePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  List<SensorValue> data = [];
  int bpmValue = 0;
  bool _toggled = false;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      _cameras[0],
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  _toggle() {
    setState(() {
      _toggled = true;
    });
  }

  _untoggle() {
    setState(() {
      _toggled = false;
    });
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
                          : CameraPreview(_controller),
                    ),
                  ),
                  Expanded(
                    child: Center(child: Text("BPM")),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                //second container
                child: IconButton(
                  icon: Icon(_toggled ? Icons.favorite : Icons.favorite_border),
                  color: Colors.red,
                  iconSize: 128,
                  onPressed: () {
                    if (_toggled) {
                      _untoggle();
                    } else {
                      _toggle();
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                //third container
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  color: Colors.blue, // nested within BoxDecoration.
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
