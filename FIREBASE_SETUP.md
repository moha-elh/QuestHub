# Firebase setup — do this once, then hand the results back

The app code is fully written against Firebase, but `lib/firebase_options.dart` is a placeholder. Follow these steps (~15 min), then see [What to give back](#7-what-to-give-back) at the end.

## 1. Create the project

1. Go to <https://console.firebase.google.com> → **Add project**.
2. Name it `questhub` (any name works — the ID just ends up in config files).
3. Google Analytics: **disable** for now (can be added later), → **Create project**.

## 2. Enable Authentication

1. In the left sidebar: **Build → Authentication** → **Get started**.
2. **Sign-in method** tab → enable **Email/Password** (just the first toggle, not passwordless email links).
3. Same tab → **Add new provider** → enable **Google**. Pick a support email when prompted → **Save**.

## 3. Create the Firestore database

1. **Build → Firestore Database** → **Create database**.
2. Location: pick one close to your players (e.g. `eur3 (europe-west)`); this cannot be changed later.
3. Start in **production mode** — the repo already has a `firestore.rules` file; deploy it later with `firebase deploy --only firestore:rules`, or paste its contents into the **Rules** tab now.

### Composite indexes (needed once rooms go live)

The lobby queries need two composite indexes. Firestore will also offer to auto-create them via an error link the first time each query runs — either way works:

- Collection `rooms`: `code` (Ascending) + `status` (Ascending)
- Collection `rooms`: `isPublic` (Ascending) + `status` (Ascending)

(**Build → Firestore Database → Indexes → Add index**)

## 4. Register the apps — the easy way (recommended)

Skip the manual console steps and let the FlutterFire CLI do everything:

```sh
# one-time installs
npm install -g firebase-tools
dart pub global activate flutterfire_cli

firebase login
flutterfire configure
```

Pick your new project, select **android** and **ios**, accept the default bundle ids (`com.questhub.questhub`). The CLI:

- registers both apps in the Firebase project
- rewrites `lib/firebase_options.dart` with real values
- drops `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist`

> Manual alternative: in the console, **Project settings → Your apps → Add app**, register Android (`com.questhub.questhub`) and iOS (`com.questhub.questhub`), and download the two config files into the paths above. Then tell me, and I'll fill in `firebase_options.dart` by hand from those files.

## 5. SHA-1 fingerprint (required for Google sign-in on Android)

```sh
cd android
./gradlew signingReport        # use .\gradlew on Windows PowerShell
```

Copy the **SHA1** line from the `debug` variant, then in the Firebase console: **Project settings → Your apps → Android app → Add fingerprint** → paste → **Save**. Re-download `google-services.json` afterwards (or re-run `flutterfire configure`).

## 6. (Later, optional) Cloud Functions

The lobby's host-reassignment and stale-player cleanup functions live in `functions/`. They need the **Blaze** (pay-as-you-go) plan:

```sh
cd functions
npm install
npm run deploy
```

Not urgent — the app handles host handoff client-side too; the functions only cover crash/disconnect cases.

## 7. What to give back

**Preferred (nothing to hand over):** just run step 4's `flutterfire configure` — it edits the repo directly. Tell me it's done and I'll verify the wiring (gradle plugin, etc.) in the next session.

**Alternative:** put `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) into the repo at the paths above — or paste me the "Your apps → SDK setup and configuration" config snippet — and I'll wire `firebase_options.dart` and the Gradle changes myself.
