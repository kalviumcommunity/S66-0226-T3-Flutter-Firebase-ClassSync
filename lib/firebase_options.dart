import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA6lc3GmYUM1I67foFTg785dp_APBKm6BE',
    appId: '1:117768309220:web:3f3376f91c1461f64f5ff1',
    messagingSenderId: '117768309220',
    projectId: 'classsync-df2de',
    authDomain: 'classsync-df2de.firebaseapp.com',
    storageBucket: 'classsync-df2de.firebasestorage.app',
    measurementId: 'G-B74XC19X0B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBgpi3HTtx5xD2AVdv6A-9MX9FK9OPjzN8',
    appId: '1:117768309220:android:3bfd7cf801ed314c4f5ff1',
    messagingSenderId: '117768309220',
    projectId: 'classsync-df2de',
    storageBucket: 'classsync-df2de.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCiXwhFz8vD9M34M_eC9LuEbvWcpoKoMQs',
    appId: '1:117768309220:ios:b2d4d7a3816376c94f5ff1',
    messagingSenderId: '117768309220',
    projectId: 'classsync-df2de',
    storageBucket: 'classsync-df2de.firebasestorage.app',
    iosBundleId: 'com.classsync.classsync',
  );
}
