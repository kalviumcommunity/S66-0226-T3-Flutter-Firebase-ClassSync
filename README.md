# ClassSync — Firebase Integration

ClassSync is a Flutter + Firebase mobile application built for coaching centers to manage study materials and track assignment completion. This project demonstrates a complete Firebase integration including Authentication, Cloud Firestore CRUD, and Cloud Storage.

---

## Table of Contents

1. [Setup Verification](#setup-verification)
2. [Flutter Project Structure](#flutter-project-structure)
3. [Stateless vs Stateful Widgets](#stateless-vs-stateful-widgets)
4. [Widget Tree & Reactive UI](#widget-tree--reactive-ui)
5. [Hot Reload & DevTools](#hot-reload--devtools)
6. [Navigator & Routes](#navigator--routes)
7. [Project Overview](#project-overview)
8. [Firebase Setup](#firebase-setup)
9. [Authentication](#authentication)
10. [Cloud Firestore](#cloud-firestore)
11. [App Screens](#app-screens)
12. [Reflection](#reflection)
13. [Team Members](#team-members)

---

## Setup Verification

### Flutter SDK Installation Steps

**1. Download Flutter SDK**

Visit [flutter.dev/docs/get-started/install](https://docs.flutter.dev/get-started/install) and download the stable channel SDK for your OS.

On macOS (used in this project):
```bash
# Extract to a preferred directory
cd ~/Kalvium/Sem\ 3/Livebook/Simulated\ Work/
unzip flutter_macos_arm64.zip   # or use git clone

# Add to PATH in ~/.zshrc
export PATH="$PATH:$HOME/Kalvium/Sem\ 3/Livebook/Simulated\ Work/Flutter/flutter/bin"

# Reload shell
source ~/.zshrc
```

**2. Install Android Studio**

- Download from [developer.android.com/studio](https://developer.android.com/studio)
- During setup, check: **Android SDK**, **Android SDK Platform**, **Android Virtual Device (AVD)**
- Open Android Studio → **Plugins** → install **Flutter** and **Dart** plugins

**3. Configure Emulator (AVD)**

- Android Studio → **Device Manager** → **Create Virtual Device**
- Selected: **Pixel 6**, System Image: **Android 13 (API 33)**
- Launch emulator, then verify:

```bash
flutter devices
```

```
Found 2 connected devices:
  macOS (desktop) • macos  • darwin-arm64   • macOS 26.3
  Chrome (web)    • chrome • web-javascript • Google Chrome 145.0
```

**4. Verify with flutter doctor**

```bash
flutter doctor -v
```

```
[✓] Flutter (Channel stable, 3.41.2, on macOS 26.3 darwin-arm64)
    • Flutter version 3.41.2 on channel stable
    • Dart version 3.11.0
    • DevTools version 2.54.1

[✓] Android toolchain - develop for Android devices (Android SDK version 36.1.0)
    • Android SDK at /Users/shebin.cee/Library/Android/sdk
    • Platform android-36.1, build-tools 36.1.0
    • Java version OpenJDK 21 (bundled with Android Studio)
    • All Android licenses accepted.

[!] Xcode - develop for iOS and macOS (Xcode 26.3)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    ✗ CocoaPods not installed (needed only for iOS/macOS plugins)

[✓] Chrome - develop for the web
    • Chrome at /Applications/Google Chrome.app

[✓] Connected device (2 available)
    • macOS (desktop) • macos  • darwin-arm64
    • Chrome (web)    • chrome • web-javascript

[✓] Network resources
    • All expected network resources are available.
```

> **Note:** The Xcode CocoaPods warning only affects iOS/macOS native plugins. Android and web targets work fully.

**5. Create and run first Flutter app**

```bash
# Create new project
flutter create first_flutter_app
cd first_flutter_app

# Run on Chrome (web) or connected Android device
flutter run -d chrome
flutter run -d emulator
```

The default counter app launches successfully on the emulator.

---

## Stateless vs Stateful Widgets

### What is a StatelessWidget?

A `StatelessWidget` has **no mutable state** of its own. It receives all its data through constructor parameters and builds a fixed UI. Flutter only rebuilds it when its **parent** rebuilds and passes new data.

Use it for: headers, labels, static cards, icons, and any UI that is purely derived from its inputs.

```dart
class GreetingWidget extends StatelessWidget {
  final String name;

  const GreetingWidget({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name!');
  }
}
```

> `GreetingWidget` will never rebuild on its own — only when its parent rebuilds and provides a different `name`.

### What is a StatefulWidget?

A `StatefulWidget` maintains an internal `State` object whose fields can change at runtime. Calling `setState()` marks the widget as dirty and schedules a new `build()` call, updating only that subtree.

Use it for: counters, toggles, forms, color switches, animations — anything that reacts to user interaction or time.

```dart
class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int count = 0;

  void increment() {
    setState(() {
      count++; // marks widget dirty → triggers build()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Count: $count'),
        ElevatedButton(onPressed: increment, child: const Text('Increase')),
      ],
    );
  }
}
```

### How Flutter rebuilds only the widgets that change

Flutter maintains three parallel trees:

| Tree | Role | Persistence |
|---|---|---|
| **Widget tree** | Immutable blueprints — recreated every `build()` | Discarded each frame |
| **Element tree** | Mutable wrappers that hold `State` objects | Survive rebuilds when widget type is unchanged |
| **Render tree** | Layout and paint — expensive operations | Updated only when Element signals a change |

When `setState()` is called, Flutter marks just that `Element` as dirty. On the next frame it calls `build()` on that widget, diffs the new widget tree against the old one via the Element tree, and updates only the `RenderObject`s that actually changed. The `_AppBanner` `StatelessWidget` at the top of the demo screen is never touched — only the `StatefulWidget` section that owns the changed state rebuilds.

### Demos in `stateless_stateful_demo.dart`

| Section | Widget type | What it demonstrates |
|---|---|---|
| App Banner | `StatelessWidget` | Static content — built once, never rebuilds |
| Counter | `StatefulWidget` | `setState()` increments `_count`; `AnimatedSwitcher` transitions the digit |
| Color Toggle | `StatefulWidget` | `setState()` cycles `_themeIndex`; `AnimatedContainer` transitions background |
| Visibility Toggle | `StatefulWidget` | `setState()` flips `_visible`; widget added to / removed from the element tree |
| Quick Comparison | `StatelessWidget` | Side-by-side property table — always static |

### When to prefer each type

**Prefer `StatelessWidget` when:**
- The UI is fully determined by constructor arguments
- No user interaction changes what is displayed inside the widget
- You want to signal to other developers that the widget is pure and predictable

**Prefer `StatefulWidget` when:**
- The widget needs to react to button taps, text input, timers, or animations
- You need local state (counters, toggle flags, loading indicators) between builds
- The widget subscribes to a `Stream` or `Future` and updates its UI on new values

### Reflection

Building this demo made one key insight concrete: `setState()` does not "refresh the screen" — it marks a **specific** `State` object as dirty. The Element tree acts as a persistent identity layer between rebuilds; because `_CounterSectionState` is a separate object from `_ColorToggleSectionState`, tapping the counter button never touches the color section, and vice versa. Splitting a large widget into focused `StatefulWidget`s means interactions affect the **smallest possible subtree**, which is essential for both performance and code clarity.

---

## Flutter Project Structure

Flutter projects follow a **layered folder convention** that separates platform code, Dart business logic, and assets. Understanding this layout makes navigation, onboarding, and scaling straightforward.

```
classsync/
├── android/          # Android-specific Gradle config, manifests, and signing keys
├── ios/              # iOS Xcode project (not used in this sprint)
├── lib/              # All Dart source code lives here
│   ├── main.dart          # Entry point — Firebase init + MaterialApp root
│   ├── firebase_options.dart  # Auto-generated by flutterfire configure
│   ├── models/            # Pure Dart classes (no Flutter/Firebase imports)
│   │   └── student.dart
│   ├── services/          # Firebase API wrappers — one file per service
│   │   ├── auth_service.dart
│   │   ├── firestore_service.dart
│   │   └── storage_service.dart
│   └── screens/           # One StatefulWidget or StatelessWidget per screen
│       ├── home_screen.dart
│       ├── login_screen.dart
│       ├── signup_screen.dart
│       ├── widget_tree_screen.dart
│       └── … (10+ more)
├── test/             # Widget and unit tests
│   └── widget_test.dart
├── pubspec.yaml      # Dependency manifest + asset declarations
└── PROJECT_STRUCTURE.md  # Detailed folder-by-folder reference (see this file)
```

### Layer reference table

| Layer | Folder | Responsibility |
|---|---|---|
| Entry point | `lib/main.dart` | Firebase init, theme, auth routing |
| Models | `lib/models/` | Data classes — no UI, no Firebase |
| Services | `lib/services/` | Firebase calls — no UI, returns futures/streams |
| Screens | `lib/screens/` | All UI — reads from services, rebuilds on state changes |
| Tests | `test/` | Widget + unit tests |
| Platform config | `android/`, `ios/` | Native build files — rarely edited by hand |

> Full details, key file snippets, and a scaling guide are in [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md).

---

## Widget Tree & Reactive UI

### What is a widget tree?

In Flutter, **everything is a widget** — text, buttons, layouts, padding, and even invisible helpers like `Center` or `SizedBox`. Widgets are arranged in a **parent–child hierarchy** called the widget tree. The root is always `MaterialApp`, and every screen is a subtree hanging from it.

```
MaterialApp
└── StreamBuilder (listens to auth state)
    └── HomeScreen
        └── Scaffold
            ├── AppBar
            │   └── Text('ClassSync')
            └── Body
                └── WidgetTreeScreen
                    └── Scaffold
                        └── SingleChildScrollView
                            └── Column
                                ├── _ProfileCard          ← static nesting demo
                                │   └── Card → Padding → Column
                                │       ├── Row → CircleAvatar + Column
                                │       │   ├── Text('Alex Rivera')
                                │       │   └── Text('Student')
                                │       └── Divider
                                │           └── Text(bio)
                                ├── _ColorTapCard         ← setState color cycle
                                │   └── AnimatedContainer (color driven by _colorIndex)
                                ├── _CounterCard          ← setState counter increment
                                │   └── AnimatedSwitcher → Text(_counter)
                                └── _VisibilityCard       ← widget added / removed from tree
                                    └── AnimatedSwitcher → Card (conditionally present)
```

### How does the reactive model work?

Flutter's UI is a **function of state**. When state changes, Flutter rebuilds the affected subtree — not the entire screen.

```dart
// 1. User taps the + button
// 2. setState() marks this widget as dirty
setState(() {
  _counter++;   // mutate local state
});
// 3. Flutter calls build() on this widget
// 4. The new widget tree is diffed against the previous one
// 5. Only changed RenderObjects are repainted → efficient!
```

| Step | What happens |
|---|---|
| `setState()` called | Widget marked dirty in the Element tree |
| Next frame | `build()` is called → new widget tree produced |
| Diff (reconciliation) | Element tree compared with previous; only changed nodes updated |
| Repaint | Render tree repaints only the affected `RenderObject`s |

### Why does Flutter rebuild only parts of the tree?

Flutter maintains **three parallel trees**:

| Tree | Role |
|---|---|
| **Widget tree** | Immutable blueprints — lightweight, recreated every `build()` |
| **Element tree** | Mutable objects that hold state — survive rebuilds when the widget type is unchanged |
| **Render tree** | Layout and paint — only updated when the Element tree signals a change |

Because `Element`s hold the state between rebuilds, calling `setState()` on a child does **not** rebuild the parent — making fine-grained UI updates cheap.

### Demos in `widget_tree_screen.dart`

| Demo | Widget used | What it shows |
|---|---|---|
| Profile Card | `Card → Column → Row → CircleAvatar` | Static widget nesting |
| Color Tap | `AnimatedContainer` | `setState` cycles `_colorIndex` → background color changes |
| Counter | `AnimatedSwitcher` + `Text` | `setState` increments `_counter` → digit transitions with animation |
| Visibility Toggle | `AnimatedSwitcher` | `setState` flips `_cardVisible` → widget added to / removed from the tree |

### Reflection

Working through the widget tree demos clarified two things. First, `setState()` does not "refresh the screen" — it marks a **specific widget** as dirty, and only that sub-branch re-runs `build()`. This makes Flutter UIs efficient even on low-end Android devices. Second, the three-tree architecture (Widget → Element → Render) is what makes the diff cheap: lightweight widget objects can be discarded and recreated every frame, while the heavier `Element` and `RenderObject` layers are reused wherever possible. Visualizing the ASCII tree diagram in the app made it much easier to reason about which `setState()` call triggers which repaint boundary.

---

## Hot Reload & DevTools

### 1. Hot Reload

Hot Reload lets you push code changes to a running app in under a second — without restarting or losing the current UI state (scroll position, counter values, form inputs).

**How to use it:**

```bash
# Step 1 — start the app
flutter run

# Step 2 — edit any widget property and save (⌘ S)
# Step 3 — press r in the terminal (or the ⚡ icon in VS Code)
```

**Example — changing a label without restarting:**

```dart
// Before (currently running)
Text('Hello, Flutter!');

// After (save → hot reload → see the change instantly)
Text('Welcome to Hot Reload!');
```

**What Hot Reload can and cannot do:**

| Scenario | Hot Reload? |
|---|---|
| Change widget text, color, padding | ✅ Yes |
| Add a new widget to the tree | ✅ Yes |
| Change `initState()` or global variables | ❌ Hot Restart needed |
| Change `main()` or Firebase init | ❌ Full restart needed |

> Hot Reload works by injecting updated Dart code into the running VM and asking the framework to rebuild the widget tree from scratch — but the `State` objects are preserved, so all stateful data remains intact.

---

### 2. Debug Console

The Debug Console shows `print()` and `debugPrint()` output, framework warnings, and unhandled exceptions in real time.

**Recommended pattern — use `debugPrint()` not `print()`:**

```dart
void increment() {
  setState(() {
    count++;
    debugPrint('Button pressed! Current count: $count');
  });
}
```

`debugPrint()` compared to `print()`:
- Automatically **rate-limits** output to avoid flooding the console
- Truncates very long strings to a readable length
- Identical API — just a drop-in replacement

**What to watch for in the console:**

| Message type | Meaning |
|---|---|
| `flutter: …` | Your own `debugPrint()` output |
| `══╡ EXCEPTION ╞══` | Unhandled exception with full stack trace |
| `RenderFlex overflowed` | Layout overflow — a widget is too wide/tall for its parent |
| `setState() called after dispose()` | Async operation completed after widget was removed |

**Demo screen workflow:**

The `DevToolsDemoScreen` has four buttons that each call `debugPrint()` with a different severity label (`[INFO]`, `[WARN]`, `[ERROR]`, `[DEBUG]`). The output mirrors exactly what appears in the VS Code Debug Console, making it easy to trace which user action triggered which log line.

---

### 3. Flutter DevTools

DevTools is a browser-based suite of debugging and profiling tools. Launch it while your app is running:

```bash
# Activate once
flutter pub global activate devtools

# Launch (or use VS Code: Run → Open DevTools in Browser)
flutter pub global run devtools
```

**Key panels:**

| Panel | What to look for |
|---|---|
| **Widget Inspector** | Full live widget tree; click any node to highlight it on screen; inspect layout constraints and properties |
| **Performance** | Frame timeline — each bar = 1 frame (target ≤ 16 ms / 60 fps); red bars = jank |
| **Memory** | Dart heap over time; identify leaks with the allocation profiler |
| **Network** | Firebase Firestore and Storage requests — status codes, payload size, timing |
| **Logging** | Structured view of all `debugPrint()` output |

**Step-by-step DevTools workflow used in this sprint:**

1. Run `flutter run` → copy the `Observatory` / `DevTools` URL printed in the terminal.
2. Open that URL in Chrome (or click **Open DevTools** in VS Code).
3. Navigate to **Widget Inspector** → click the target icon → tap any widget on the device to see its properties.
4. Navigate to **Performance** → click **Record** → interact with the app (tap buttons, scroll) → click **Stop** → inspect the flame chart for slow frames.
5. Check the **Memory** tab — if the heap grows indefinitely during repeated interactions, a `StreamSubscription` or `AnimationController` is not being disposed.

---

### Reflection

**How does Hot Reload improve development speed?**
Without Hot Reload, every UI tweak requires a full app restart (~10–30 seconds including build time). Hot Reload compresses that to under one second and preserves state — so you can adjust padding, colors, and text in tight feedback loops without navigating back to the screen you were testing.

**Why are debugging and profiling essential?**
`debugPrint()` makes logic flow explicit: instead of guessing which code path ran, you see timestamps and variable values in the console. DevTools' Performance panel reveals problems that are invisible in the source code — a widget that rebuilds 60 times per second when it only needs to rebuild once, or a layout pass that takes 8 ms because a `Column` is trying to measure unbounded children.

**Integrating these tools into a team workflow:**
- **Code review:** Replace all `print()` calls with `debugPrint()` — it is safe to leave in debug builds and silenced in release builds automatically.
- **CI check:** Run `flutter analyze` to catch performance anti-patterns (e.g., building expensive widgets inside `build()`) before merge.
- **Performance budget:** Agree on a "no red frames in DevTools Performance" rule during sprint demos. If a PR introduces jank, identify the responsible widget via the flame chart and refactor before merging.

---

## Navigator & Routes

### How Flutter navigation works

Flutter manages screens using a **navigation stack**. Each new screen pushed onto the stack sits on top of the previous one — like a stack of cards. `pop()` removes the top card, revealing the one below.

```
Stack after pushNamed('/second'):
┌──────────────────────┐  ← top (visible)
│    Second Screen     │
├──────────────────────┤
│     Home Screen      │
└──────────────────────┘

After pop():
┌──────────────────────┐  ← top (visible)
│     Home Screen      │
└──────────────────────┘
```

### Defining named routes in `main.dart`

Centralizing routes in `MaterialApp` means every screen in the app can navigate by name — no need to import target screens at the call site.

```dart
MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: '/',
  routes: {
    '/':        (context) => const HomeScreen(),
    '/second':  (context) => const SecondScreen(),
    '/profile': (context) => const ProfileScreen(),
  },
)
```

### `home_screen.dart` — push to a new screen

```dart
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, '/second');
  },
  child: const Text('Go to Second Screen'),
)
```

### `second_screen.dart` — go back

```dart
ElevatedButton(
  onPressed: () {
    Navigator.pop(context);
  },
  child: const Text('Back to Home'),
)
```

### Passing arguments between screens

```dart
// Sender — HomeScreen
Navigator.pushNamed(
  context,
  '/profile',
  arguments: 'Hello from Home!',
);

// Receiver — ProfileScreen
@override
Widget build(BuildContext context) {
  final message =
      ModalRoute.of(context)!.settings.arguments as String?;
  return Scaffold(
    body: Center(child: Text(message ?? 'No data received')),
  );
}
```

### Navigation method reference

| Method | Effect | When to use |
|---|---|---|
| `Navigator.push(context, route)` | Pushes a `MaterialPageRoute` | Anonymous, one-off screens |
| `Navigator.pushNamed(context, '/x')` | Pushes a named route | Most common — decoupled navigation |
| `Navigator.pushNamed(…, arguments: data)` | Pushes with payload | Passing IDs, messages, objects |
| `Navigator.pop(context)` | Removes top screen | Back buttons, dialog dismissal |
| `Navigator.pushReplacementNamed(context, '/x')` | Replaces current screen | Login → Dashboard (no back) |
| `Navigator.pushNamedAndRemoveUntil(…)` | Clears stack to a route | Logout → Login |

### Demo in `navigation_demo_screen.dart`

The demo uses a **nested `Navigator` widget** so the three inner screens run in their own navigation stack inside a phone-frame UI, without affecting the root app navigator. This is the same pattern Flutter uses for bottom navigation tabs and nested flows.

| Screen | Route | What it shows |
|---|---|---|
| Home page | `/nav/home` | `pushNamed('/nav/second')` and `pushNamed('/nav/profile', arguments: …)` |
| Second page | `/nav/second` | `Navigator.pop(context)` — back to home |
| Profile page | `/nav/profile` | Reads and displays the passed `String` argument |

A live **stack indicator** on each page shows which screens are currently on the stack (e.g., `Home › Profile`).

### Reflection

**How does Navigator manage the screen stack?**
Navigator is a widget that maintains an ordered list of `Route` objects. Each `Route` wraps a builder that produces the screen widget. `push()` appends a route; `pop()` removes the top one. Because it's a widget, you can nest Navigators — tabs, drawers, and bottom sheets all do this internally.

**Benefits of named routes in larger apps:**
- **Decoupling**: The calling screen doesn't need to import the target screen class — it just knows the string path.
- **Centralized route map**: A single place in `main.dart` (or a dedicated `app_router.dart`) lists every navigable destination, making refactoring and auditing easier.
- **Deep linking**: Named routes map naturally to URL paths, enabling web and mobile deep-link support with minimal extra code.
- **Argument contracts**: Defining argument types at the route level documents the data contract between screens, reducing bugs from silent type mismatches.

---

## Project Overview

| Feature | Status |
|---|---|
| Firebase Authentication (email/password) | ✅ |
| Signup with user profile saved to Firestore | ✅ |
| Login with session persistence | ✅ |
| Logout + auth state stream | ✅ |
| Firestore CRUD (Create, Read, Update, Delete) | ✅ |
| Real-time data sync with StreamBuilder | ✅ |
| Firebase Storage (image upload) | ✅ |
| Responsive UI (MediaQuery) | ✅ |

---

## Firebase Setup

### Step 1 — Create Firebase project

1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Click **Add project** → name it `classsync`
3. Enable **Authentication** → Email/Password provider
4. Enable **Cloud Firestore** → Start in test mode
5. Enable **Cloud Storage** → Start in test mode

### Step 2 — Connect Flutter app

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Authenticate Firebase CLI
firebase login

# Link your Firebase project (auto-generates lib/firebase_options.dart)
flutterfire configure
```

### Step 3 — Add dependencies

```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
  firebase_storage: ^12.0.0
```

```bash
flutter pub get
```

### Step 4 — Initialize Firebase in main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ClassSyncApp());
}
```

### Step 5 — Run the app

```bash
flutter run                 # Default device
flutter run -d chrome       # Web browser
flutter run -d emulator     # Android emulator
```

---

## Authentication

### auth_service.dart

All Firebase Auth calls are wrapped in `AuthService` under `lib/services/`:

```dart
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Expose auth state as a stream — StreamBuilder listens to this
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // null means success
    } on FirebaseAuthException catch (e) {
      return _friendlyError(e.code);
    }
  }

  // Log in existing user
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _friendlyError(e.code);
    }
  }

  Future<void> signOut() async => _auth.signOut();
}
```

### Auth Flow

`main.dart` uses `StreamBuilder` to reactively route the user:

```dart
StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SessionSplashScreen(); // loading
    }
    if (snapshot.hasData) {
      return const HomeScreen();   // logged in → dashboard
    }
    return const LoginScreen();   // logged out → login
  },
)
```

### Screens

| Screen | File | Description |
|---|---|---|
| Login | `lib/screens/login_screen.dart` | Email + password sign-in form |
| Signup | `lib/screens/signup_screen.dart` | Registration form + saves profile to Firestore |
| Dashboard | `lib/screens/home_screen.dart` | Shown after successful login |

**Signup also saves user profile data to Firestore:**

```dart
// After Firebase Auth account is created:
await FirestoreService().addUserData(user.uid, {
  'name': nameCtrl.text.trim(),
  'email': emailCtrl.text.trim(),
  'createdAt': DateTime.now().toIso8601String(),
  'role': 'student',
});
```

---

## Cloud Firestore

### firestore_service.dart

Full CRUD operations under `lib/services/firestore_service.dart`:

```dart
class FirestoreService {
  final CollectionReference _tasks =
      FirebaseFirestore.instance.collection('tasks');
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  // CREATE — add a new task
  Future<void> addTask(String title) => _tasks.add({
    'title': title,
    'completed': false,
    'createdAt': Timestamp.now(),
  });

  // READ — real-time stream (UI updates automatically)
  Stream<QuerySnapshot> getTasks() =>
      _tasks.orderBy('createdAt', descending: true).snapshots();

  // UPDATE — edit task title
  Future<void> updateTask(String id, String newTitle) =>
      _tasks.doc(id).update({'title': newTitle});

  // UPDATE — toggle completion status
  Future<void> toggleTask(String id, bool current) =>
      _tasks.doc(id).update({'completed': !current});

  // DELETE — remove a task
  Future<void> deleteTask(String id) => _tasks.doc(id).delete();

  // CREATE (users) — save user profile after signup
  Future<void> addUserData(String uid, Map<String, dynamic> data) =>
      _users.doc(uid).set(data);
}
```

### Real-Time Sync with StreamBuilder

```dart
StreamBuilder<QuerySnapshot>(
  stream: FirestoreService().getTasks(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    final docs = snapshot.data?.docs ?? [];
    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final data = docs[index].data()! as Map<String, dynamic>;
        return Text(data['title']);
      },
    );
  },
)
```

Every add, update, or delete in Firestore **instantly** reflects in the UI without any manual refresh.

---

## App Screens

| Screen | Purpose |
|---|---|
| `login_screen.dart` | Firebase Auth — sign in |
| `signup_screen.dart` | Firebase Auth — register + save Firestore profile |
| `home_screen.dart` | Dashboard after successful login |
| `firestore_screen.dart` | Full CRUD demo with live sync + edit dialog |
| `auth_screen.dart` | Combined login/signup demo screen |
| `storage_screen.dart` | Image upload to Firebase Storage |
| `welcome_screen.dart` | Sprint #2 — StatefulWidget state management |
| `responsive_home.dart` | Sprint #3 — MediaQuery responsive layout |

---

## Problem

Coaching centers rely on WhatsApp or manual methods to share study materials and assignments. This leads to disorganized communication and difficulty tracking student progress.

## Solution

ClassSync provides a centralized platform where teachers can upload study materials and assignments while students can view them and mark tasks as completed.

## Tech Stack

**Frontend:** Flutter, Dart  
**Backend:** Firebase Authentication, Cloud Firestore, Firebase Storage  
**Tools:** Android Studio, GitHub, FlutterFire CLI

---

## Installation

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/ClassSync.git
cd ClassSync

# 2. Install dependencies
flutter pub get

# 3. Connect Firebase (generates lib/firebase_options.dart)
flutterfire configure

# 4. Run the application
flutter run
```

---

## Reflection

### Flutter Environment Setup

**Challenges faced during installation:**

- **PATH configuration on macOS:** The Flutter binary directory needed to be manually added to `~/.zshrc`. Running `flutter` in a new terminal tab initially failed until the shell profile was reloaded with `source ~/.zshrc`.
- **Android NDK corruption:** The NDK directory at `sdk/ndk/28.2.13676358` was missing a `source.properties` file, causing Gradle build failures. Fixed by removing the corrupted directory (`rm -rf ~/Library/Android/sdk/ndk/28.2.13676358`) and allowing a clean re-download.
- **Android licenses:** Running `flutter doctor --android-licenses` was required before the Android toolchain showed as healthy.
- **CocoaPods (iOS):** Not installed since this sprint targets Android and web. Will be needed when adding iOS support.

**How this setup prepares you for building real mobile apps:**

The `flutter doctor` workflow teaches a systematic approach to dependency management — each check maps to a real runtime requirement (JDK for Gradle, Chrome for web debugging, Xcode for iOS). Getting the emulator running early means every code change can be tested on a realistic device frame with the correct screen density, safe area insets, and platform behaviors. The AVD Manager's ability to simulate different Android API levels lets you catch compatibility issues before shipping to real devices.

---

### How does Firebase simplify backend management in mobile apps?

Firebase eliminates the need to build and maintain a custom backend server. Authentication, database, and storage are available as managed services — you write only client-side Dart code. Firestore's real-time `snapshots()` stream means zero polling logic: the UI reacts to database changes automatically. This dramatically reduces the time from idea to working app.

### What did you learn about connecting Flutter with Cloud Services?

- **FlutterFire CLI** auto-generates platform config files (`firebase_options.dart`, `google-services.json`) — no manual JSON editing.
- **`StreamBuilder`** is the idiomatic Flutter pattern for reactive Firebase data: wrap any `Stream` (auth state or Firestore snapshot) and the widget tree rebuilds automatically.
- **Error handling** must be explicit: `FirebaseAuthException.code` gives machine-readable codes (`weak-password`, `email-already-in-use`) that map to user-friendly messages.
- **Auth state as a stream** means navigation is declarative — instead of manually pushing routes on login, `main.dart`'s `StreamBuilder` always renders the correct screen based on the current `User?`.
- **Firestore's update()** method does a partial write — only the specified fields change, leaving others untouched. This is more efficient than `set()` which overwrites the entire document.

---

## Team Members

| Role | Name |
|---|---|
| UI Lead | Shebin |
| Firebase Lead | Arbin |
| Testing & Deployment Lead | Yashasvi |

---

## Future Improvements

- Push notifications for new assignments
- Analytics dashboard for teacher insights
- Video lecture integration
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

| Directory   | Purpose                                                                                          |
| ----------- | ------------------------------------------------------------------------------------------------ |
| `models/`   | Pure data classes with no UI or Firebase logic — easy to test and reuse                          |
| `services/` | Isolates Firebase calls from UI — swap Firebase for a different backend without touching screens |
| `screens/`  | One screen per file — easy to navigate, review, and hand off to teammates                        |

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

Flutter's widget-based architecture changed how I think about UI. In traditional Android development, you imperatively manipulate views. In Flutter, you _describe_ the UI as a function of state — when state changes, `build()` re-runs and Flutter diffs the tree efficiently. This declarative approach makes complex UIs surprisingly manageable.

Dart's null safety (`String?` vs `String`) caught two real bugs during development — values that could have been null at runtime were flagged at compile time. The `async/await` pattern made Firebase calls read like synchronous code despite being network operations, which kept the code readable.

**How this structure helps build complex UIs:**

The `services/` + `screens/` separation was immediately valuable. When building the Firestore screen, I wrote the real-time stream logic once in `FirestoreService.getTasks()` and used it in the UI with a single `StreamBuilder`. If the data source ever changes (e.g., switching from Firestore to a REST API), only the service file changes — the screen is untouched. This is the same principle as MVC/MVVM but expressed naturally through Dart classes.

The `models/` layer keeps data shapes explicit and typed, preventing the "string soup" problem where data is passed around as raw `Map<String, dynamic>` throughout the codebase.

## Assignment: Flutter Architecture & Dart Fundamentals

> **Objective:** Understand Flutter's architecture, widget-based UI system, and Dart language fundamentals for creating interactive, reactive, and visually consistent mobile interfaces.

---

### 1. Flutter's Architecture

Flutter is organized into three core layers:

| Layer               | Language          | Description                                                                              |
| ------------------- | ----------------- | ---------------------------------------------------------------------------------------- |
| **Framework Layer** | Dart              | Material/Cupertino widgets, rendering, layout, animation, gestures, routing              |
| **Engine Layer**    | C++               | Skia/Impeller graphics rendering, text layout, Dart runtime, platform channels           |
| **Embedder Layer**  | Platform-specific | Bridges Flutter to Android/iOS/Web/Desktop; manages surface, input events, and lifecycle |

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

| Dart Feature                       | Benefit for Flutter                                              |
| ---------------------------------- | ---------------------------------------------------------------- |
| **Strong typing + Type Inference** | Catches errors at compile-time; `var` keeps code clean           |
| **Null Safety**                    | Eliminates null pointer crashes at runtime                       |
| **Async/Await + Futures**          | Handles Firebase calls, network requests without blocking the UI |
| **AOT + JIT compilation**          | JIT → fast Hot Reload in dev; AOT → fast startup in production   |
| **Single language**                | UI, logic, and async code all in one language — no JS bridge     |
| **Classes & Objects**              | Clean OOP model for widgets, models, services                    |

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

| Service          | File                                                                       | What it does                                                      |
| ---------------- | -------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| Firebase Auth    | [lib/services/auth_service.dart](lib/services/auth_service.dart)           | `signUp()`, `signIn()`, `signOut()`, `authStateChanges` stream    |
| Cloud Firestore  | [lib/services/firestore_service.dart](lib/services/firestore_service.dart) | `addTask()`, `getTasks()` stream, `toggleTask()`, `deleteTask()`  |
| Firebase Storage | [lib/services/storage_service.dart](lib/services/storage_service.dart)     | `uploadImage(XFile)` with progress callback, returns download URL |

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

---

## Sprint #3 Deliverable — Responsive Layout with MediaQuery & LayoutBuilder

> **Objective:** Build a responsive Flutter UI that adapts to different screen sizes (phone vs tablet) and orientations (portrait vs landscape) using `MediaQuery`, `LayoutBuilder`, and adaptive layout widgets.

**Screen file:** [`lib/screens/responsive_home.dart`](lib/screens/responsive_home.dart)

---

### What This Screen Demonstrates

The `ResponsiveHomeScreen` is a fully adaptive ClassSync dashboard that:

- Detects the **device type** (phone / tablet / desktop) using MediaQuery width breakpoints
- Switches between a **single-column layout** (phone) and a **two-column layout** (tablet)
- Adjusts **portrait vs landscape** orientation to rearrange the hero section
- Uses `FittedBox` to scale text naturally without overflow
- Uses `AspectRatio` to maintain a fixed 21:9 ratio regardless of screen width
- Uses `Wrap` to wrap feature chips and grid cards onto new lines automatically
- Uses `LayoutBuilder` within the feature grid to compute per-card width based on constraints
- Uses `Expanded` / `Flexible` inside `Row` widgets for proportional sizing

---

### Responsive Breakpoints

```dart
static const double _tabletBreakpoint  = 600.0;   // phone < 600 ≤ tablet
static const double _desktopBreakpoint = 900.0;   // tablet < 900 ≤ desktop
```

---

### 1. MediaQuery — Detecting Screen Dimensions

```dart
final mediaQuery   = MediaQuery.of(context);
final double screenWidth  = mediaQuery.size.width;
final double screenHeight = mediaQuery.size.height;
final bool   isPortrait   = mediaQuery.orientation == Orientation.portrait;
final bool   isTablet     = screenWidth >= 600;
final bool   isDesktop    = screenWidth >= 900;
```

These values drive every layout decision — padding, font size, grid columns, and layout orientation.

---

### 2. Adaptive Padding and Font Size

```dart
final double horizontalPadding = isDesktop ? 48 : isTablet ? 32 : 16;
final double titleFontSize     = isDesktop ? 28 : isTablet ? 24 : 20;
final double bodyFontSize      = isTablet  ? 15 : 13;
```

Padding and typography scale up smoothly on larger screens without any hard-coded pixel values.

---

### 3. Adaptive Grid Columns

```dart
final int gridColumns = isDesktop
    ? 3
    : isTablet
        ? 2
        : (isPortrait ? 1 : 2); // phone landscape gets 2 columns
```

This drives the feature card grid — one number controls column count for every device type.

---

### 4. LayoutBuilder — Constraint-Based Responsive Grid

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final double itemWidth =
        (constraints.maxWidth - (columns - 1) * 12) / columns;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: features.map((f) {
        return SizedBox(width: itemWidth, child: _FeatureCard(feature: f));
      }).toList(),
    );
  },
);
```

`LayoutBuilder` provides the **actual available width** at the point of use — not the screen width — so the grid stays correct even when nested inside a `Row` column on tablet.

---

### 5. Conditional Two-Column Layout (Tablet)

```dart
if (isTablet && isPortrait) {
  // tablet portrait → two-column side-by-side layout
  return Row(
    children: [
      Expanded(flex: 4, child: _leftColumn()),   // hero + stats + chips
      SizedBox(width: 24),
      Expanded(flex: 6, child: _rightColumn()),  // features + aspect ratio card
    ],
  );
}
// else → single-column scroll layout for phone
```

---

### 6. FittedBox — Overflow-Safe Text Scaling

```dart
FittedBox(
  fit: BoxFit.scaleDown,
  alignment: Alignment.centerLeft,
  child: Text(
    'Good Morning, Student! 👋',
    style: TextStyle(fontSize: titleFontSize + 2, fontWeight: FontWeight.bold),
  ),
)
```

`FittedBox` shrinks text to fit its parent's width rather than overflowing or wrapping mid-word — essential for headings on small phones.

---

### 7. AspectRatio — Fixed Proportional Container

```dart
AspectRatio(
  aspectRatio: 16 / 9,   // hero visual always 16:9
  child: Container( ... ),
)

AspectRatio(
  aspectRatio: 21 / 9,   // wide banner always 21:9
  child: Container( ... ),
)
```

The container height adjusts automatically as the width changes — no manual height needed.

---

### 8. Wrap — Adaptive Chip Row

```dart
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: _tags.map((tag) => Chip(label: Text(tag))).toList(),
)
```

`Wrap` moves chips to the next line when they no longer fit — critical on narrow phone screens.

---

### 9. Adaptive Footer

```dart
isTablet
    // Tablet: labelled TextButton.icon row
    ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions.map((a) => TextButton.icon(...)).toList(),
      )
    // Phone: compact icon + label column
    : Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actions.map((a) => Column(children: [Icon, Text])).toList(),
      )
```

---

### How to Run & Test

```bash
flutter pub get

# Run on phone emulator (portrait/landscape)
flutter run -d <android-phone-emulator-id>

# Run on tablet emulator
flutter run -d <android-tablet-emulator-id>

# See available devices / emulators
flutter devices
```

1. Launch the app → tap **"Responsive Layout 📐"** (the first highlighted card)
2. The purple banner at the top shows your current screen width, height, and orientation
3. Rotate the device — the layout reshuffles automatically (portrait vs landscape)
4. Run on a tablet emulator — the two-column layout activates automatically

---

### Screenshots

> **To add screenshots:** Run the app on emulators and take screenshots:

| Device                        | Orientation | Layout                                  |
| ----------------------------- | ----------- | --------------------------------------- |
| Pixel 6 (phone — 393 px)      | Portrait    | Single-column                           |
| Pixel 6 (phone — 851 px)      | Landscape   | 2-col grid, side-by-side hero           |
| iPad / Pixel Tablet (768 px+) | Portrait    | Two-column: left stats + right features |

Place screenshots at `assets/screenshots/` and embed them here:

```
![Phone Portrait](assets/screenshots/phone_portrait.png)
![Phone Landscape](assets/screenshots/phone_landscape.png)
![Tablet Portrait](assets/screenshots/tablet_portrait.png)
```

---

### Updated Folder Structure (Sprint #3)

```
lib/screens/
├── home_screen.dart           # Landing page — now includes Sprint #3 card
├── responsive_home.dart       # ← NEW: Sprint #3 responsive layout screen
├── welcome_screen.dart        # Sprint #2
├── architecture_screen.dart
├── hello_flutter_screen.dart
├── counter_screen.dart
├── dart_basics_screen.dart
├── auth_screen.dart
├── firestore_screen.dart
└── storage_screen.dart
```

---

### Reflection

**What challenges did I face making the layout responsive?**

The biggest challenge was making text scale gracefully. On small phones, a font size of 24 can overflow a Card before you realize it. The solution was `FittedBox` — wrapping headings in it means the text shrinks to fit its parent rather than causing a pixel overflow exception. It feels obvious in hindsight but took debugging with the Flutter DevTools visual layout inspector to identify.

The second challenge was the tablet two-column layout. Using a fixed side-by-side `Row` works, but the right column contains a `GridView`-style `Wrap` that calculates card widths from screen width — not column width. Switching to `LayoutBuilder` inside the grid solved this by providing the _actual available width of the column_, not the full screen width.

Orientation changes were easier than expected because Flutter rebuilds the widget tree on rotation. As long as all layout decisions flow from MediaQuery values that are read in `build()`, they update instantly with no additional code.

**How does responsive design improve real-world app usability?**

A fixed-width layout that looks good on a Pixel 6 is cramped and hard to use on an iPhone SE, and wastes space on an iPad. Users increasingly switch between devices — a student might check ClassSync on their phone during a break and on a tablet while studying. Responsive design ensures the information hierarchy, touch targets, and readability are appropriate for each device without shipping separate apps.

On tablets, the two-column layout lets students see their stats and feature shortcuts simultaneously — a genuine productivity improvement over scrolling through a single column. This mirrors how professional apps like Gmail and Slack adapt their layouts for tablets — sidebar + content pane — which is now an expectation, not a novelty.

Flutter makes this relatively straightforward compared to native Android's complex ConstraintLayout XML or iOS AutoLayout — a single Dart file with `MediaQuery` reads and conditional `Row`/`Column` logic covers most real-world responsive needs.

---

## Module 3.26: Firebase Integration (Current Progress)

### Completed in this branch
- Added Firebase Android plugin wiring for Kotlin DSL:
  - `android/settings.gradle.kts`
  - `android/app/build.gradle.kts`
- Improved startup logs in `lib/main.dart` for Firebase init success/fallback visibility.
- Added delivery docs:
  - `plan.md` (module plan)
  - `issues.md` (issue tracking)
  - `manual-guidance.md` (manual setup guide)

### Required manual setup
1. Create/register Firebase Android app with package: `com.classsync.classsync`.
2. Place `google-services.json` at `android/app/google-services.json`.
3. Run:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
flutter pub get
flutter run
```

### Verification evidence (for submission)
- Firebase Console screenshot: Project Settings > Your apps (Android app connected).
- App run screenshot: Firebase-dependent screen working.

### Common issue found during this session
- Flutter plugin builds were blocked because Windows Developer Mode was disabled.
- Fix: enable Developer Mode, then rerun `flutter test` and `flutter run`.

---

## Module 3.27: Integrating Firebase SDKs Using FlutterFire CLI

### Purpose
Use FlutterFire CLI to automate Firebase SDK configuration and keep setup consistent across platforms.

### Steps followed
1. Verified Firebase CLI:
   - `firebase --version`
2. Installed FlutterFire CLI:
   - `dart pub global activate flutterfire_cli`
3. Verified FlutterFire binary (path-based in current shell):
   - `/c/Users/zzjzj/AppData/Local/Pub/Cache/bin/flutterfire.bat --version`
4. Logged in account was verified with:
   - `firebase login:list`
5. Ran FlutterFire configure:

```bash
/c/Users/zzjzj/AppData/Local/Pub/Cache/bin/flutterfire.bat configure \
  --project=classsync-df2de \
  --yes \
  --platforms=android,ios,web \
  --android-package-name=com.classsync.classsync \
  --ios-bundle-id=com.classsync.classsync \
  --overwrite-firebase-options
```

6. Generated/updated config files:
   - `lib/firebase_options.dart`
   - `firebase.json`
   - `android/app/google-services.json`
7. Confirmed app initialization uses generated options in `lib/main.dart`:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
debugPrint('Firebase initialized with DefaultFirebaseOptions');
```

### Required manual run (if you need to reconfigure)
```bash
firebase login
flutterfire configure
flutter pub get
flutter run
```

### Evidence to capture
- Terminal screenshot showing `flutterfire configure` + app run.
- Firebase Console screenshot showing registered/active app.

### Reflection
- FlutterFire CLI reduces manual config errors by generating `lib/firebase_options.dart` automatically.
- Main issue faced was command discovery (`flutterfire` not recognized), fixed by adding Dart global bin path.
- CLI-based setup is preferred because it centralizes and standardizes platform config with fewer manual edits.

---

## Module 3.29: Signup, Login, and Logout Flow with Firebase Auth

### Overview
Built a complete Firebase Auth flow with automatic screen switching based on session state.

### Core flow
- Sign up: creates new account using Firebase Auth.
- Login: signs in existing account.
- Logout: ends session and returns to auth screen.

### Root auth state handling (`main.dart`)

```dart
home: StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return const HomeScreen();
    }
    return const AuthScreen();
  },
),
```

### Auth actions (`auth_screen.dart`)

```dart
await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: email.trim(),
  password: password.trim(),
);
```

```dart
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email.trim(),
  password: password.trim(),
);
```

### Logout (`home_screen.dart`)

```dart
await FirebaseAuth.instance.signOut();
```

### What to test
1. Sign up -> user appears in Firebase Console Authentication > Users.
2. App auto-switches to HomeScreen after signup/login.
3. Logout returns app to AuthScreen.
4. Login again returns to HomeScreen.

### Reflection
- Hardest part: keeping auth transitions clean without manual route calls.
- `StreamBuilder` with `authStateChanges()` simplifies navigation and session sync.
- Logout is essential for user/session security and shared-device safety.

---

## Module 3.28: Firebase Authentication (Email and Password)

### Summary
Implemented Firebase Auth email/password flow with signup, login, auth-state rendering, and sign-out.

### Setup steps
1. Enable **Email/Password** provider in Firebase Console:
   - Authentication > Sign-in method > Email/Password > Enable
2. Ensure dependencies in `pubspec.yaml`:
   - `firebase_core`
   - `firebase_auth`
3. Run:

```bash
flutter pub get
flutter run
```

### Authentication logic snippets

```dart
await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: email.trim(),
  password: password.trim(),
);
```

```dart
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email.trim(),
  password: password.trim(),
);
```

```dart
await FirebaseAuth.instance.signOut();
```

### Where it is implemented
- `lib/screens/auth_screen.dart`
- `lib/services/auth_service.dart`

### Verification evidence to capture
- App screenshot: signup/login success flow.
- Firebase Console screenshot: Authentication > Users with created account.

### Reflection
- Firebase simplifies auth by handling secure identity APIs, token/session lifecycle, and backend sync.
- Compared to custom auth, Firebase reduces risk around password handling and session security.
- Main implementation challenge is provider/environment setup consistency across local machines.

---

## Module 3.30: Persistent Session and Auto-Login with Firebase Auth

### Overview
Implemented persistent login behavior so authenticated users stay signed in after app restart and are routed automatically.

### Root session gate (`main.dart`)

```dart
home: StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SessionSplashScreen();
    }
    if (snapshot.hasData) {
      return const HomeScreen();
    }
    return const AuthScreen();
  },
),
```

### Session behavior
- Logged in user -> app opens directly to HomeScreen after restart.
- Logged out user -> app opens on AuthScreen.
- Logout action (`signOut`) clears session and redirects automatically.

### What to verify
1. Login -> HomeScreen shown.
2. Copy localhost URL from `flutter run`, open same link in another tab or refresh tab -> still HomeScreen.
3. Logout -> AuthScreen shown.
4. Close and reopen app -> stays on AuthScreen.

### Web testing note
- Session persistence works when reopening the same localhost link while app is running.
- Refreshing the tab should also preserve login state.

### Reflection
- Persistent login is essential for user convenience and production UX.
- Firebase simplifies this by restoring sessions and refreshing tokens automatically.
- `authStateChanges()` with `StreamBuilder` removes manual route checks and keeps state-driven navigation clean.
