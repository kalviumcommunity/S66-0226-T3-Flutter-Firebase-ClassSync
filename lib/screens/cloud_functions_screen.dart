import 'package:flutter/material.dart';
import '../services/functions_service.dart';

class CloudFunctionsScreen extends StatefulWidget {
  const CloudFunctionsScreen({super.key});

  @override
  State<CloudFunctionsScreen> createState() => _CloudFunctionsScreenState();
}

class _CloudFunctionsScreenState extends State<CloudFunctionsScreen> {
  final _service = FunctionsService();
  final _nameCtrl = TextEditingController(text: 'Alex');
  final _eventNameCtrl = TextEditingController(text: 'ClassSync Learner');

  bool _calling = false;
  bool _creatingDoc = false;
  String? _callResult;
  String? _status;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _eventNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _triggerCallable() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Enter a name before calling the function.');
      return;
    }
    setState(() {
      _calling = true;
      _error = null;
      _status = 'Calling sayHello...';
    });
    try {
      final message = await _service.sayHello(name);
      if (!mounted) return;
      setState(() {
        _callResult = message;
        _status = 'Callable function executed successfully.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _status = 'Callable function failed.';
      });
    } finally {
      if (mounted) setState(() => _calling = false);
    }
  }

  Future<void> _triggerFirestoreEvent() async {
    final displayName = _eventNameCtrl.text.trim();
    if (displayName.isEmpty) {
      setState(() => _error = 'Enter a user name before creating a document.');
      return;
    }
    setState(() {
      _creatingDoc = true;
      _error = null;
      _status = 'Creating Firestore user doc to trigger onCreate...';
    });
    try {
      await _service.createDemoUserDoc(displayName);
      if (!mounted) return;
      setState(() {
        _status =
            'Firestore document created. Check Functions logs for newUserCreated.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _status = 'Firestore trigger test failed.';
      });
    } finally {
      if (mounted) setState(() => _creatingDoc = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Cloud Functions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Serverless event handling demo',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.bolt_outlined, color: Colors.orange.shade700),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Use this screen to test both callable functions and '
                      'Firestore-triggered functions. Then verify logs in '
                      'Firebase Console > Functions > Logs.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange.shade900,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _BlockCard(
              title: '1) Trigger Callable Function',
              color: Colors.deepOrange,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _calling ? null : _triggerCallable,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: _calling
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_outlined),
                    label: Text(_calling ? 'Calling...' : 'Call sayHello'),
                  ),
                  if (_callResult != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Text(
                        'Function response: $_callResult',
                        style: TextStyle(color: Colors.green.shade900),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            _BlockCard(
              title: '2) Trigger Firestore Event Function',
              color: Colors.indigo,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _eventNameCtrl,
                    decoration: InputDecoration(
                      labelText: 'New user display name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _creatingDoc ? null : _triggerFirestoreEvent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: _creatingDoc
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.person_add_alt),
                    label: Text(
                      _creatingDoc
                          ? 'Creating document...'
                          : 'Create users/{id} document',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'After pressing the button, open Firebase Console Logs and '
                    'confirm `newUserCreated` was triggered.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (_status != null) ...[
              const SizedBox(height: 12),
              Text(
                _status!,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  _error!,
                  style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BlockCard extends StatelessWidget {
  final String title;
  final Color color;
  final Widget child;

  const _BlockCard({
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.circle, size: 10, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
