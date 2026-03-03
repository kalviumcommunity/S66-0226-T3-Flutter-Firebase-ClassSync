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

  // ── Add a task ───────────────────────────────────────────────────────────
  /// Adds a new task document to the 'tasks' collection.
  /// Firestore auto-generates a unique document ID.
  Future<void> addTask(String title) {
    return _tasks.add({
      'title': title,
      'completed': false,
      'createdAt': Timestamp.now(),
    });
  }

  // ── Real-time stream ─────────────────────────────────────────────────────
  /// Returns a live stream of all tasks ordered by creation time.
  ///
  /// Every time a document is added, updated, or deleted in Firestore,
  /// this stream emits a new [QuerySnapshot] — the UI re-renders automatically
  /// without any manual refresh. This is the core of Firestore's real-time sync.
  Stream<QuerySnapshot> getTasks() {
    return _tasks.orderBy('createdAt', descending: true).snapshots();
  }

  // ── Toggle completion ────────────────────────────────────────────────────
  Future<void> toggleTask(String id, bool current) {
    return _tasks.doc(id).update({'completed': !current});
  }

  // ── Delete a task ────────────────────────────────────────────────────────
  Future<void> deleteTask(String id) {
    return _tasks.doc(id).delete();
  }
}
