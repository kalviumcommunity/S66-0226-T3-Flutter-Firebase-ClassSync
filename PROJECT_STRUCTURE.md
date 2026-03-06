# Flutter Project Structure — ClassSync

This document explains the purpose of every folder and file in a Flutter project, using **ClassSync** as the reference implementation. Understanding this structure is foundational to writing maintainable, scalable mobile apps.

---

## Complete Folder Hierarchy

```
classsync/
│
├── lib/                          ← All Dart source code (your app)
│   ├── main.dart                 ← Entry point — Firebase init + root widget
│   ├── firebase_options.dart     ← Auto-generated Firebase config (FlutterFire CLI)
│   │
│   ├── screens/                  ← One file per screen/page
│   │   ├── login_screen.dart     ← Firebase Auth — sign in
│   │   ├── signup_screen.dart    ← Firebase Auth — register + Firestore profile
│   │   ├── home_screen.dart      ← Dashboard after login
│   │   ├── firestore_screen.dart ← CRUD demo with live sync
│   │   ├── storage_screen.dart   ← Image upload to Firebase Storage
│   │   ├── auth_screen.dart      ← Combined login/signup demo
│   │   ├── welcome_screen.dart   ← Sprint #2: stateful animations
│   │   ├── responsive_home.dart  ← Sprint #3: MediaQuery layout
│   │   ├── architecture_screen.dart
│   │   ├── counter_screen.dart
│   │   ├── dart_basics_screen.dart
│   │   ├── hello_flutter_screen.dart
│   │   └── session_splash_screen.dart
│   │
│   ├── services/                 ← Business logic + Firebase API wrappers
│   │   ├── auth_service.dart     ← FirebaseAuth: signUp, signIn, signOut
│   │   ├── firestore_service.dart← Firestore CRUD + real-time stream
│   │   └── storage_service.dart  ← Firebase Storage: upload + download URL
│   │
│   └── models/                   ← Data classes (plain Dart objects)
│       └── student.dart          ← Dart OOP demo: null safety, async
│
├── android/                      ← Android-specific native files
│   ├── app/
│   │   ├── build.gradle.kts      ← App ID, version, SDK levels, dependencies
│   │   ├── google-services.json  ← Firebase config for Android (generated)
│   │   └── src/
│   │       └── main/
│   │           ├── AndroidManifest.xml  ← Permissions, app metadata
│   │           ├── kotlin/com/classsync/
│   │           │   └── MainActivity.kt  ← Android entry point (thin shell)
│   │           └── res/                 ← Launch icons (mipmap-*), splash XML
│   └── build.gradle.kts          ← Root Gradle config (repositories, plugins)
│
├── ios/                          ← iOS-specific native files
│   └── Runner/
│       ├── Info.plist            ← App display name, permissions, metadata
│       ├── AppDelegate.swift     ← iOS entry point
│       └── Assets.xcassets/      ← App icons for iOS
│
├── web/                          ← Web-specific files
│   ├── index.html                ← HTML shell that loads Flutter web engine
│   └── manifest.json            ← PWA metadata (name, icons, theme color)
│
├── test/                         ← Automated test files
│   └── widget_test.dart          ← Default widget smoke test
│
├── assets/                       ← Static resources (images, fonts, JSON)
│   └── (images, fonts declared in pubspec.yaml)
│
├── pubspec.yaml                  ← Project manifest: dependencies, assets, metadata
├── pubspec.lock                  ← Locked dependency versions (commit this)
├── analysis_options.yaml         ← Dart linting rules
├── .gitignore                    ← Files excluded from Git (build/, .dart_tool/)
├── README.md                     ← Project documentation
└── PROJECT_STRUCTURE.md          ← This file
```

---

## Folder Reference Table

| Folder / File | Category | Purpose |
|---|---|---|
| `lib/` | Source code | All Dart code for your app. Everything here is compiled into the app binary. |
| `lib/main.dart` | Entry point | Called first on launch. Initializes Firebase and sets the root widget. |
| `lib/screens/` | UI layer | One file per screen. Keeps UI code isolated from business logic. |
| `lib/services/` | Logic layer | Wraps external APIs (Firebase Auth, Firestore, Storage). Screens call these instead of Firebase directly. |
| `lib/models/` | Data layer | Plain Dart classes representing app data (e.g., `Student`, `Task`). No UI, no Firebase — pure data. |
| `android/` | Platform | Gradle build scripts and Android native files. Required to produce an `.apk` or `.aab`. |
| `android/app/build.gradle.kts` | Android config | Defines `applicationId`, `minSdkVersion`, `targetSdkVersion`, `versionCode`. |
| `android/app/src/main/AndroidManifest.xml` | Android config | Declares app permissions (camera, internet), intent filters, and activity metadata. |
| `ios/Runner/Info.plist` | iOS config | Declares `NSCameraUsageDescription`, display name, supported orientations. |
| `web/index.html` | Web | HTML shell that bootstraps the Flutter web engine (Wasm/JS). |
| `test/` | Testing | Widget, unit, and integration tests. Run with `flutter test`. |
| `assets/` | Static files | Images, fonts, JSON files bundled inside the app. Must be declared in `pubspec.yaml`. |
| `pubspec.yaml` | Config | Central manifest: package name, version, dependencies, asset declarations. |
| `pubspec.lock` | Config | Auto-generated. Pins exact dependency versions for reproducible builds. |
| `analysis_options.yaml` | Config | Dart linter rules — enforces code style and catches common bugs at compile time. |
| `.gitignore` | Git | Excludes `build/`, `.dart_tool/`, `.idea/`, `*.iml` from version control. |
| `build/` | Generated | Output of `flutter build`. Never edit manually; recreated on each build. |
| `.dart_tool/` | Generated | Dart tooling cache. Excluded from Git, regenerated by `flutter pub get`. |
| `.idea/` | IDE | Android Studio / IntelliJ project settings. Can be committed but often excluded. |

