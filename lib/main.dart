import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

class ClassSyncApp extends StatelessWidget {
  final Object? initError;

  const ClassSyncApp({super.key, this.initError});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Flow Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
        useMaterial3: true,
      ),
      home: initError != null
          ? Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Firebase initialization failed: $initError'),
                ),
              ),
            )
          : StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SessionSplashScreen();
                }
                if (snapshot.hasData) {
                  return const HomeScreen();
                }
                return const LoginScreen();
              },
            ),
    );
  }
}
