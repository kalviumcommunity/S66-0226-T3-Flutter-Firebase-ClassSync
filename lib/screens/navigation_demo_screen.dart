import 'package:flutter/material.dart';

/// NavigationDemoScreen — demonstrates Flutter's Navigator and named routes.
///
/// Concepts demonstrated:
///  - Navigator push/pop: adding and removing screens from the navigation stack
///  - Named routes: mapping string paths to screens via onGenerateRoute
///  - Route arguments: passing data between screens with settings.arguments
///  - Navigation stack: visualized live inside the demo as you navigate
///
/// Architecture:
///  NavigationDemoScreen (root, in main Navigator)
///  └── Column
///      ├── _ConceptBanner   — StatelessWidget explaining Navigator
///      └── _PhoneFrame
///          └── nested Navigator (owns its own stack)
///              ├── '/nav/home'    → _NavHomePage
///              ├── '/nav/second'  → _NavSecondPage
///              └── '/nav/profile' → _NavProfilePage(message)
class NavigationDemoScreen extends StatelessWidget {
  const NavigationDemoScreen({super.key});

  // ── Route table ──────────────────────────────────────────────────────────
  // Named routes are defined here, analogous to MaterialApp's routes: map.
  // The nested Navigator uses onGenerateRoute to resolve route names.
  static Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/nav/home':
        return _slide(settings, const _NavHomePage());
      case '/nav/second':
        return _slide(settings, const _NavSecondPage());
      case '/nav/profile':
        return _slide(
            settings, _NavProfilePage(message: args as String? ?? ''));
      default:
        return _slide(settings, const _NavHomePage());
    }
  }

  static PageRouteBuilder<void> _slide(RouteSettings s, Widget page) {
    return PageRouteBuilder(
      settings: s,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, anim, secondaryAnim, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeInOut)),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 280),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Navigator & Routes'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── concept banner ───────────────────────────────────────────────
          const _ConceptBanner(),

          // ── phone frame containing the nested navigator ──────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: _PhoneFrame(
                    child: HeroControllerScope(
                      controller:
                          MaterialApp.createMaterialHeroController(),
                      child: Navigator(
                        initialRoute: '/nav/home',
                        onGenerateRoute: _onGenerateRoute,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CONCEPT BANNER (StatelessWidget — never rebuilds)
// ═══════════════════════════════════════════════════════════════════════════

class _ConceptBanner extends StatelessWidget {
  const _ConceptBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E3A5F),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PillLabel(
              text: 'push()', color: const Color(0xFF3B82F6)),
          const SizedBox(width: 6),
          _PillLabel(
              text: 'pop()', color: const Color(0xFF10B981)),
          const SizedBox(width: 6),
          _PillLabel(
              text: 'pushNamed()', color: const Color(0xFFF59E0B)),
          const SizedBox(width: 6),
          _PillLabel(
              text: 'arguments', color: const Color(0xFFEC4899)),
        ],
      ),
    );
  }
}

