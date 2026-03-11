# ClassSync - Firebase Integration

ClassSync is a Flutter + Firebase app for coaching centers to manage classrooms, learning materials, assignments, and student progress with real-time sync.

## What the app provides

| Feature                            | Module     | Description                                                          |
| ---------------------------------- | ---------- | -------------------------------------------------------------------- |
| Authentication                     | 3.28, 3.29 | Email/password signup, login, and logout                             |
| Session persistence                | 3.30       | Auto-login with Firebase Auth session restore                        |
| Auth routing                       | 3.29       | Screen switching using `authStateChanges()`                          |
| Firestore data model               | 3.31       | Schema design for scalable app data                                  |
| Firestore read operations          | 3.32       | Collection and document reads with real-time streams                 |
| Firestore write/update operations  | 3.33       | Safe add, set-merge, and update writes with validation               |
| Firestore real-time sync           | 3.34       | Snapshot listeners for live collection/document updates              |
| Firestore query optimization       | 3.35       | where filters, ordering, and limits for efficient reads              |
| Handling user input with forms     | 3.36       | TextFormField validation with submit/reset feedback                  |
| State management with setState     | 3.37       | Local state updates with conditional UI changes                      |
| Reusable custom widgets            | 3.38       | Shared Stateless and Stateful widgets used on multiple screens       |
| Responsive design with adaptive UI | 3.39       | MediaQuery and LayoutBuilder for phone and tablet layouts            |
| Managing images and local assets   | 3.40       | Registering and rendering local images/icons in Flutter              |
| Animations and transitions         | 3.41       | Implicit, explicit, and page transition animations for UX            |
| Scrollable views                   | 3.42       | ListView.builder and GridView.builder for adaptive dashboard layouts |
| Storage integration                | -          | Firebase Storage-ready media handling                                |

## Tech stack

| Layer              | Technology              |
| ------------------ | ----------------------- |
| Frontend           | Flutter (Dart)          |
| App initialization | Firebase Core           |
| Identity           | Firebase Authentication |
| Database           | Cloud Firestore         |
| File storage       | Firebase Storage        |

## Prerequisites

| Requirement             | Purpose                            |
| ----------------------- | ---------------------------------- |
| Flutter SDK             | Build and run the Flutter app      |
| Android Studio / Chrome | Android emulator or web runtime    |
| Firebase project        | Backend services and configuration |
| Firebase CLI            | Firebase account/project access    |
| FlutterFire CLI         | Generate platform Firebase config  |

Quick checks:

```bash
flutter --version
flutter doctor -v
flutter devices
firebase --version
flutterfire --version
```

## Setup

| Step | Action                                       |
| ---- | -------------------------------------------- |
| 1    | Clone and open the repository                |
| 2    | Install dependencies                         |
| 3    | Login and connect Firebase                   |
| 4    | Verify generated Firebase config files       |
| 5    | Enable required Firebase services in console |

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

## 3.30 Authentication and session flow

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

## 3.31 Firestore data model (schema overview)

Primary collections:

| Collection      | Purpose                              |
| --------------- | ------------------------------------ |
| `users`         | User profile and role data           |
| `classrooms`    | Class metadata and ownership         |
| `materials`     | Learning resources and metadata      |
| `assignments`   | Assignment definitions and due dates |
| `submissions`   | Cross-assignment submission records  |
| `announcements` | Broadcast messages for classes       |
| `tasks`         | User-level task tracking             |

Suggested growth-oriented subcollections:

| Subcollection path                       | Reason                         |
| ---------------------------------------- | ------------------------------ |
| `classrooms/{classroomId}/assignments`   | Parent-scoped assignment reads |
| `classrooms/{classroomId}/announcements` | Real-time classroom feed       |
| `assignments/{assignmentId}/submissions` | High-volume submission growth  |

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

## 3.32 Firestore read operations

The app reads Firestore data in three practical ways:

| Read type                  | Where used                           | Widget          |
| -------------------------- | ------------------------------------ | --------------- |
| Collection stream          | Tasks list (`tasks`)                 | `StreamBuilder` |
| Filtered stream            | Pending tasks (`completed == false`) | `StreamBuilder` |
| Single document (one-time) | Latest task document                 | `FutureBuilder` |

