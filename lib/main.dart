import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

// Entry point — spins up the root ClassSyncApp widget.
void main() => runApp(const ClassSyncApp());

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
