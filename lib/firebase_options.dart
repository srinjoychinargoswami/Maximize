import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// [BUYER CUSTOMIZATION]: Generate this file using FlutterFire CLI
/// Run: flutterfire configure
/// This file contains your Firebase configuration for iOS, Android, Web, and other platforms
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // This is a placeholder implementation
    // Users should run: flutterfire configure
    // to generate the proper Firebase options for their project
    throw UnsupportedError(
      'DefaultFirebaseOptions.currentPlatform is not supported on this platform.\n'
      'Please run `flutterfire configure` to generate Firebase options for your platform.',
    );
  }

  // iOS options
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    databaseURL: '',
    storageBucket: '',
    iosBundleId: 'com.maximize.Maximize',
  );

  // Android options
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    databaseURL: '',
    storageBucket: '',
  );

  // Web options
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    authDomain: '',
    databaseURL: '',
    storageBucket: '',
  );

  // macOS options
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    databaseURL: '',
    storageBucket: '',
    iosBundleId: 'com.maximize.Maximize',
  );

  // Windows options
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    databaseURL: '',
    storageBucket: '',
  );

  // Linux options
  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    databaseURL: '',
    storageBucket: '',
  );
}
