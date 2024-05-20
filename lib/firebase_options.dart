// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyBknSeYxZeOajDJkoLp9iW-Pi7JLQtQH68',
    appId: '1:750597701177:web:1aec6141bb44cefaea57e8',
    messagingSenderId: '750597701177',
    projectId: 'decoar-bc983',
    authDomain: 'decoar-bc983.firebaseapp.com',
    storageBucket: 'decoar-bc983.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBgztRF-b4z6vRssLZR3qM9UubcFhGBkXc',
    appId: '1:750597701177:android:9d18fbafd11748f8ea57e8',
    messagingSenderId: '750597701177',
    projectId: 'decoar-bc983',
    storageBucket: 'decoar-bc983.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBhM2L_MnaLEGODd1KDMEqi2-Ai8eJa2zk',
    appId: '1:750597701177:ios:e6d6cc7507e6f172ea57e8',
    messagingSenderId: '750597701177',
    projectId: 'decoar-bc983',
    storageBucket: 'decoar-bc983.appspot.com',
    iosBundleId: 'com.example.decoar',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBhM2L_MnaLEGODd1KDMEqi2-Ai8eJa2zk',
    appId: '1:750597701177:ios:255e9c63696c3ce7ea57e8',
    messagingSenderId: '750597701177',
    projectId: 'decoar-bc983',
    storageBucket: 'decoar-bc983.appspot.com',
    iosBundleId: 'com.example.decoar.RunnerTests',
  );
}