Collection stream example:

```dart
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return const CircularProgressIndicator();
    final docs = snapshot.data!.docs;
    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final data = docs[index].data() as Map<String, dynamic>;
        return ListTile(title: Text(data['title'] ?? 'Untitled'));
      },
    );
  },
)
```

Single document read example:

```dart
FutureBuilder<DocumentSnapshot?>(
  future: service.getLatestTaskDocument(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return const CircularProgressIndicator();
    final doc = snapshot.data;
    if (doc == null || !doc.exists) return const Text('No data available');
    final data = doc.data() as Map<String, dynamic>;
    return Text(data['title'] ?? 'Untitled');
  },
)
```

Why streams are useful:

- UI updates instantly when Firestore data changes
- No manual refresh logic needed
- Better fit for dashboards, feeds, and task lists

## 3.36 Handling user input with forms

This module adds a dedicated form demo screen in `lib/screens/user_input_form.dart` to practice:

- collecting input with `TextFormField`
- validating data with `Form` + `GlobalKey<FormState>`
- showing feedback with `SnackBar`
- resetting form state after interaction

### Core form widgets used

```dart
TextFormField(
  controller: _nameController,
  decoration: const InputDecoration(
    labelText: 'Name',
    prefixIcon: Icon(Icons.person_outline),
  ),
  validator: (value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please enter your name';
    if (text.length < 2) return 'Name must be at least 2 characters';
    return null;
  },
)
```

```dart
FilledButton(
  onPressed: _submitForm,
  child: const Text('Submit'),
)
```

```dart
void _submitForm() {
  if (!_formKey.currentState!.validate()) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Form Submitted Successfully!')),
  );
}
```

### Feedback behavior

- validation fails: field-level error appears below invalid inputs
- validation succeeds: success `SnackBar` appears
- reset pressed: form and controllers are cleared

### Suggested screenshot placeholders

- `screenshots/user-input-before.png` (empty form)
- `screenshots/user-input-errors.png` (validation errors visible)
- `screenshots/user-input-success.png` (success SnackBar visible)

### Reflection

Why is input validation important in mobile apps?

- It prevents bad data from being saved and gives immediate guidance to users.

What is the difference between `TextField` and `TextFormField`?

- `TextField` is a basic input widget.
- `TextFormField` integrates with `Form` and supports built-in validator flow.

How does form state management simplify validation?

- `GlobalKey<FormState>` allows validating all fields together with one call (`validate()`), keeping submit logic clean and centralized.

## 3.37 Managing local UI state with setState

This module adds `lib/screens/state_management_demo.dart` to demonstrate local state updates in a `StatefulWidget`.

### What this screen demonstrates

- local state variable (`_counter`)
- increment/decrement/reset actions
- `setState()`-driven UI refresh on each interaction
- conditional UI styling when `_counter >= 5`

### setState examples used

```dart
void _incrementCounter() {
  setState(() {
    _counter++;
  });
}
```

```dart
void _decrementCounter() {
  setState(() {
    if (_counter > 0) {
      _counter--;
    }
  });
}
```

```dart
color: _counter >= 5 ? const Color(0xFFD1FAE5) : const Color(0xFFF8FAFC),
```

### Suggested screenshot placeholders

- `screenshots/state-before.png` (counter at 0)
- `screenshots/state-after.png` (counter incremented)
- `screenshots/state-threshold.png` (counter >= 5 with changed background)

### Reflection

What is the difference between Stateless and Stateful widgets?

- `StatelessWidget` renders fixed UI from immutable inputs.
- `StatefulWidget` can change over time and rebuild based on local state updates.

Why is `setState()` important for Flutter's reactive model?

- It tells Flutter that state changed and triggers a rebuild of the affected widget subtree.

How can improper use of `setState()` affect performance?

- Calling it unnecessarily or in large widget scopes can cause extra rebuild work and reduced UI smoothness.

## 3.38 Reusable custom widgets

This module introduces reusable components in `lib/widgets/` and reuses them across two screens:

