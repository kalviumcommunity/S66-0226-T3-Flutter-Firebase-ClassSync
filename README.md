# ClassSync

ClassSync is a mobile application built using Flutter and Firebase that helps small coaching centers distribute study materials and track assignment completion efficiently.

## Problem

Coaching centers often rely on WhatsApp or manual methods to share study materials and assignments. This leads to disorganized communication and difficulty tracking student progress.

## Solution

ClassSync provides a centralized platform where teachers can upload study materials and assignments while students can view them and mark tasks as completed.

## Features

- User Authentication (Firebase Auth)
- Upload and view study materials
- Assignment creation and tracking
- Real-time database updates
- Responsive mobile UI

## Tech Stack

**Frontend:**
Flutter
Dart

**Backend:**
Firebase Authentication
Cloud Firestore
Firebase Storage

**Tools:**
Android Studio
GitHub
Figma

## App Screens

- Splash Screen
- Login / Signup
- Dashboard
- Study Materials
- Assignments
- Profile Page

## MVP Features

- Secure login and signup
- Study material sharing
- Assignment tracking
- Real-time data sync
- Working APK build

## Installation

1. Clone the repository

`git clone https://github.com/yourusername/ClassSync.git`

2. Install dependencies

`flutter pub get`

3. Run the application

`flutter run`

## Team Members

**UI Lead**: Shebin

**Firebase Lead**: Arbin

**Testing & Deployment Lead**: Yashasvi

## Future Improvements

- Push notifications
- Analytics dashboard
- Video lectures integration
- Multi-center support

---

## Sprint #2 Deliverable

### Setup Instructions

**1. Install Flutter SDK**

