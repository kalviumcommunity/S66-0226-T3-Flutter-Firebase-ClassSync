import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';

// Entry point — initializes Firebase then launches the app.
void main() async {
  // Required before any async work in main().
  WidgetsFlutterBinding.ensureInitialized();

  // Connect to Firebase using the auto-generated firebase_options.dart.
  // If you haven't run `flutterfire configure` yet, this will fail with a
  // clear error pointing you to the setup steps.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
