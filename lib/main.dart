import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'features/auth/data/unconfigured_auth_repository.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // With the placeholder firebase_options.dart this can fail — keep the app
  // bootable so screens can be developed before `flutterfire configure`.
  var firebaseReady = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
  } catch (e) {
    debugPrint('Firebase init failed (placeholder config?): $e');
  }

  runApp(
    ProviderScope(
      overrides: [
        if (!firebaseReady)
          authRepositoryProvider.overrideWithValue(
            const UnconfiguredAuthRepository(),
          ),
      ],
      child: const QuestHubApp(),
    ),
  );
}