Download from [flutter.dev](https://flutter.dev/docs/get-started/install) and follow the guide for your OS.

**2. Verify installation**

```bash
flutter doctor
```

All items should show ✓. Install Android Studio or VS Code with Flutter + Dart extensions.

**3. Clone & run this project**

```bash
git clone https://github.com/yourusername/ClassSync.git
cd ClassSync
flutter pub get
flutter run
```

Run on Android with `flutter run -d android`, on Chrome with `flutter run -d chrome`.

---

### Folder Structure

```
classsync/
├── lib/
│   ├── main.dart                 # App entry point — initializes Firebase and runs ClassSyncApp
│   ├── firebase_options.dart     # Auto-generated Firebase config (run flutterfire configure)
│   │
│   ├── models/                   # Data structures representing real-world entities
│   │   └── student.dart          # Student class — demonstrates Dart OOP, null safety, async
│   │
│   ├── services/                 # Business logic and external API integration
│   │   ├── auth_service.dart     # Wraps Firebase Auth — signUp, signIn, signOut
│   │   ├── firestore_service.dart# Wraps Firestore — addTask, getTasks (real-time stream)
│   │   └── storage_service.dart  # Wraps Firebase Storage — uploadImage with progress
│   │
│   └── screens/                  # One file per UI screen, each a self-contained widget
│       ├── home_screen.dart      # Landing page — navigation hub for all demos
│       ├── welcome_screen.dart   # Sprint #2 screen — StatefulWidget, setState, animations
│       ├── architecture_screen.dart  # Flutter layer diagram + widget tree
│       ├── hello_flutter_screen.dart # StatelessWidget example
│       ├── counter_screen.dart   # StatefulWidget + setState counter
│       ├── dart_basics_screen.dart   # Dart: classes, null safety, async/await
│       ├── auth_screen.dart      # Firebase Auth: sign up / sign in / sign out
│       ├── firestore_screen.dart # Real-time task list via StreamBuilder
│       └── storage_screen.dart   # Image upload with progress bar
│
├── test/
│   └── widget_test.dart          # Widget tests for HomeScreen and CounterScreen
│
├── android/                      # Android-specific configuration
├── ios/                          # iOS-specific configuration
├── web/                          # Web configuration
└── pubspec.yaml                  # Package dependencies and app metadata
```

**Why this structure?**

| Directory | Purpose |
|---|---|
| `models/` | Pure data classes with no UI or Firebase logic — easy to test and reuse |
| `services/` | Isolates Firebase calls from UI — swap Firebase for a different backend without touching screens |
| `screens/` | One screen per file — easy to navigate, review, and hand off to teammates |

**Naming conventions:**
- Files: `snake_case.dart` (e.g. `auth_screen.dart`)
- Classes: `PascalCase` (e.g. `AuthScreen`, `FirestoreService`)
- Variables/methods: `camelCase` (e.g. `signIn()`, `_tapCount`)
- Private members prefixed with `_` (e.g. `_auth`, `_buildCard`)

---

### Welcome Screen — Sprint #2

The [lib/screens/welcome_screen.dart](lib/screens/welcome_screen.dart) screen demonstrates:

- **`Scaffold` + `AppBar`** — standard Material layout
- **`Column`** — arranges icon, title text, and button vertically
- **`onPressed` with `setState`** — tapping the button increments `_tapCount`, cycling through 5 greeting messages and 5 accent colors
- **`AnimatedSwitcher` + `AnimatedContainer`** — smooth transitions when state changes
- **Dark/Light mode toggle** — second `setState` call changes `_isDark`, re-theming the screen

```dart
void _onButtonPressed() {
  setState(() {
    _tapCount++;   // triggers rebuild → new greeting + color
  });
}
```

---

### Demo

> **To add a screenshot:** Run the app with `flutter run`, take a screenshot of the Welcome Screen, and place it at `assets/screenshots/welcome.png`. Then embed it below:

```
![Welcome Screen](assets/screenshots/welcome.png)
```

**How to run and see the Welcome Screen:**
1. `flutter run -d chrome` (or `-d android`)
2. The home screen opens — tap **"Welcome Screen ✨"** (the highlighted indigo card at the top)
3. Tap the **"Try ClassSync"** button — the greeting message and color change with each tap
4. Tap the moon icon in the top-right to toggle dark mode

---

### Reflection

**What I learned about Dart & Flutter:**

Flutter's widget-based architecture changed how I think about UI. In traditional Android development, you imperatively manipulate views. In Flutter, you *describe* the UI as a function of state — when state changes, `build()` re-runs and Flutter diffs the tree efficiently. This declarative approach makes complex UIs surprisingly manageable.

Dart's null safety (`String?` vs `String`) caught two real bugs during development — values that could have been null at runtime were flagged at compile time. The `async/await` pattern made Firebase calls read like synchronous code despite being network operations, which kept the code readable.

**How this structure helps build complex UIs:**

The `services/` + `screens/` separation was immediately valuable. When building the Firestore screen, I wrote the real-time stream logic once in `FirestoreService.getTasks()` and used it in the UI with a single `StreamBuilder`. If the data source ever changes (e.g., switching from Firestore to a REST API), only the service file changes — the screen is untouched. This is the same principle as MVC/MVVM but expressed naturally through Dart classes.

The `models/` layer keeps data shapes explicit and typed, preventing the "string soup" problem where data is passed around as raw `Map<String, dynamic>` throughout the codebase.

## Assignment: Flutter Architecture & Dart Fundamentals

> **Objective:** Understand Flutter's architecture, widget-based UI system, and Dart language fundamentals for creating interactive, reactive, and visually consistent mobile interfaces.

---

### 1. Flutter's Architecture

Flutter is organized into three core layers:

| Layer | Language | Description |
|---|---|---|
| **Framework Layer** | Dart | Material/Cupertino widgets, rendering, layout, animation, gestures, routing |
| **Engine Layer** | C++ | Skia/Impeller graphics rendering, text layout, Dart runtime, platform channels |
| **Embedder Layer** | Platform-specific | Bridges Flutter to Android/iOS/Web/Desktop; manages surface, input events, and lifecycle |

**Key Idea:** Flutter does **not** use native UI components. It renders every pixel itself using the Skia/Impeller engine, ensuring pixel-perfect consistency across Android and iOS from a single codebase.

---

### 2. StatelessWidget vs StatefulWidget

**StatelessWidget**
- Immutable — no internal state.
- `build()` is called once; the UI is fixed.
- Use for: labels, icons, static layouts, decorative containers.

```dart
class HelloFlutterScreen extends StatelessWidget {
  const HelloFlutterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hello Flutter')),
      body: Center(child: Text('Welcome to Flutter!')),
    );
  }
}
```

**StatefulWidget**
- Has mutable internal state managed via a `State<T>` object.
- `setState()` notifies Flutter to re-run `build()` and repaint affected widgets.
- Use for: counters, forms, toggles, anything that changes with user interaction.

```dart
class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int count = 0;

  void increment() {
    setState(() { count++; }); // triggers rebuild
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Count: $count')),
      floatingActionButton: FloatingActionButton(
        onPressed: increment,
        child: Icon(Icons.add),
      ),
    );
  }
}
```

---

### 3. How Flutter Uses the Widget Tree to Build Reactive UIs

Everything in Flutter is a widget. The widget tree is a nested composition:

```
MaterialApp
  └── Scaffold
        ├── AppBar → Text("ClassSync")
        └── Body → Center → Text("Count: $count")
```

When `setState()` is called:
1. Flutter marks the `State` object as **dirty**.
2. It re-runs `build()` for that subtree only.
3. The framework diffs the new widget tree against the old one (element tree reconciliation).
4. Only the changed parts are repainted — this is Flutter's **reactive rendering model**.

This mirrors React's reconciliation and is what makes Flutter smooth and efficient.

---

### 4. Why Dart is Ideal for Flutter

| Dart Feature | Benefit for Flutter |
|---|---|
| **Strong typing + Type Inference** | Catches errors at compile-time; `var` keeps code clean |
| **Null Safety** | Eliminates null pointer crashes at runtime |
| **Async/Await + Futures** | Handles Firebase calls, network requests without blocking the UI |
| **AOT + JIT compilation** | JIT → fast Hot Reload in dev; AOT → fast startup in production |
| **Single language** | UI, logic, and async code all in one language — no JS bridge |
| **Classes & Objects** | Clean OOP model for widgets, models, services |

**Dart example (used in this project):**

```dart
class Student {
  final String name;     // non-nullable — null safety
  final int age;
  String? subject;       // nullable

  Student(this.name, this.age, {this.subject});

  String introduce() => "Hi, I'm $name and I'm $age years old.";

  // Async/Await — mirrors Firebase Firestore fetch pattern
  Future<String> fetchProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Profile loaded for $name';
  }
}

void main() {
  var s1 = Student('Aanya', 20, subject: 'Mathematics'); // type inference
  print(s1.introduce());
}
```

---

### 5. Project Structure

```
lib/
├── main.dart                      # App entry point (StatelessWidget)
├── models/
│   └── student.dart               # Dart class demo (OOP, Null Safety, Async)
└── screens/
    ├── home_screen.dart           # Landing page with navigation cards
    ├── architecture_screen.dart   # Flutter architecture layers + widget tree
    ├── hello_flutter_screen.dart  # StatelessWidget demo
    ├── counter_screen.dart        # StatefulWidget + setState() demo
    └── dart_basics_screen.dart    # Live Dart concepts: Classes, Null Safety, Async
```

---

### 6. Running the Demo

```bash
# Install dependencies
flutter pub get

# Run on Android (recommended — CocoaPods not required)
flutter run -d android

# Run on Chrome
flutter run -d chrome

# Run all tests
flutter test
```

---

## Assignment 2: Firebase Services & Real-Time Data Integration

> **Objective:** Understand how Firebase enables authentication, real-time Firestore sync, and cloud file storage in a Flutter app — replacing an entire backend with a single SDK.

---

### 1. Firebase Setup Steps

**Step 1 — Create a Firebase project**

1. Go to [console.firebase.google.com](https://console.firebase.google.com) → "Add project" → name it `classsync`
2. Enable **Authentication** → Get Started → Email/Password provider → Enable → Save
3. Enable **Firestore Database** → Create database → Start in **test mode** → select region
4. Enable **Storage** → Get Started → Start in **test mode**

**Step 2 — Connect Flutter app via FlutterFire CLI**

```bash
# Install FlutterFire CLI (one-time)
dart pub global activate flutterfire_cli
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Inside your project directory:
flutterfire configure
# → Select your Firebase project
# → Select Android + iOS platforms
# → This auto-generates lib/firebase_options.dart
#   and places google-services.json in android/app/
```

**Step 3 — Add packages** (already done in `pubspec.yaml`):

```yaml
firebase_core: ^3.0.0
firebase_auth: ^5.0.0
cloud_firestore: ^5.0.0
firebase_storage: ^12.0.0
image_picker: ^1.1.2
```

**Step 4 — Initialize Firebase in `main.dart`**:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ClassSyncApp());
}
```

---

### 2. How Firestore Real-Time Sync Works

Firestore uses **persistent WebSocket connections** to push document changes to all connected clients instantly.

```
User A adds a task
    │
    ▼
