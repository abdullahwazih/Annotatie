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
    apiKey: 'AIzaSyDjCMecUdPDultk3pjRbJmx-DOb7Gt0Kg0',
    appId: '1:864288962831:web:79a8c7a882bc634730667a',
    messagingSenderId: '864288962831',
    projectId: 'annotatiev02',
    authDomain: 'annotatiev02.firebaseapp.com',
    storageBucket: 'annotatiev02.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYvJ9zoqT2L27zcRkZbT_gnU5zBq68Uik',
    appId: '1:864288962831:android:f589d1bc145a7bb530667a',
    messagingSenderId: '864288962831',
    projectId: 'annotatiev02',
    storageBucket: 'annotatiev02.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCkcXELsuUENUR1Gh--oRMZd57z7IYX95E',
    appId: '1:864288962831:ios:a02a01a127fe03ac30667a',
    messagingSenderId: '864288962831',
    projectId: 'annotatiev02',
    storageBucket: 'annotatiev02.firebasestorage.app',
    iosBundleId: 'com.example.annotatiev02',
  );
}
