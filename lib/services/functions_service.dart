import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> sayHello(String name) async {
    final callable = _functions.httpsCallable('sayHello');
    final result = await callable.call({'name': name});
    final data = result.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return 'Function executed successfully';
  }

  Future<void> createDemoUserDoc(String displayName) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _firestore.collection('users').doc('demo_$now').set({
      'displayName': displayName,
      'createdAt': Timestamp.now(),
      'source': 'cloud-eventhandling-demo',
    });
  }
}
