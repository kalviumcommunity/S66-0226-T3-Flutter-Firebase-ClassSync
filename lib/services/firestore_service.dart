import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _tasks = FirebaseFirestore.instance.collection(
    'tasks',
  );
  final CollectionReference _users = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<void> addTask({
    required String title,
    required String description,
    DateTime? deadline,
  }) {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw FirebaseAuthException(
        code: 'not-authenticated',
        message: 'Please sign in before writing to Firestore.',
      );
    }
    final now = Timestamp.now();
    return _tasks.add({
      'uid': uid,
      'title': title,
      'description': description,
      'completed': false,
      'dueAt': deadline != null ? Timestamp.fromDate(deadline) : null,
      'createdAt': now,
      'updatedAt': now,
    });
  }

  Future<void> mergeTaskFields(String taskId, Map<String, dynamic> payload) {
    return _tasks.doc(taskId).set(payload, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getTasks() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return const Stream.empty();
    }
    return _tasks
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> queryTasks({
    required bool onlyPending,
    required bool newestFirst,
    required int limit,
  }) {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return const Stream.empty();
    }
    if (onlyPending) {
      return _tasks
          .where('uid', isEqualTo: uid)
          .where('completed', isEqualTo: false)
          .snapshots();
    }
    return _tasks
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: newestFirst)
        .limit(limit)
        .snapshots();
  }

  Stream<DocumentSnapshot> watchTaskDocument(String taskId) {
    return _tasks.doc(taskId).snapshots();
  }

  Stream<QuerySnapshot> getPendingTasks() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return const Stream.empty();
    }
    return _tasks
        .where('uid', isEqualTo: uid)
        .where('completed', isEqualTo: false)
        .snapshots();
  }

  Future<DocumentSnapshot?> getLatestTaskDocument() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    final snapshot = await _tasks
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first;
  }

  Future<void> updateTask(
    String id, {
    String? title,
    String? description,
    bool? completed,
    DateTime? deadline,
  }) {
    final payload = <String, dynamic>{'updatedAt': Timestamp.now()};
    if (title != null) payload['title'] = title;
    if (description != null) payload['description'] = description;
    if (completed != null) payload['completed'] = completed;
    if (deadline != null) payload['dueAt'] = Timestamp.fromDate(deadline);
    return _tasks.doc(id).update(payload);
  }

  Future<void> toggleTask(String id, bool current) {
    return updateTask(id, completed: !current);
  }

  Future<void> deleteTask(String id) {
    return _tasks.doc(id).delete();
  }

  Future<void> addUserData(String uid, Map<String, dynamic> data) {
    final currentUid = _auth.currentUser?.uid;
    if (currentUid == null || currentUid != uid) {
      throw FirebaseAuthException(
        code: 'not-authorized',
        message: 'You can only write your own user profile.',
      );
    }
    final payload = {
      ...data,
      'uid': uid,
      'updatedAt': Timestamp.now(),
      'createdAt': data['createdAt'] ?? Timestamp.now(),
    };
    return _users.doc(uid).set(payload, SetOptions(merge: true));
  }

  Future<DocumentSnapshot> getUserData(String uid) {
    final currentUid = _auth.currentUser?.uid;
    if (currentUid == null || currentUid != uid) {
      throw FirebaseAuthException(
        code: 'not-authorized',
        message: 'You can only read your own user profile.',
      );
    }
    return _users.doc(uid).get();
  }
}
