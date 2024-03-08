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
    apiKey: 'AIzaSyBRhc9xvqNfNk62bJTxubR-sbbocjhOa5w',
    appId: '1:370298050681:web:427bac3531aeaf6c661ca8',
    messagingSenderId: '370298050681',
    projectId: 'tparking-8a873',
    authDomain: 'tparking-8a873.firebaseapp.com',
    databaseURL:
        'https://tparking-8a873-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'tparking-8a873.appspot.com',
    measurementId: 'G-P7GF0ESWN5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB24f2TQEBxTQC7TFr01UjMNPoErsbfl9o',
    appId: '1:370298050681:android:a0fd7b9a9da48ee9661ca8',
    messagingSenderId: '370298050681',
    projectId: 'tparking-8a873',
    storageBucket: 'tparking-8a873.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAAWyIX0RYixaseC33fxTDth37fhLM5LMg',
    appId: '1:370298050681:ios:7280db2dc4a9a743661ca8',
    messagingSenderId: '370298050681',
    projectId: 'tparking-8a873',
    storageBucket: 'tparking-8a873.appspot.com',
    iosClientId:
        '370298050681-j5m23oife0m8jis2v8u62p0uefv3bl8n.apps.googleusercontent.com',
    iosBundleId: 'com.example.tparking',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAAWyIX0RYixaseC33fxTDth37fhLM5LMg',
    appId: '1:370298050681:ios:89a028f6a8bb947a661ca8',
    messagingSenderId: '370298050681',
    projectId: 'tparking-8a873',
    storageBucket: 'tparking-8a873.appspot.com',
    iosClientId:
        '370298050681-6d84f1ok4t354ph5obiiu3456ibllphs.apps.googleusercontent.com',
    iosBundleId: 'com.example.tparking.RunnerTests',
  );
}
