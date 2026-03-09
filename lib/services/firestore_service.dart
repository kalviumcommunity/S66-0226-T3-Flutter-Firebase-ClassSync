import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _tasks = FirebaseFirestore.instance.collection(
    'tasks',
  );
  final CollectionReference _users = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<void> addTask(String title) {
    return _tasks.add({
      'title': title,
      'completed': false,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getTasks() {
    return _tasks.orderBy('createdAt', descending: true).snapshots();
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

  Future<void> updateTask(String id, String newTitle) {
    return _tasks.doc(id).update({'title': newTitle});
  }

  Future<void> toggleTask(String id, bool current) {
    return _tasks.doc(id).update({'completed': !current});
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
