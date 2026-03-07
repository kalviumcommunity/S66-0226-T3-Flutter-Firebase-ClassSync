# ClassSync - Firebase Integration

ClassSync is a Flutter + Firebase app for coaching centers to manage classrooms, learning materials, assignments, and student progress with real-time sync.

## What the app provides

| Feature | Description |
|---|---|
| Authentication | Email/password signup, login, and logout |
| Session persistence | Auto-login with Firebase Auth session restore |
| Auth routing | Screen switching using `authStateChanges()` |
| Firestore workflows | Task and classroom-oriented data flows |
| Storage integration | Firebase Storage-ready media handling |

## Tech stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (Dart) |
| App initialization | Firebase Core |
| Identity | Firebase Authentication |
| Database | Cloud Firestore |
| File storage | Firebase Storage |

## Prerequisites

| Requirement | Purpose |
|---|---|
| Flutter SDK | Build and run the Flutter app |
| Android Studio / Chrome | Android emulator or web runtime |
| Firebase project | Backend services and configuration |
| Firebase CLI | Firebase account/project access |
| FlutterFire CLI | Generate platform Firebase config |

Quick checks:

```bash
flutter --version
flutter doctor -v
flutter devices
firebase --version
flutterfire --version
```

## Setup

| Step | Action |
|---|---|
| 1 | Clone and open the repository |
| 2 | Install dependencies |
| 3 | Login and connect Firebase |
| 4 | Verify generated Firebase config files |
| 5 | Enable required Firebase services in console |

Install dependencies:

```bash
flutter pub get
```

Login and connect Firebase:

```bash
firebase login
flutterfire configure
```

Ensure Firebase config files are present:
- `lib/firebase_options.dart`
- `android/app/google-services.json` (Android)

In Firebase Console, enable required services:
- Authentication -> Sign-in method -> Email/Password
- Firestore Database
- Storage

## Run

```bash
flutter run
```

Optional targets:

```bash
flutter run -d chrome
flutter run -d emulator
```

## Authentication and session flow

The app uses Firebase Auth stream-based routing in `lib/main.dart`:

- Loading state while Firebase restores session
- Authenticated user -> `HomeScreen`
- Unauthenticated user -> `AuthScreen`

```dart
home: StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SessionSplashScreen();
    }
    if (snapshot.hasData) return const HomeScreen();
    return const AuthScreen();
  },
)
```

## Firestore data model (schema overview)

Primary collections:

| Collection | Purpose |
|---|---|
| `users` | User profile and role data |
| `classrooms` | Class metadata and ownership |
| `materials` | Learning resources and metadata |
| `assignments` | Assignment definitions and due dates |
| `submissions` | Cross-assignment submission records |
| `announcements` | Broadcast messages for classes |
| `tasks` | User-level task tracking |

Suggested growth-oriented subcollections:

| Subcollection path | Reason |
|---|---|
| `classrooms/{classroomId}/assignments` | Parent-scoped assignment reads |
| `classrooms/{classroomId}/announcements` | Real-time classroom feed |
| `assignments/{assignmentId}/submissions` | High-volume submission growth |

Sample document (`assignments/{assignmentId}`):

```json
{
  "classroomId": "class_11a",
  "title": "Linear Equations Worksheet",
  "description": "Solve questions 1 to 20.",
  "dueAt": "2026-03-20T18:00:00Z",
  "maxScore": 20,
  "status": "published",
  "createdBy": "uid_mentor_01",
  "createdAt": "serverTimestamp",
  "updatedAt": "serverTimestamp"
}
```

## Project structure

```text
classsync/
├── android/
├── ios/
├── web/
├── assets/
├── lib/
│   ├── main.dart
│   ├── firebase_options.dart
│   ├── models/
│   ├── screens/
│   └── services/
├── test/
│   └── widget_test.dart
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

`lib/` contains all app logic and UI, `services/` wraps Firebase APIs, and `screens/` contains presentation layer widgets.

## Key files

| File | Responsibility |
|---|---|
| `lib/main.dart` | Firebase initialization and auth-state routing |
| `lib/screens/auth_screen.dart` | Login/signup UI |
| `lib/screens/home_screen.dart` | Authenticated landing screen and logout |
| `lib/screens/session_splash_screen.dart` | Startup session loading state |
| `lib/services/auth_service.dart` | Auth operations wrapper |
| `lib/services/firestore_service.dart` | Firestore operations wrapper |

## Troubleshooting

| Issue | Fix |
|---|---|
| `flutterfire` not recognized | Add `%LOCALAPPDATA%\Pub\Cache\bin` to PATH and reopen terminal |
| `operation-not-allowed` on auth | Enable Email/Password provider in Firebase Console |
| Web session inconsistency | Re-test using the same localhost link shown by `flutter run` |
