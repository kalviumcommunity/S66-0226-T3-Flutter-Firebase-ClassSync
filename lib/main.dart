import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';

// Entry point — initializes Firebase then launches the app.
void main() async {
  // Required before any async work in main().
  WidgetsFlutterBinding.ensureInitialized();

  // Try to connect to Firebase. If `flutterfire configure` hasn't been run yet
  // (placeholder values in firebase_options.dart), the app still launches —
  // Firebase screens will show a friendly "not configured" message instead of crashing.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // Firebase not configured yet — app runs in demo mode.
    // Run `flutterfire configure` to enable Firebase screens.
  }

  runApp(const ClassSyncApp());
}

/// Root StatelessWidget — sets up MaterialApp theme and starts at HomeScreen.
class ClassSyncApp extends StatelessWidget {
  const ClassSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClassSync — Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