class _PillLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _PillLabel({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PHONE FRAME wrapper
// ═══════════════════════════════════════════════════════════════════════════

class _PhoneFrame extends StatelessWidget {
  final Widget child;
  const _PhoneFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF334155), width: 3),
        boxShadow: const [
          BoxShadow(
              color: Color(0x33000000),
              blurRadius: 20,
              offset: Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: child,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCREEN 1: Nav Home Page
// ═══════════════════════════════════════════════════════════════════════════

class _NavHomePage extends StatelessWidget {
  const _NavHomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 12,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Home Screen',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            Text('route: /nav/home',
                style: TextStyle(
                    fontSize: 10, color: Colors.white.withValues(alpha: 0.7))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── stack indicator ──────────────────────────────────────────
            _StackIndicator(routes: const ['Home']),
            const SizedBox(height: 14),

            // ── push to second ───────────────────────────────────────────
            _ActionCard(
              color: const Color(0xFF3B82F6),
              method: 'Navigator.pushNamed(context, \'/nav/second\')',
              description: 'Adds SecondScreen to the top of the stack.',
              buttonLabel: 'Go to Second Screen',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => Navigator.pushNamed(context, '/nav/second'),
            ),
            const SizedBox(height: 10),

            // ── push with arguments ──────────────────────────────────────
            _ActionCard(
              color: const Color(0xFFEC4899),
              method:
                  "Navigator.pushNamed(context, '/nav/profile',\n  arguments: 'Hello from Home!')",
              description:
                  'Passes a String argument to ProfileScreen via settings.arguments.',
              buttonLabel: 'Go to Profile (with data)',
              icon: Icons.person_outline,
              onPressed: () => Navigator.pushNamed(
                context,
                '/nav/profile',
                arguments: 'Hello from Home! 👋',
              ),
            ),
            const SizedBox(height: 14),

            // ── explanation box ──────────────────────────────────────────
            _CodeBox(
              lines: const [
                _CodeLine('// main.dart — define routes once', isComment: true),
                _CodeLine('MaterialApp('),
                _CodeLine("  initialRoute: '/',"),
                _CodeLine('  routes: {'),
                _CodeLine("    '/': (ctx) => HomeScreen(),"),
                _CodeLine("    '/second': (ctx) => SecondScreen(),"),
                _CodeLine("    '/profile': (ctx) => ProfileScreen(),"),
                _CodeLine('  },'),
                _CodeLine(');'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCREEN 2: Nav Second Page
// ═══════════════════════════════════════════════════════════════════════════

class _NavSecondPage extends StatelessWidget {
  const _NavSecondPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 12,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Second Screen',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            Text('route: /nav/second',
                style: TextStyle(
                    fontSize: 10, color: Colors.white.withValues(alpha: 0.7))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── stack indicator ──────────────────────────────────────────
            _StackIndicator(routes: const ['Home', 'Second']),
            const SizedBox(height: 14),

            // ── back / pop ───────────────────────────────────────────────
            _ActionCard(
              color: const Color(0xFF10B981),
              method: 'Navigator.pop(context)',
              description:
                  'Removes this screen from the stack and returns to the previous one.',
              buttonLabel: 'Back to Home',
              icon: Icons.arrow_back_rounded,
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 14),

            _CodeBox(
              lines: const [
                _CodeLine(
                    '// SecondScreen — how to go back', isComment: true),
                _CodeLine('ElevatedButton('),
                _CodeLine('  onPressed: () {'),
                _CodeLine('    Navigator.pop(context);'),
                _CodeLine('  },'),
                _CodeLine("  child: Text('Back to Home'),"),
                _CodeLine('),'),
              ],
            ),
            const SizedBox(height: 14),
            _InfoTile(
              icon: Icons.layers_outlined,
              color: const Color(0xFF3B82F6),
              text:
                  'The Navigator maintains a stack. push() adds to the top; '
                  'pop() removes from the top. The user always sees the topmost screen.',
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCREEN 3: Nav Profile Page (receives arguments)
// ═══════════════════════════════════════════════════════════════════════════

class _NavProfilePage extends StatelessWidget {
  final String message;
  const _NavProfilePage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFEC4899),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 12,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Profile Screen',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            Text('route: /nav/profile',
                style: TextStyle(
                    fontSize: 10, color: Colors.white.withValues(alpha: 0.7))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── stack indicator ──────────────────────────────────────────
            _StackIndicator(routes: const ['Home', 'Profile']),
            const SizedBox(height: 14),

            // ── received argument ────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF2F8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEC4899).withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.download_rounded,
                          size: 15, color: Color(0xFFEC4899)),
                      SizedBox(width: 6),
                      Text(
                        'Received argument',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFEC4899)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message.isEmpty ? '(no argument passed)' : message,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // ── back button ──────────────────────────────────────────────
            _ActionCard(
              color: const Color(0xFF10B981),
              method: 'Navigator.pop(context)',
              description: 'Pops this screen off the stack.',
              buttonLabel: 'Back to Home',
              icon: Icons.arrow_back_rounded,
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 14),

            _CodeBox(
              lines: const [
                _CodeLine(
                    '// HomeScreen — pass argument', isComment: true),
                _CodeLine("Navigator.pushNamed("),
                _CodeLine("  context, '/profile',"),
                _CodeLine("  arguments: 'Hello from Home!',"),
                _CodeLine(');'),
                _CodeLine(''),
                _CodeLine(
                    '// ProfileScreen — read argument', isComment: true),
                _CodeLine('final msg = ModalRoute.of(context)'),
                _CodeLine(
                    '    !.settings.arguments as String?;'),
                _CodeLine('Text(msg ?? \'No data\');'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

/// Displays the current navigation stack as breadcrumb chips.
class _StackIndicator extends StatelessWidget {
  final List<String> routes;
  const _StackIndicator({required this.routes});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.layers_outlined,
              size: 14, color: Color(0xFF64748B)),
          const SizedBox(width: 6),
          const Text('Stack: ',
              style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600)),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < routes.length; i++) ...[
                    if (i > 0)
                      const Icon(Icons.chevron_right,
                          size: 14, color: Color(0xFF94A3B8)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: i == routes.length - 1
                            ? const Color(0xFF1E3A5F)
                            : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        routes[i],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: i == routes.length - 1
                              ? Colors.white
                              : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card showing a navigation method with a button to trigger it.
class _ActionCard extends StatelessWidget {
  final Color color;
  final String method;
  final String description;
  final String buttonLabel;
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionCard({
    required this.color,
    required this.method,
    required this.description,
    required this.buttonLabel,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            method,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'monospace',
              color: color,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(description,
              style: const TextStyle(
                  fontSize: 11, color: Color(0xFF6B7280), height: 1.3)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 15),
              label: Text(buttonLabel,
                  style: const TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dark code block.
class _CodeBox extends StatelessWidget {
  final List<_CodeLine> lines;
  const _CodeBox({required this.lines});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines
            .map((l) => Text(
                  l.text,
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    color: l.isComment
                        ? const Color(0xFF64748B)
                        : l.text.isEmpty
                            ? Colors.transparent
                            : const Color(0xFF86EFAC),
                    height: 1.55,
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _CodeLine {
  final String text;
  final bool isComment;
  const _CodeLine(this.text, {this.isComment = false});
}

/// Info tile with icon + description text.
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _InfoTile(
      {required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF374151),
                    height: 1.45)),
          ),
        ],
      ),
    );
  }
}
