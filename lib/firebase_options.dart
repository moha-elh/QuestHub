// PLACEHOLDER — replace by running:
//
//   dart pub global activate flutterfire_cli
//   flutterfire configure
//
// That command overwrites this file with your real Firebase project config
// (and drops google-services.json / GoogleService-Info.plist into the
// platform folders). Until then the app boots with auth disabled and every
// auth action shows a "Firebase is not configured" message.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => const FirebaseOptions(
        apiKey: 'PLACEHOLDER-RUN-FLUTTERFIRE-CONFIGURE',
        appId: '1:000000000000:android:0000000000000000000000',
        messagingSenderId: '000000000000',
        projectId: 'questhub-placeholder',
        storageBucket: 'questhub-placeholder.appspot.com',
      );
}