Firestore server (Cloud)
    │
    ├──▶ User A's device — UI updates
    ├──▶ User B's device — UI updates  ← no refresh needed
    └──▶ User C's device — UI updates
```

In Flutter, this is wired up with `StreamBuilder`:

```dart
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('tasks')
      .orderBy('createdAt', descending: true)
      .snapshots(),   // <-- live stream, not a one-time fetch
  builder: (context, snapshot) {
    final docs = snapshot.data!.docs;
    return ListView(
      children: docs.map((doc) => Text(doc['title'])).toList(),
    );
  },
)
```

Every time a document is added, updated, or deleted, `snapshots()` emits a new `QuerySnapshot` — Flutter rebuilds only the affected widgets automatically. No polling. No `setState`. No manual refresh.

---

### 3. Firebase Services Implemented

| Service | File | What it does |
|---|---|---|
| Firebase Auth | [lib/services/auth_service.dart](lib/services/auth_service.dart) | `signUp()`, `signIn()`, `signOut()`, `authStateChanges` stream |
| Cloud Firestore | [lib/services/firestore_service.dart](lib/services/firestore_service.dart) | `addTask()`, `getTasks()` stream, `toggleTask()`, `deleteTask()` |
| Firebase Storage | [lib/services/storage_service.dart](lib/services/storage_service.dart) | `uploadImage(XFile)` with progress callback, returns download URL |

---

### 4. How Firebase Simplified Backend Management

Before Firebase, a mobile app like ClassSync would require:
- A Node.js / Django server for auth logic
- A PostgreSQL / MongoDB database with REST endpoints
- A file storage server with CDN
- SSL certificates, server maintenance, scaling

With Firebase:
- **No server to manage** — Google handles infrastructure, scaling, and uptime
- **Auth in 3 lines** — `createUserWithEmailAndPassword()` replaces weeks of JWT implementation
- **Real-time sync for free** — no WebSocket server needed, Firestore handles it
- **Storage with one call** — `ref.putData(bytes)` handles chunked upload, retry, and CDN
- **Focus on the app** — the entire backend in this project is ~80 lines of Dart across 3 service files

---

### 5. Updated Project Structure

```
lib/
├── main.dart                      # Async Firebase init + ClassSyncApp root
├── firebase_options.dart          # Auto-generated by flutterfire configure
├── models/
│   └── student.dart               # Dart OOP demo model
├── services/
│   ├── auth_service.dart          # Firebase Auth wrapper
│   ├── firestore_service.dart     # Cloud Firestore CRUD + real-time stream
│   └── storage_service.dart      # Firebase Storage upload with progress
└── screens/
    ├── home_screen.dart           # Landing page — 7 demo cards
    ├── architecture_screen.dart   # Flutter layers + widget tree
    ├── hello_flutter_screen.dart  # StatelessWidget demo
    ├── counter_screen.dart        # StatefulWidget + setState()
    ├── dart_basics_screen.dart    # Dart language concepts
    ├── auth_screen.dart           # Firebase Auth: sign up / sign in / sign out
    ├── firestore_screen.dart      # Live task list via StreamBuilder
    └── storage_screen.dart        # Image upload to Firebase Storage
```

---

### 6. Running the Full Demo

```bash
# One-time: connect to your Firebase project
export PATH="$PATH":"$HOME/.pub-cache/bin"
flutterfire configure

# Run
flutter run -d chrome         # or -d android

# To test real-time sync:
# Open two browser tabs both running the app.
# Add a task in one tab — it appears in the other instantly.
```

