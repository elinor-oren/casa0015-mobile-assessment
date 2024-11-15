// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAewY6VwEIXXKyqnFqpYVOnRvnCQcBoIdQ',
    appId: '1:43165510387:web:696a0f16b77947c5962586',
    messagingSenderId: '43165510387',
    projectId: 'test2-swell-app',
    authDomain: 'test2-swell-app.firebaseapp.com',
    storageBucket: 'test2-swell-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDjGVrT1gOktE7EQpo1aIENpc3llSQO6pA',
    appId: '1:43165510387:android:059d34f16f237685962586',
    messagingSenderId: '43165510387',
    projectId: 'test2-swell-app',
    storageBucket: 'test2-swell-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD95s_oAgFaYD6qO51fAKpe2PU9ARkw7QE',
    appId: '1:43165510387:ios:72a90b6f35446006962586',
    messagingSenderId: '43165510387',
    projectId: 'test2-swell-app',
    storageBucket: 'test2-swell-app.appspot.com',
    iosBundleId: 'com.oreninc.swell',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD95s_oAgFaYD6qO51fAKpe2PU9ARkw7QE',
    appId: '1:43165510387:ios:bd1c550c874cf55d962586',
    messagingSenderId: '43165510387',
    projectId: 'test2-swell-app',
    storageBucket: 'test2-swell-app.appspot.com',
    iosBundleId: 'com.example.test2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAewY6VwEIXXKyqnFqpYVOnRvnCQcBoIdQ',
    appId: '1:43165510387:web:19f3bda329e3d4b9962586',
    messagingSenderId: '43165510387',
    projectId: 'test2-swell-app',
    authDomain: 'test2-swell-app.firebaseapp.com',
    storageBucket: 'test2-swell-app.appspot.com',
  );
}
