# QuestHub

Real-time competitive party game: join a room with friends or strangers, complete physical side quests, submit photo proof, and vote out the fakers. City-based leaderboards, streaks, and badges.

## Status

| Feature | Status |
| --- | --- |
| Auth (email + Google) | ✅ this repo |
| Room system (6-digit codes, matchmaking) | planned |
| Quest engine (Easy → Legendary tiers) | planned |
| Proof submission + voting | planned |
| In-room chat | planned |
| Local leaderboard | planned |
| Profile & badges | planned |

## Stack

Flutter 3.x · Riverpod (AsyncNotifier) · GoRouter · Firebase (Auth, Firestore, Storage, Functions, FCM) · freezed + json_serializable

## Project structure

```
lib/
  core/
    theme/        # all colors, type styles, spacing — never hardcode in widgets
    router/       # GoRouter + auth redirect
    widgets/      # shared building blocks (QhButton, QhTextField)
  features/
    <feature>/
      data/          # repositories + DTO mapping (Firebase lives here)
      domain/        # entities + repository interfaces (no Firebase types)
      presentation/  # screens, widgets, Riverpod providers
```

## Setup

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Connect Firebase (required for live auth)

`lib/firebase_options.dart` is a placeholder. The app boots without it, but all auth actions show a "Firebase is not configured" message until you:

1. Create a Firebase project at <https://console.firebase.google.com> and enable **Authentication → Email/Password + Google** and **Cloud Firestore**.
2. ```sh
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   This rewrites `firebase_options.dart` and adds the platform config files.
3. For Google sign-in on Android, add your debug SHA-1 to the Firebase project settings (`cd android && ./gradlew signingReport`), then re-download `google-services.json` (or re-run `flutterfire configure`).

## Run & test

```sh
flutter run            # launch on a connected device/emulator
flutter test           # unit + widget tests
flutter analyze        # strict lints, zero tolerance
```
