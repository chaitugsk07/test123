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
    apiKey: 'AIzaSyCxUWeHkOv4kd51cBsXjJmpe-nn3NlpOds',
    appId: '1:456154860004:web:85ae7c96f31dcecd625ff1',
    messagingSenderId: '456154860004',
    projectId: 'synopse',
    authDomain: 'synopse.firebaseapp.com',
    storageBucket: 'synopse.appspot.com',
    measurementId: 'G-2JW1ZRVRQ8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDGFMMAfeqa7yT3WUqnIndQlkemkYjl9K8',
    appId: '1:456154860004:android:75856a7da15ecfaa625ff1',
    messagingSenderId: '456154860004',
    projectId: 'synopse',
    storageBucket: 'synopse.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDKKr5WEqgNEztcJBAw8JIC7u3KQJOdjf0',
    appId: '1:456154860004:ios:990f144399b73545625ff1',
    messagingSenderId: '456154860004',
    projectId: 'synopse',
    storageBucket: 'synopse.appspot.com',
    androidClientId: '456154860004-sukt8rham3qqivdlapvsmlhsbb6sjjfq.apps.googleusercontent.com',
    iosClientId: '456154860004-a8sarn9tj9gvfcncmflpeackouncsctc.apps.googleusercontent.com',
    iosBundleId: 'com.example.synopse',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDKKr5WEqgNEztcJBAw8JIC7u3KQJOdjf0',
    appId: '1:456154860004:ios:b71460752c3e48dd625ff1',
    messagingSenderId: '456154860004',
    projectId: 'synopse',
    storageBucket: 'synopse.appspot.com',
    androidClientId: '456154860004-sukt8rham3qqivdlapvsmlhsbb6sjjfq.apps.googleusercontent.com',
    iosClientId: '456154860004-i5074ngol4jhd06ibkum2s3hnokd9h1s.apps.googleusercontent.com',
    iosBundleId: 'com.example.synopse.RunnerTests',
  );
}