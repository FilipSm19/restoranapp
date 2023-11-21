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
    apiKey: 'AIzaSyC72kh6iulYxFwM7oFXR-PdfhCtt5YQTlY',
    appId: '1:781111232273:web:3163ff7320dc521682aeb0',
    messagingSenderId: '781111232273',
    projectId: 'restoranapp-b8482',
    authDomain: 'restoranapp-b8482.firebaseapp.com',
    storageBucket: 'restoranapp-b8482.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBnnTE7HbSe-Smyhg5FeTPnwLEfB8c5MNc',
    appId: '1:781111232273:android:30ebf4376e13077882aeb0',
    messagingSenderId: '781111232273',
    projectId: 'restoranapp-b8482',
    storageBucket: 'restoranapp-b8482.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyATLnhMlo3luRXj7PHOWBnlQVkHuhhutsA',
    appId: '1:781111232273:ios:5f9d0db78940f01b82aeb0',
    messagingSenderId: '781111232273',
    projectId: 'restoranapp-b8482',
    storageBucket: 'restoranapp-b8482.appspot.com',
    iosClientId:
        '781111232273-hf1vrtddk6mkq1mfvl30fiej28iagsmn.apps.googleusercontent.com',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyATLnhMlo3luRXj7PHOWBnlQVkHuhhutsA',
    appId: '1:781111232273:ios:5f9d0db78940f01b82aeb0',
    messagingSenderId: '781111232273',
    projectId: 'restoranapp-b8482',
    storageBucket: 'restoranapp-b8482.appspot.com',
    iosClientId:
        '781111232273-hf1vrtddk6mkq1mfvl30fiej28iagsmn.apps.googleusercontent.com',
    iosBundleId: 'com.example.app',
  );
}
