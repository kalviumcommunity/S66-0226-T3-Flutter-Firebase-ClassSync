# ClassSync - Firebase Integration

ClassSync is a Flutter + Firebase app for coaching centers to manage classrooms, learning materials, assignments, and student progress with real-time sync.

## What the app provides

| Feature                           | Module     | Description                                                          |
| --------------------------------- | ---------- | -------------------------------------------------------------------- |
| Authentication                    | 3.28, 3.29 | Email/password signup, login, and logout                             |
| Session persistence               | 3.30       | Auto-login with Firebase Auth session restore                        |
| Auth routing                      | 3.29       | Screen switching using `authStateChanges()`                          |
| Firestore data model              | 3.31       | Schema design for scalable app data                                  |
| Firestore read operations         | 3.32       | Collection and document reads with real-time streams                 |
| Firestore write/update operations | 3.33       | Safe add, set-merge, and update writes with validation               |
| Firestore real-time sync          | 3.34       | Snapshot listeners for live collection/document updates              |
| Firestore query optimization      | 3.35       | where filters, ordering, and limits for efficient reads              |
| Scrollable views                  | 3.xx       | ListView.builder and GridView.builder for adaptive dashboard layouts |
| Storage integration               | -          | Firebase Storage-ready media handling                                |

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

How do `ListView` and `GridView` improve UI efficiency?

- They give users structured, scrollable access to large amounts of content without crowding the screen.
- They support adaptive layouts that work well across phone, tablet, and desktop widths.

Why are `ListView.builder` and `GridView.builder` recommended for large data sets?

- Builder constructors create widgets lazily, which reduces memory use and keeps scrolling smoother.
- They are a better fit for dynamic data from APIs, Firestore, or local collections.

What performance pitfalls should you avoid?

- Avoid building very large static child lists when a builder can be used instead.
- Avoid nesting multiple independently scrollable widgets without setting constraints or scroll physics correctly.
- Avoid unbounded grids/lists inside columns unless you use `shrinkWrap` and explicit height where needed.

### Screenshots

Add screenshots here after running the app and opening the `Scrollable Views` screen:

- Horizontal `ListView` of upcoming classes
- Responsive `GridView` of study resources