- `lib/widgets/reusable_info_card.dart` (Stateless custom widget)
- `lib/widgets/like_toggle_button.dart` (Stateful custom widget)
- Used in:
  - `lib/screens/custom_widgets_demo_screen.dart`
  - `lib/screens/custom_widgets_details_screen.dart`

### Custom widget definitions

```dart
class ReusableInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ReusableInfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
```

```dart
class LikeToggleButton extends StatefulWidget {
  const LikeToggleButton({super.key});

  @override
  State<LikeToggleButton> createState() => _LikeToggleButtonState();
}
```

### Example reuse

```dart
const ReusableInfoCard(
  title: 'Profile',
  subtitle: 'View your account details and learning preferences.',
  icon: Icons.person_outline,
  accent: Color(0xFF0F766E),
  trailing: LikeToggleButton(),
)
```

```dart
const ReusableInfoCard(
  title: 'Announcements',
  subtitle: 'School updates and reminders are grouped in one place.',
  icon: Icons.campaign_outlined,
  accent: Color(0xFF7C3AED),
  trailing: LikeToggleButton(),
)
```

### Suggested screenshot placeholders

- `screenshots/custom-widget-screen-1.png` (widget used on demo screen)
- `screenshots/custom-widget-screen-2.png` (same widget used on details screen)

### Reflection

How do reusable widgets improve development efficiency?

- They remove duplicate UI code and make design updates faster because changes happen in one place.

What challenges did you face while designing modular components?

- Choosing the right input properties (title, subtitle, icon, style) so one widget can serve multiple contexts.

How could your team apply this approach to your full project?

- Move repeated UI patterns (cards, buttons, input rows, empty states) into shared widgets to keep screens smaller and consistent.

## 3.39 Responsive design using MediaQuery and LayoutBuilder

This module adds a dedicated adaptive screen at `lib/screens/mediaquery_layoutbuilder_demo.dart`.

### What it demonstrates

- `MediaQuery` for screen width, height, orientation, and adaptive spacing/font sizing
- `LayoutBuilder` for conditional phone/tablet widget trees
- percentage-based panel sizing to avoid fixed dimensions

### Key code snippets

