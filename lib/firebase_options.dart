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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAOnD0s0SewcoEp-P22tiNdbqBBX0k3gh0',
    appId: '1:627799520307:web:fc2e8f0c8f3356d8fcdf46',
    messagingSenderId: '627799520307',
    projectId: 'flutter-tunes-app',
    authDomain: 'flutter-tunes-app.firebaseapp.com',
    storageBucket: 'flutter-tunes-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCsZkjWJlhMRBmSIluI9BPVfj1K_QQMlV0',
    appId: '1:627799520307:android:e3dbae151746903bfcdf46',
    messagingSenderId: '627799520307',
    projectId: 'flutter-tunes-app',
    storageBucket: 'flutter-tunes-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBEvmPM1Ig191Fc9E9fzwKhiOz_vJBbskc',
    appId: '1:627799520307:ios:7b5914f1f7cb98f7fcdf46',
    messagingSenderId: '627799520307',
    projectId: 'flutter-tunes-app',
    storageBucket: 'flutter-tunes-app.appspot.com',
    iosBundleId: 'com.yogi.flutterTunes',
  );
}
