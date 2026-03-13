import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app_theme.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/session_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Object? initError;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (kIsWeb) {
      try {
        await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      } catch (_) {}
    }
  } catch (e) {
    initError = e;
  }

  if (kIsWeb) {
    debugPrint('Web session persistence enabled where supported.');
  }
  runApp(ClassSyncApp(initError: initError));
}

class ClassSyncApp extends StatefulWidget {
  final Object? initError;

  const ClassSyncApp({super.key, this.initError});

  @override
  State<ClassSyncApp> createState() => _ClassSyncAppState();
}

class _ClassSyncAppState extends State<ClassSyncApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClassSync',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode,
      home: widget.initError != null
          ? Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Firebase initialization failed: ${widget.initError}',
                      ),
                    ),
                  ),
                ),
              ),
            )
          : StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SessionSplashScreen();
                }
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 56,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Authentication temporarily unavailable',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Please check your connection and try again.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 14),
                            FilledButton.icon(
                              onPressed: () => setState(() {}),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return HomeScreen(
                    currentThemeMode: _themeMode,
                    onThemeModeChanged: _setThemeMode,
                  );
                }
                return const LoginScreen();
              },
            ),
    );
  }
}
