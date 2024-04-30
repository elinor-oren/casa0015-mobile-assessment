import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'calendar.dart';
import 'moodLogging.dart';
import 'sleepLogging.dart';
import 'ppg.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter app binding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  List<CameraDescription> cameras =
      await availableCameras(); // Retrieve available cameras
  runApp(MyApp(
      cameras:
          cameras)); // Set up and run the app, with cameras passed to MyApp
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras; // Camera list to pass to the PPGScreen

  const MyApp({Key? key, required this.cameras})
      : super(key: key); // Constructor accepting camera list

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PPG App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => CalendarScreen(),
        '/sleepLogging': (context) => SleepLoggingScreen(),
        '/ppg': (context) =>
            PPGScreen(cameras: cameras), // Camera list to pass to the PPGScreen
      },
      onGenerateRoute: (settings) {
        // Handling dynamic routing with parameters
        if (settings.name == '/moodLogging') {
          final args = settings.arguments as DateTime?;
          if (args != null) {
            return MaterialPageRoute(
              builder: (context) => MoodLoggingScreen(selectedDate: args),
            );
          } else {
            return MaterialPageRoute(
              builder: (context) =>
                  CalendarScreen(), // Fallback to CalendarScreen if no date provided
            );
          }
        }
        return null; // Let other routes be handled by onUnknownRoute
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => CalendarScreen());
      },
    );
  }
}
