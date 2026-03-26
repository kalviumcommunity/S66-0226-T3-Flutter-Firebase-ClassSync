import 'package:flutter/material.dart';

import '../services/notification_service.dart';

class PushNotificationsScreen extends StatefulWidget {
  const PushNotificationsScreen({super.key});

  @override
  State<PushNotificationsScreen> createState() =>
      _PushNotificationsScreenState();
}

class _PushNotificationsScreenState extends State<PushNotificationsScreen> {
  final _service = NotificationService.instance;
  bool _refreshing = false;
  bool _rotating = false;

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdated);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdated);
    super.dispose();
  }

  void _onServiceUpdated() {
    if (mounted) setState(() {});
  }

  Future<void> _refreshToken() async {
    setState(() => _refreshing = true);
    try {
      await _service.refreshToken();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Token refresh failed: $e')));
      }
    }
    if (mounted) {
      setState(() => _refreshing = false);
    }
  }

  Future<void> _rotateToken() async {
    setState(() => _rotating = true);
    try {
      await _service.rotateToken();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Token rotation failed: $e')));
      }
    }
    if (mounted) {
      setState(() => _rotating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Push Notifications',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Firebase Cloud Messaging demo',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!_service.isAvailable) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Text(
                'Web push is currently unavailable. Ensure `web/firebase-messaging-sw.js` exists and do a full restart.',
                style: TextStyle(color: Colors.amber.shade900, fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.red.shade700,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This screen shows FCM token and incoming message events '
                    '(foreground, opened from background, opened from terminated).',
                    style: TextStyle(
                      color: Colors.red.shade900,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Device Token',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    _service.token ??
                        'Token not available yet. Check permission/device setup.',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: _refreshing ? null : _refreshToken,
                        icon: _refreshing
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.refresh),
                        label: Text(
                          _refreshing ? 'Refreshing...' : 'Refresh Token',
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: (_rotating || _refreshing)
                            ? null
                            : _rotateToken,
                        icon: _rotating
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.sync),
                        label: Text(_rotating ? 'Rotating...' : 'Rotate Token'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _service.clearLogs,
                        icon: const Icon(Icons.clear_all_outlined),
                        label: const Text('Clear Logs'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Message Event Log',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (_service.logs.isEmpty)
                    const Text(
                      'No message events yet. Send a test notification from Firebase Console.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  else
                    ..._service.logs.map(
                      (line) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(line, style: const TextStyle(fontSize: 12)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
