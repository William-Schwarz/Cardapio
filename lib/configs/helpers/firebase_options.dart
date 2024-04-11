import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      apiKey: "AIzaSyBW0jWVb0d3V0IPPOB1ybd7Do83vj7ZLQo",
      authDomain: "cardapio-24614.firebaseapp.com",
      projectId: "kcardapio-24614",
      storageBucket: "cardapio-24614.appspot.com",
      messagingSenderId: "144862329362",
      appId: "1:144862329362:web:3bd560f8694390961db6cb");

  static const FirebaseOptions android = FirebaseOptions(
      apiKey: "AIzaSyBW0jWVb0d3V0IPPOB1ybd7Do83vj7ZLQo",
      authDomain: "cardapio-24614.firebaseapp.com",
      projectId: "kcardapio-24614",
      storageBucket: "cardapio-24614.appspot.com",
      messagingSenderId: "144862329362",
      appId: "1:144862329362:web:3bd560f8694390961db6cb");

  static const FirebaseOptions ios = FirebaseOptions(
      apiKey: "AIzaSyBW0jWVb0d3V0IPPOB1ybd7Do83vj7ZLQo",
      authDomain: "cardapio-24614.firebaseapp.com",
      projectId: "kcardapio-24614",
      storageBucket: "cardapio-24614.appspot.com",
      messagingSenderId: "144862329362",
      appId: "1:144862329362:web:3bd560f8694390961db6cb");

  static const FirebaseOptions macos = FirebaseOptions(
      apiKey: "AIzaSyBW0jWVb0d3V0IPPOB1ybd7Do83vj7ZLQo",
      authDomain: "cardapio-24614.firebaseapp.com",
      projectId: "kcardapio-24614",
      storageBucket: "cardapio-24614.appspot.com",
      messagingSenderId: "144862329362",
      appId: "1:144862329362:web:3bd560f8694390961db6cb");
}
