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
    apiKey: 'AIzaSyDtwSR02sddHvy1UrX7aaSPkDEsAD-e5yE',
    appId: '1:399832788898:web:198a47d41ae381fa7f0cfb',
    messagingSenderId: '399832788898',
    projectId: 'coding-minds-flutter',
    authDomain: 'coding-minds-flutter.firebaseapp.com',
    storageBucket: 'coding-minds-flutter.firebasestorage.app',
    measurementId: 'G-SFQYMLRKMX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbQlpMVOJSN6F3U1kNW3OY0Epzlt38SJg',
    appId: '1:399832788898:android:02985bf476b87bb17f0cfb',
    messagingSenderId: '399832788898',
    projectId: 'coding-minds-flutter',
    storageBucket: 'coding-minds-flutter.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBRNlQyewv3O2REMaTu9efMndwRPBtr-Y4',
    appId: '1:399832788898:ios:b3421d70a81ca4387f0cfb',
    messagingSenderId: '399832788898',
    projectId: 'coding-minds-flutter',
    storageBucket: 'coding-minds-flutter.firebasestorage.app',
    iosBundleId: 'com.example.flutterBootstrap',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBRNlQyewv3O2REMaTu9efMndwRPBtr-Y4',
    appId: '1:399832788898:ios:b3421d70a81ca4387f0cfb',
    messagingSenderId: '399832788898',
    projectId: 'coding-minds-flutter',
    storageBucket: 'coding-minds-flutter.firebasestorage.app',
    iosBundleId: 'com.example.flutterBootstrap',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDtwSR02sddHvy1UrX7aaSPkDEsAD-e5yE',
    appId: '1:399832788898:web:428a0e3e4a0010fc7f0cfb',
    messagingSenderId: '399832788898',
    projectId: 'coding-minds-flutter',
    authDomain: 'coding-minds-flutter.firebaseapp.com',
    storageBucket: 'coding-minds-flutter.firebasestorage.app',
    measurementId: 'G-SWFV2GCR74',
  );

}