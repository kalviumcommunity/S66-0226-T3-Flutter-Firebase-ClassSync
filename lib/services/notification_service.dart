import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint(
    'BG message: ${message.messageId} | ${message.notification?.title}',
  );
}

class NotificationService extends ChangeNotifier {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final List<String> _logs = [];

  String? _token;
  bool _initialized = false;
  bool _available = true;

  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenedSub;
  StreamSubscription<String>? _onTokenRefreshSub;

  List<String> get logs => List.unmodifiable(_logs);
  String? get token => _token;
  bool get isAvailable => _available;

  Future<void> initialize() async {
    if (_initialized) return;

    if (kIsWeb) {
      _addLog('Web FCM requires firebase-messaging-sw.js in web/');
      try {
        await _messaging.getToken();
      } catch (e) {
        final msg = e.toString();
        if (msg.contains('failed-service-worker-registration')) {
          _available = false;
          _addLog(
            'FCM unavailable on web: missing/invalid firebase-messaging-sw.js',
          );
          _initialized = true;
          notifyListeners();
          return;
        }
      }
    }

    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    if (!kIsWeb) {
      await _messaging.setAutoInitEnabled(true);
    }

    _token = await _messaging.getToken();
    _addLog('FCM token loaded');

    _onMessageSub = FirebaseMessaging.onMessage.listen((message) {
      final title = message.notification?.title ?? '(no title)';
      final body = message.notification?.body ?? '(no body)';
      _addLog('Foreground: $title | $body');
    });

    _onMessageOpenedSub = FirebaseMessaging.onMessageOpenedApp.listen((
      message,
    ) {
      final title = message.notification?.title ?? '(no title)';
      _addLog('Opened from notification: $title');
    });

    _onTokenRefreshSub = _messaging.onTokenRefresh.listen((newToken) {
      _token = newToken;
      _addLog('FCM token auto-refreshed');
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      final title = initialMessage.notification?.title ?? '(no title)';
      _addLog('Opened from terminated: $title');
    }

    _initialized = true;
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }

  Future<void> refreshToken() async {
    if (!_available) return;
    final previous = _token;
    _token = await _messaging.getToken();
    if (_token == null) {
      _addLog('FCM token unavailable after refresh');
      return;
    }
    if (previous == _token) {
      _addLog('FCM refresh checked: token unchanged (normal behavior)');
    } else {
      _addLog('FCM token refreshed: token changed');
    }
  }

  Future<void> rotateToken() async {
    if (!_available) return;
    final previous = _token;
    await _messaging.deleteToken();
    _token = await _messaging.getToken();
    if (_token == null) {
      _addLog('FCM rotate failed: token unavailable');
      return;
    }
    if (previous == _token) {
      _addLog('FCM token rotation attempted: token unchanged');
    } else {
      _addLog('FCM token rotated successfully');
    }
  }

  void _addLog(String line) {
    final timestamp = DateTime.now().toIso8601String();
    _logs.insert(0, '[$timestamp] $line');
    if (_logs.length > 40) {
      _logs.removeLast();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _onMessageSub?.cancel();
    _onMessageOpenedSub?.cancel();
    _onTokenRefreshSub?.cancel();
    _onMessageSub = null;
    _onMessageOpenedSub = null;
    _onTokenRefreshSub = null;
    _initialized = false;
    super.dispose();
  }
}
