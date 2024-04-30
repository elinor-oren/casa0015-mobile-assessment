// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:lottie/lottie.dart';
// import 'calendar.dart';
// import 'moodLogging.dart';
// import 'sleepLogging.dart';
// import 'ppg.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(InitialLoader());
// }

// // Loader to initialize app resources before running the app; happens during the spalsh screen
// class InitialLoader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SplashScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// // SplashScreen widget setup
// class SplashScreen extends StatelessWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // FutureBuilder loads the cameras asynchronously before the app starts
//     return FutureBuilder<List<CameraDescription>>(
//       future: availableCameras(), // Load cameras asynchronously
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done &&
//             snapshot.hasData) {
//           return AnimatedSplashScreen(
//             duration: 3000,
//             splash: Container(
//               height: double.infinity,
//               width: double.infinity,
//               child: Lottie.asset("assets/loadingLong.json", fit: BoxFit.cover),
//             ),

//             nextScreen: MyApp(
//                 cameras: snapshot
//                     .data!), // Transitions to MyApp after splash, passing camera data.
//             splashTransition: SplashTransition.fadeTransition,
//             backgroundColor: const Color(0xFF141925),
//           );
//         } else if (snapshot.hasError) {
//           return Scaffold(
//               body: Center(
//                   child: Text("Error loading cameras: ${snapshot.error}")));
//         }
//         return Scaffold(
//             body: Center(
//                 child:
//                     CircularProgressIndicator())); // Show loading spinner while waiting
//       },
//     );
//   }
// }

// // Main application widget
// class MyApp extends StatelessWidget {
//   final List<CameraDescription> cameras;

//   const MyApp({Key? key, required this.cameras}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'PPG App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       debugShowCheckedModeBanner: false,
//       home: CalendarScreen(),
//       routes: {
//         '/sleepLogging': (context) => SleepLoggingScreen(),
//         '/ppg': (context) => PPGScreen(cameras: cameras),
//       },
//       onGenerateRoute: (settings) {
//         if (settings.name == '/moodLogging') {
//           final args = settings.arguments as DateTime?;
//           return MaterialPageRoute(
//             builder: (context) => args != null
//                 ? MoodLoggingScreen(selectedDate: args)
//                 : CalendarScreen(),
//           );
//         }
//         return null; // Handle undefined named routes (idk tbh)
//       },
//       onUnknownRoute: (settings) =>
//           MaterialPageRoute(builder: (context) => CalendarScreen()),
//     );
//   }
// }
