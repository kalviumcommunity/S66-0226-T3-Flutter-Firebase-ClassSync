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