---

## lib/ Deep Dive — Layers Architecture

Flutter apps use a **layered architecture** to separate concerns. Here's how ClassSync organizes `lib/`:

```
lib/
├── main.dart             ← Bootstrap layer
│                            • WidgetsFlutterBinding.ensureInitialized()
│                            • Firebase.initializeApp()
│                            • StreamBuilder routes: LoginScreen ↔ HomeScreen
│
├── screens/              ← Presentation layer (UI only)
│   └── login_screen.dart
│       • Renders form widgets
│       • Calls AuthService.signIn() — never touches Firebase directly
│       • No business logic — just displays data and reacts to user input
│
├── services/             ← Business logic / data access layer
│   └── auth_service.dart
│       • Wraps FirebaseAuth API calls
│       • Translates FirebaseAuthException codes to user-friendly strings
│       • Returns simple types (String? error) — no Flutter widgets
│
└── models/               ← Data layer
    └── student.dart
        • Pure Dart class — no Flutter, no Firebase imports
        • Defines shape of data: fields, types, methods
        • Can be easily unit-tested in isolation
```

**Why this separation matters:**
- A screen can be redesigned without touching the service layer
- A service can switch from Firebase to a REST API without changing any screen
- Models can be tested without running a simulator

---

## Key File Deep Dives

### pubspec.yaml

```yaml
name: classsync
description: Flutter + Firebase learning app
version: 1.0.0+1

environment:
  sdk: '>=3.11.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.0.0      # Required: initializes Firebase
  firebase_auth: ^5.0.0      # Authentication
  cloud_firestore: ^5.0.0    # NoSQL real-time database
  firebase_storage: ^12.0.0  # Cloud file storage
  image_picker: ^1.1.2       # Device image access

flutter:
  uses-material-design: true
  assets:
    - assets/images/         # Declare asset folders here
```

Every package added to `dependencies` must be followed by `flutter pub get` to download it.

---

### android/app/build.gradle.kts (key fields)

```kotlin
android {
    namespace = "com.classsync.classsync"  // Unique app ID on Play Store
    compileSdk = 36

    defaultConfig {
        applicationId = "com.classsync.classsync"
        minSdk = 21          // Minimum Android version (Android 5.0)
        targetSdk = 36       // Tested against Android 14
        versionCode = 1      // Internal build number (increment on release)
        versionName = "1.0"  // User-visible version
    }
}
```

---

### android/app/src/main/AndroidManifest.xml (permissions)

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Required for Firebase and network calls -->
    <uses-permission android:name="android.permission.INTERNET"/>

    <application
        android:label="classsync"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <!-- App opens here on launch -->
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
```

Permissions like camera access (`READ_MEDIA_IMAGES`) or location must be declared here before Flutter plugins can use them.

---

### test/widget_test.dart

```dart
testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  expect(find.text('0'), findsOneWidget);
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  expect(find.text('1'), findsOneWidget);
});
```

Run all tests with:
```bash
flutter test
```

---

## How the Structure Scales

As an app grows, the folder structure evolves predictably:

```
lib/
├── main.dart
├── app/
│   ├── router.dart          ← Named routes (go_router)
│   └── theme.dart           ← App-wide colors and typography
├── screens/
│   ├── auth/                ← Group related screens into subfolders
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   └── home/
│       ├── home_screen.dart
│       └── home_controller.dart
├── services/
├── models/
├── widgets/                 ← Reusable components shared across screens
│   ├── primary_button.dart
│   └── app_text_field.dart
└── utils/                   ← Pure helper functions (no Flutter/Firebase)
    ├── validators.dart
    └── formatters.dart
```

---

## Reflection

### Why is it important to understand each folder's purpose?

A Flutter project immediately contains dozens of files across multiple platforms. Without understanding which folder does what, it is easy to edit the wrong file — for example, modifying `android/app/build.gradle.kts` to change app behavior instead of editing Dart code in `lib/`. Each folder targets a specific runtime: `lib/` compiles to all platforms, `android/` only affects the Android build, `ios/` only affects iOS. Knowing the boundaries prevents platform-specific bugs and wasted debugging time.

### How does a well-organized structure improve teamwork and development speed?

When `screens/`, `services/`, and `models/` are clearly separated:

- **Parallel development** — one team member builds the `LoginScreen` UI while another writes `AuthService` logic. They don't touch the same files, so merge conflicts are minimized.
- **Onboarding speed** — a new team member can find any feature by following the naming convention: the login UI is in `screens/login_screen.dart`, the Firebase call is in `services/auth_service.dart`.
- **Code reviews** — reviewers can focus: a PR touching only `services/` likely has no UI regression risk. A PR touching only `screens/` likely has no backend risk.
- **Testing** — `models/` can be unit-tested with no emulator. `services/` can be tested with Firebase Emulator. `screens/` can be widget-tested. Clean separation makes each layer independently testable.
- **Refactoring safety** — swapping Firebase for a different backend only requires changing files in `services/`. No screen needs to change because screens never call Firebase directly.
