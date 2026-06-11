# QuestHub

Real-time competitive party game: join a room with friends or strangers, complete physical side quests, submit photo proof, and vote out the fakers. City-based leaderboards, streaks, and badges.

## Status

| Feature | Status |
| --- | --- |
| Auth (email + Google) | ✅ this repo |
| Room system (6-digit codes, matchmaking, lobby) | ✅ this repo |
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

### Connect Firebase (required for live auth & rooms)

`lib/firebase_options.dart` is a placeholder. The app boots without it, but auth and rooms are disabled until Firebase is wired up — full walkthrough in **[FIREBASE_SETUP.md](FIREBASE_SETUP.md)**.

### Cloud Functions

`functions/` holds the lobby edge-case functions (host reassignment when the host disconnects, stale-player eviction driven by a 10s client heartbeat). Deploy with `npm install && npm run deploy` from `functions/` once the project is on the Blaze plan — see FIREBASE_SETUP.md §6.

## Run & test

```sh
flutter run            # launch on a connected device/emulator
flutter test           # unit + widget tests
flutter analyze        # strict lints, zero tolerance
```
