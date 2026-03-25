import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class FirestoreSecurityScreen extends StatefulWidget {
  const FirestoreSecurityScreen({super.key});

  @override
  State<FirestoreSecurityScreen> createState() =>
      _FirestoreSecurityScreenState();
}

class _FirestoreSecurityScreenState extends State<FirestoreSecurityScreen> {
  final _service = FirestoreService();
  bool _saving = false;
  bool _reading = false;
  String? _status;
  String? _error;
  Map<String, dynamic>? _profile;

  Future<void> _saveMyProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _error = 'Sign in first to write profile data.';
        _status = null;
      });
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
      _status = 'Writing your own profile document...';
    });
    try {
      await _service.addUserData(user.uid, {
        'email': user.email,
        'name': user.displayName ?? 'ClassSync User',
        'role': 'student',
      });
      if (!mounted) return;
      setState(() => _status = 'Write allowed: your profile was updated.');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _status = 'Write denied by auth/rules.';
      });
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _readMyProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _error = 'Sign in first to read profile data.';
        _status = null;
      });
      return;
    }

    setState(() {
      _reading = true;
      _error = null;
      _status = 'Reading your own profile document...';
    });
    try {
      final snap = await _service.getUserData(user.uid);
      final map = snap.data() as Map<String, dynamic>?;
      if (!mounted) return;
      setState(() {
        _profile = map;
        _status = 'Read allowed: profile loaded successfully.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _status = 'Read denied by auth/rules.';
      });
    } finally {
      if (mounted) setState(() => _reading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Firestore Security',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text('Auth + rules access checks', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.shade200),
            ),
            child: Text(
              user == null
                  ? 'You are signed out. Firestore writes/reads should be denied.'
                  : 'Signed in as ${user.email ?? user.uid}. Rules should allow only your own document.',
              style: TextStyle(color: Colors.teal.shade900, height: 1.35),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _saving ? null : _saveMyProfile,
            icon: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.lock_open_outlined),
            label: Text(_saving ? 'Saving...' : 'Write My Profile'),
          ),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            onPressed: _reading ? null : _readMyProfile,
            icon: _reading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.visibility_outlined),
            label: Text(_reading ? 'Reading...' : 'Read My Profile'),
          ),
          if (_status != null) ...[
            const SizedBox(height: 12),
            Text(_status!, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
          if (_error != null) ...[
            const SizedBox(height: 8),
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
          if (_profile != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _profile.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