```dart
final media = MediaQuery.of(context);
final screenWidth = media.size.width;
final isPortrait = media.orientation == Orientation.portrait;
```

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final isTablet = constraints.maxWidth >= 600;
    return isTablet
        ? _TabletPanels(maxWidth: constraints.maxWidth)
        : _MobilePanels(maxWidth: constraints.maxWidth);
  },
)
```

### Suggested screenshot placeholders

- `screenshots/responsive-mobile.png` (phone layout)
- `screenshots/responsive-tablet.png` (tablet layout)

### Reflection

Why is responsiveness important in mobile development?

- It ensures good usability and visual consistency across different device sizes and orientations.

How does `LayoutBuilder` differ from `MediaQuery`?

- `MediaQuery` gives overall device metrics, while `LayoutBuilder` gives local parent constraints for precise widget-tree decisions.

How could your team use these tools to scale app design efficiently?

- By defining breakpoints and adaptive components once, then reusing those patterns across feature screens.

## 3.40 Managing images, icons, and local assets

This module adds local asset management using:

- `assets/images/`
- `assets/icons/`

Configured in `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
```

Screen implementation:

- `lib/screens/assets_demo_screen.dart`

### Asset and icon usage snippets

```dart
Image.asset(
  'assets/images/logo.png',
  width: 82,
  height: 82,
  fit: BoxFit.cover,
)
```

```dart
Container(
  decoration: const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/background.png'),
      fit: BoxFit.cover,
    ),
  ),
)
```

```dart
const Icon(Icons.flutter_dash, color: Colors.blue, size: 40)
const Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 38)
```

### Suggested screenshot placeholders

- `screenshots/assets-display.png` (images + icons shown in app)
- `screenshots/assets-folder-and-pubspec.png` (folder structure + pubspec assets)

### Reflection

What steps are necessary to load assets correctly in Flutter?

- Place files in project folders, register them under `flutter/assets` in `pubspec.yaml`, run `flutter pub get`, and load via `Image.asset` or `AssetImage`.

What common errors did you face while configuring `pubspec.yaml`?

- Incorrect indentation and path mismatches are the most common causes of missing asset errors.

How do proper asset management practices support scalability?

- Organized folders and consistent naming make large projects easier to maintain, reuse, and review across teams.

## 3.41 Adding animations and transitions to improve UX

This module adds a dedicated demo screen:

- `lib/screens/animations_transitions_demo.dart`

### What was implemented

- Implicit animation with `AnimatedContainer`
- Fade animation with `AnimatedOpacity`
- Explicit animation with `AnimationController` + `RotationTransition`
- Custom page transition using `PageRouteBuilder` (slide + fade)

### Code snippets

```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 600),
  curve: Curves.easeInOut,
  width: _expanded ? 220 : 120,
  height: _expanded ? 120 : 180,
)
```

```dart
AnimatedOpacity(
  opacity: _visible ? 1.0 : 0.2,
  duration: const Duration(milliseconds: 600),
  child: Image.asset('assets/images/logo.png', width: 120),
)
```

```dart
RotationTransition(
  turns: _rotationController,
  child: const Icon(Icons.flutter_dash, size: 84),
)
```

```dart
Navigator.of(context).push(
  PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (context, animation, secondaryAnimation) =>
        const _AnimatedDestinationPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      );
    },
  ),
);
```

### Suggested screenshots/GIF placeholders

- `screenshots/animation-container.gif`
- `screenshots/animation-opacity.gif`
- `screenshots/animation-page-transition.gif`

### Reflection

Why are animations important for UX?

- They provide visual feedback, improve perceived smoothness, and guide user attention.

What is the difference between implicit and explicit animations?

- Implicit animations are simpler and animate property changes automatically; explicit animations provide full control through an `AnimationController`.

How can your team apply animations effectively in the main project?

- Use subtle, purposeful animations for state changes and navigation while keeping durations short for responsiveness.

Suggested screenshots for documentation:

- Firestore Console data (`tasks` collection)
- App UI showing task list from Firestore
- UI update after editing Firestore document

## 3.33 Writing and updating Firestore data

The task form writes data to `tasks` with validation and timestamp tracking.

| Operation | Usage in app                                                              |
| --------- | ------------------------------------------------------------------------- |
| Add       | Create task with auto document ID (`add`)                                 |
| Set merge | Merge metadata into existing document (`set` + `SetOptions(merge: true)`) |
| Update    | Update only changed fields (`update`)                                     |

Input form fields:

- Title
- Description

Add operation:

```dart
await service.addTask(
  title: title,
  description: description,
);
```

Set merge operation:

```dart
await service.mergeTaskFields(taskId, {
  'lastWriteMode': 'set-merge',
  'updatedAt': Timestamp.now(),
});
```

Update operation:

```dart
await service.updateTask(
  taskId,
  title: newTitle,
  description: newDescription,
);
```

Why secure writes matter:

- Input validation blocks empty or invalid writes
- `update` prevents accidental full-document overwrite
- `set` with merge allows controlled partial writes
- timestamps help tracking and conflict debugging

## 3.34 Implementing real-time sync with snapshot listeners

This module uses Firestore snapshot listeners so UI updates instantly when data changes.

| Listener type       | Example in app                                 | Result                                      |
| ------------------- | ---------------------------------------------- | ------------------------------------------- |
| Collection snapshot | `tasks.snapshots()` via `StreamBuilder`        | Task list auto-updates on add/update/delete |
| Document snapshot   | `tasks/{taskId}.snapshots()` for selected task | Selected task details update live           |
| Manual listener     | `tasks.snapshots().listen(...)`                | Live activity message for doc changes       |

Collection listener example:

```dart
StreamBuilder<QuerySnapshot>(
  stream: service.getTasks(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return const CircularProgressIndicator();
    final docs = snapshot.data!.docs;
    return ListView.builder(itemCount: docs.length, itemBuilder: ...);
  },
)
```

Document listener example:

```dart
StreamBuilder<DocumentSnapshot>(
  stream: service.watchTaskDocument(taskId),
  builder: (context, snapshot) {
    final data = snapshot.data?.data() as Map<String, dynamic>?;
    return Text(data?['title'] ?? 'No data');
  },
)
```

Why this improves UX:

- No manual refresh required
- Multiple clients stay synced instantly
- UI stays consistent during rapid changes

## 3.35 Structuring Firestore queries, filters, and ordering data

This module adds query controls so the app reads only relevant task data.

| Query type       | Example in app                                 |
| ---------------- | ---------------------------------------------- |
| Filter (`where`) | `where('completed', isEqualTo: false)`         |
| Sort (`orderBy`) | `orderBy('createdAt', descending: true/false)` |
| Limit (`limit`)  | `limit(5/10/20/50)`                            |

Query stream example:

```dart
stream: service.queryTasks(
  onlyPending: onlyPending,
  newestFirst: newestFirst,
  limit: resultLimit,
)
```

Why this helps:

- Faster screen rendering with smaller result sets
- Cleaner UX with user-controlled filters and sorting
- Lower read/bandwidth usage for large collections

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

| File                                       | Responsibility                                 |
| ------------------------------------------ | ---------------------------------------------- |
| `lib/main.dart`                            | Firebase initialization and auth-state routing |
| `lib/screens/auth_screen.dart`             | Login/signup UI                                |
| `lib/screens/home_screen.dart`             | Authenticated landing screen and logout        |
| `lib/screens/session_splash_screen.dart`   | Startup session loading state                  |
| `lib/services/auth_service.dart`           | Auth operations wrapper                        |
| `lib/services/firestore_service.dart`      | Firestore operations wrapper                   |
| `lib/screens/scrollable_views_screen.dart` | Mixed ListView/GridView lesson screen          |

## Troubleshooting

| Issue                           | Fix                                                            |
| ------------------------------- | -------------------------------------------------------------- |
| `flutterfire` not recognized    | Add `%LOCALAPPDATA%\Pub\Cache\bin` to PATH and reopen terminal |
| `operation-not-allowed` on auth | Enable Email/Password provider in Firebase Console             |
| Web session inconsistency       | Re-test using the same localhost link shown by `flutter run`   |

## Scrollable Views with ListView and GridView

This lesson adds a ClassSync-themed screen that demonstrates two common scrolling patterns in Flutter:

- `ListView.builder` for horizontally scrolling upcoming class cards
- `GridView.builder` for a responsive study resources dashboard

The implementation lives in `lib/screens/scrollable_views_screen.dart` and is available from the main demo launcher screen.

### ListView example

Use `ListView.builder` when you have a long or dynamic list and want Flutter to build only visible widgets.

```dart
SizedBox(
  height: 228,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: classrooms.length,
    itemBuilder: (context, index) {
      final classroom = classrooms[index];
      return Container(
        width: 240,
        margin: const EdgeInsets.only(right: 14),
        child: Text(classroom.title),
      );
    },
  ),
)
```

### GridView example

Use `GridView.builder` for grids that may grow over time, such as galleries, module cards, or dashboards.

```dart
GridView.builder(
  physics: const NeverScrollableScrollPhysics(),
  shrinkWrap: true,
  itemCount: resources.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
  ),
  itemBuilder: (context, index) {
    final resource = resources[index];
    return Card(
      child: Center(child: Text(resource.label)),
    );
  },
)
```

### Reflection

How does `ListView` differ from `GridView` in design use cases?

- `ListView` is ideal for one-dimensional feeds (messages, activity logs, timelines).
- `GridView` is ideal for structured, multi-column content (dashboards, galleries, product cards).

Why is `ListView.builder()` more efficient for large lists?

- It lazily builds only visible items instead of rendering the entire list at once.
- This lowers memory usage and improves scrolling performance on large datasets.

What can you do to prevent lag or overflow errors in scrollable views?

- Use builder constructors for dynamic/large lists.
- Constrain nested scrollables with fixed heights or `shrinkWrap` + proper `physics`.
- Keep list item widgets lightweight and avoid expensive rebuilds during scrolling.

### Screenshots

Add screenshots here after running the app and opening the `Scrollable Views` screen:

- Horizontal `ListView` of upcoming classes
- Responsive `GridView` of study resources
