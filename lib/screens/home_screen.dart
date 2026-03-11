import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'architecture_screen.dart';
import 'auth_screen.dart';
import 'counter_screen.dart';
import 'dart_basics_screen.dart';
import 'firestore_screen.dart';
import 'hello_flutter_screen.dart';
import 'login_screen.dart';
import 'scrollable_views_screen.dart';
import 'signup_screen.dart';
import 'storage_screen.dart';
import 'design_system_screen.dart';
import 'responsive_home.dart';
import 'responsive_layout.dart';
import 'welcome_screen.dart';
import 'devtools_demo_screen.dart';
import 'navigation_demo_screen.dart';
import 'stateless_stateful_demo.dart';
import 'widget_tree_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final user = FirebaseAuth.instance.currentUser;

    final demos = [
      _DemoCard(
        title: 'Design System 🎨',
        subtitle: 'Sprint #4 • Figma → Flutter · Design Thinking · Tokens',
        icon: Icons.design_services_outlined,
        color: const Color(0xFF7C3AED),
        screen: const DesignSystemScreen(),
        highlight: true,
      ),
      _DemoCard(
        title: 'Responsive Layout 📐',
        subtitle: 'Sprint #3 • MediaQuery · LayoutBuilder · Adaptive UI',
        icon: Icons.devices_outlined,
        color: const Color(0xFF0EA5E9),
        screen: const ResponsiveHomeScreen(),
        highlight: true,
      ),
      _DemoCard(
        title: 'Container · Row · Column 🧱',
        subtitle: 'Sprint #3 • Core layout widgets · MediaQuery responsiveness',
        icon: Icons.dashboard_outlined,
        color: const Color(0xFF10B981),
        screen: const ResponsiveLayoutScreen(),
        highlight: true,
      ),
      _DemoCard(
        title: 'Scrollable Views 📜',
        subtitle: 'ListView.builder · GridView.builder · adaptive dashboard UI',
        icon: Icons.view_quilt_outlined,
        color: const Color(0xFF12355B),
        screen: const ScrollableViewsScreen(),
        highlight: true,
      ),

      _DemoCard(
        title: 'Welcome Screen ✨',
        subtitle: 'Sprint #2 • StatefulWidget · setState · animations',
        icon: Icons.waving_hand_outlined,
        color: const Color(0xFF4F46E5),
        screen: const WelcomeScreen(),
      ),
      _DemoCard(
        title: 'Hot Reload & DevTools ⚡',
        subtitle: 'Sprint #2 • Hot Reload · Debug Console · DevTools',
        icon: Icons.developer_mode,
        color: const Color(0xFFF59E0B),
        screen: const DevToolsDemoScreen(),
        highlight: true,
      ),

      _DemoCard(
        title: 'Navigator & Routes 🗺',
        subtitle: 'Sprint #2 • push · pop · pushNamed · arguments',
        icon: Icons.alt_route_rounded,
        color: const Color(0xFF1E3A5F),
        screen: const NavigationDemoScreen(),
        highlight: true,
      ),

      _DemoCard(
        title: 'Stateless vs Stateful 🔵🟢',
        subtitle: 'Sprint #2 • StatelessWidget · StatefulWidget · setState',
        icon: Icons.compare_arrows_rounded,
        color: const Color(0xFF0284C7),
        screen: const StatelessStatefulDemo(),
        highlight: true,
      ),

      _DemoCard(
        title: 'Widget Tree & Reactive UI 🌳',
        subtitle: 'Sprint #2 • Widget tree · setState · reactive rebuild',
        icon: Icons.account_tree_outlined,
        color: const Color(0xFF7C3AED),
        screen: const WidgetTreeScreen(),
        highlight: true,
      ),

      _DemoCard(
        title: '🔐 Login Screen',
        subtitle: 'Firebase Auth · Sign in with email & password',
        icon: Icons.login,
        color: const Color(0xFF7C3AED),
        screen: const LoginScreen(),
        highlight: true,
      ),
      _DemoCard(
        title: '📝 Signup Screen',
        subtitle: 'Firebase Auth · Register · Save profile to Firestore',
        icon: Icons.person_add_alt_1,
        color: const Color(0xFF059669),
        screen: const SignupScreen(),
        highlight: true,
      ),
      _DemoCard(
        title: 'Auth Demo (Combined)',
        subtitle: 'Login + Signup in one screen with state switching',
        icon: Icons.verified_user_outlined,
        color: Colors.deepOrange,
        screen: const AuthScreen(),
      ),

      _DemoCard(
        title: 'Firestore CRUD',
        subtitle: 'Create · Read · Update · Delete — real-time sync',
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
    ];

    return Scaffold(
      backgroundColor: color.surface,
      appBar: AppBar(
        backgroundColor: color.primary,
        foregroundColor: color.onPrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ClassSync',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              user?.email ?? 'Logged in user',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: demos.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified_user, color: color.onPrimaryContainer),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Persistent login is active. Close and reopen the app to stay signed in.',
                      style: TextStyle(
                        color: color.onPrimaryContainer,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return _buildCard(context, demos[index - 1]);
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, _DemoCard demo) {
    if (demo.highlight) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [demo.color, demo.color.withValues(alpha: 0.75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: demo.color.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
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
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(demo.icon, color: Colors.white, size: 28),
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
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          demo.subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white70),
                ],
              ),
            ),
          ),
        ),
      );
    }

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
  final bool highlight;

  const _DemoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.screen,
    this.highlight = false,
  });
}
