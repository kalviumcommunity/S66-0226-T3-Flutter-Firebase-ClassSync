import 'package:flutter/material.dart';
import 'architecture_screen.dart';
import 'auth_screen.dart';
import 'counter_screen.dart';
import 'dart_basics_screen.dart';
import 'firestore_screen.dart';
import 'hello_flutter_screen.dart';
import 'storage_screen.dart';

/// HomeScreen — StatelessWidget that acts as the landing page.
/// Displays navigation cards for each demo in the assignment.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final _ = color; // used in AppBar backgroundColor

    final demos = [
      _DemoCard(
        title: 'Flutter Architecture',
        subtitle: 'Framework · Engine · Embedder layers explained',
        icon: Icons.layers_outlined,
        color: Colors.indigo,
        screen: const ArchitectureScreen(),
      ),
      _DemoCard(
        title: 'Hello Flutter',
        subtitle: 'StatelessWidget — static UI example',
        icon: Icons.widgets_outlined,
        color: Colors.teal,
        screen: const HelloFlutterScreen(),
      ),
      _DemoCard(
        title: 'Counter App',
        subtitle: 'StatefulWidget — reactive UI with setState()',
        icon: Icons.add_circle_outline,
        color: Colors.deepPurple,
        screen: const CounterScreen(),
      ),
      _DemoCard(
        title: 'Dart Basics',
        subtitle: 'Classes · Null Safety · Type Inference · Async',
        icon: Icons.code,
        color: Colors.orange,
        screen: const DartBasicsScreen(),
      ),

      // ── Concept 2: Firebase ──────────────────────────────────────────────
      _DemoCard(
        title: 'Firebase Auth',
        subtitle: 'Email/Password sign up, sign in, session persistence',
        icon: Icons.lock_outline,
        color: Colors.red,
        screen: const AuthScreen(),
      ),
      _DemoCard(
        title: 'Firestore Real-Time',
        subtitle: 'Live task list — StreamBuilder + Firestore snapshots',
        icon: Icons.sync,
        color: Colors.blue,
        screen: const FirestoreScreen(),
      ),
      _DemoCard(
        title: 'Firebase Storage',
        subtitle: 'Pick an image · Upload · Get download URL',
        icon: Icons.cloud_upload_outlined,
        color: Colors.green,
        screen: const StorageScreen(),
      ),
    ];

    return Scaffold(
      backgroundColor: color.surface,
      appBar: AppBar(
        backgroundColor: color.primary,
        foregroundColor: color.onPrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'ClassSync',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Flutter & Dart Architecture Assignment',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: demos.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildCard(context, demos[index]),
      ),
    );
  }

  Widget _buildCard(BuildContext context, _DemoCard demo) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => demo.screen),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: demo.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(demo.icon, color: demo.color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      demo.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      demo.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoCard {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;

  const _DemoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.screen,
  });
}
