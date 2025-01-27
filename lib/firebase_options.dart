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
    apiKey: 'AIzaSyB8_7HLDqHR28cHS0ybilC9S_oKY1XlMuk',
    appId: '1:502683254609:web:f383bcb131a56beb7c5d70',
    messagingSenderId: '502683254609',
    projectId: 'tiktokclone-ccd81',
    authDomain: 'tiktokclone-ccd81.firebaseapp.com',
    storageBucket: 'tiktokclone-ccd81.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDL364xfW1zdKTl7L0naqFqSdRMEPTUh-Y',
    appId: '1:502683254609:android:60557ad2decbbf3f7c5d70',
    messagingSenderId: '502683254609',
    projectId: 'tiktokclone-ccd81',
    storageBucket: 'tiktokclone-ccd81.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyALdVCrm9q8H8pDokjMRVOdxeWc_LTVIZQ',
    appId: '1:502683254609:ios:85822d63f89118aa7c5d70',
    messagingSenderId: '502683254609',
    projectId: 'tiktokclone-ccd81',
    storageBucket: 'tiktokclone-ccd81.firebasestorage.app',
    iosBundleId: 'com.example.pushNotifation',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyALdVCrm9q8H8pDokjMRVOdxeWc_LTVIZQ',
    appId: '1:502683254609:ios:85822d63f89118aa7c5d70',
    messagingSenderId: '502683254609',
    projectId: 'tiktokclone-ccd81',
    storageBucket: 'tiktokclone-ccd81.firebasestorage.app',
    iosBundleId: 'com.example.pushNotifation',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB8_7HLDqHR28cHS0ybilC9S_oKY1XlMuk',
    appId: '1:502683254609:web:6669fdffa52a7e817c5d70',
    messagingSenderId: '502683254609',
    projectId: 'tiktokclone-ccd81',
    authDomain: 'tiktokclone-ccd81.firebaseapp.com',
    storageBucket: 'tiktokclone-ccd81.firebasestorage.app',
  );
}
