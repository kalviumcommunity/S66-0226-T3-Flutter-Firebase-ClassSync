import 'package:cloud_firestore/cloud_firestore.dart';

/// FirestoreService — wraps Cloud Firestore CRUD operations.
///
/// Concepts demonstrated:
///  - NoSQL collection/document model
///  - Real-time Stream via .snapshots() — UI updates without refresh
///  - Timestamps for ordering
///  - Async/Await for write operations
class FirestoreService {
  final CollectionReference _tasks =
      FirebaseFirestore.instance.collection('tasks');
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  // ── CREATE: Add a task ───────────────────────────────────────────────────
  /// Adds a new task document to the 'tasks' collection.
  /// Firestore auto-generates a unique document ID.
  Future<void> addTask(String title) {
    return _tasks.add({
      'title': title,
      'completed': false,
      'createdAt': Timestamp.now(),
    });
  }

  // ── READ: Real-time stream ───────────────────────────────────────────────
  /// Returns a live stream of all tasks ordered by creation time.
  ///
  /// Every time a document is added, updated, or deleted in Firestore,
  /// this stream emits a new [QuerySnapshot] — the UI re-renders automatically
  /// without any manual refresh. This is the core of Firestore's real-time sync.
  Stream<QuerySnapshot> getTasks() {
    return _tasks.orderBy('createdAt', descending: true).snapshots();
  }

  // ── UPDATE: Edit task title ──────────────────────────────────────────────
  /// Updates only the title field of an existing task document.
  /// Firestore's update() only writes the specified fields — other fields
  /// (completed, createdAt) remain untouched.
  Future<void> updateTask(String id, String newTitle) {
    return _tasks.doc(id).update({'title': newTitle});
  }

  // ── UPDATE: Toggle completion ────────────────────────────────────────────
  Future<void> toggleTask(String id, bool current) {
    return _tasks.doc(id).update({'completed': !current});
  }

  // ── DELETE: Remove a task ────────────────────────────────────────────────
  Future<void> deleteTask(String id) {
    return _tasks.doc(id).delete();
  }

  // ── CREATE (Users): Save user profile ───────────────────────────────────
  /// Called after signup to persist user profile data in the 'users' collection.
  /// Uses the Firebase Auth UID as the document ID for easy lookup.
  ///
  /// Example:
  /// ```dart
  /// await addUserData(user.uid, {
  ///   'name': 'Alice',
  ///   'email': 'alice@example.com',
  ///   'createdAt': DateTime.now().toIso8601String(),
  /// });
  /// ```
  Future<void> addUserData(String uid, Map<String, dynamic> data) {
    return _users.doc(uid).set(data);
  }

  // ── READ (Users): Fetch user profile once ───────────────────────────────
  Future<DocumentSnapshot> getUserData(String uid) {
    return _users.doc(uid).get();
  }
}
