import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
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
    final now = Timestamp.now();
    return _tasks.add({
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
    return _tasks.orderBy('createdAt', descending: true).snapshots();
  }

  Stream<QuerySnapshot> queryTasks({
    required bool onlyPending,
    required bool newestFirst,
    required int limit,
  }) {
    if (onlyPending) {
      return _tasks.where('completed', isEqualTo: false).snapshots();
    }
    return _tasks
        .orderBy('createdAt', descending: newestFirst)
        .limit(limit)
        .snapshots();
  }

  Stream<DocumentSnapshot> watchTaskDocument(String taskId) {
    return _tasks.doc(taskId).snapshots();
  }

  Stream<QuerySnapshot> getPendingTasks() {
    return _tasks.where('completed', isEqualTo: false).snapshots();
  }

  Future<DocumentSnapshot?> getLatestTaskDocument() async {
    final snapshot = await _tasks
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
    return _users.doc(uid).set(data);
  }

  Future<DocumentSnapshot> getUserData(String uid) {
    return _users.doc(uid).get();
  }
}
