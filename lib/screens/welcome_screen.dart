import 'package:flutter/material.dart';

/// WelcomeScreen — Sprint #2 deliverable screen.
///
/// Demonstrates:
///  - Scaffold + AppBar
///  - Column layout with Text widget, Icon, and ElevatedButton
///  - StatefulWidget: onPressed toggles greeting text and theme color
///  - Dart syntax: lists, string interpolation, conditional expressions
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // ── Mutable state ────────────────────────────────────────────────────────
  int _tapCount = 0;
  bool _isDark = false;

  // List of greeting messages that cycle on each tap
  final List<String> _greetings = [
    'Welcome to ClassSync! 👋',
    'Ready to learn Flutter? 🚀',
    'Let\'s build something great! 🛠️',
    'Firebase integration next! 🔥',
    'You\'re doing amazing! ⭐',
  ];

  final List<Color> _colors = [
    const Color(0xFF4F46E5), // indigo
    Colors.teal,
    Colors.deepPurple,
    Colors.orange,
    Colors.green,
  ];

  // Derived state — cycle through greetings and colors
  String get _currentGreeting => _greetings[_tapCount % _greetings.length];
  Color get _currentColor => _colors[_tapCount % _colors.length];

  void _onButtonPressed() {
    setState(() {
      _tapCount++;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Re-theme based on state
    final bg = _isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = _isDark ? Colors.white : Colors.black87;
    final subColor = _isDark ? Colors.white60 : Colors.grey.shade600;

    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: bg,
      ),
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: _currentColor,
          foregroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'ClassSync',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                'Welcome Screen — Sprint #2',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            // Dark/light mode toggle — demonstrates state change in AppBar
            IconButton(
              tooltip: _isDark ? 'Light mode' : 'Dark mode',
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  _isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  key: ValueKey(_isDark),
                ),
              ),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Animated app icon ──────────────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: _currentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.school_rounded,
                  size: 64,
                  color: _currentColor,
                ),
              ),

              const SizedBox(height: 32),

              // ── Greeting text — changes on each tap ───────────────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.15),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: Text(
                  _currentGreeting,
                  key: ValueKey(_currentGreeting),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ── Sub-text ───────────────────────────────────────────────
              Text(
                'A platform for coaches and students to\n'
                'share materials and track assignments.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: subColor, height: 1.5),
              ),

              const SizedBox(height: 10),

              // ── Tap counter badge ──────────────────────────────────────
              if (_tapCount > 0)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: _currentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Button tapped $_tapCount time${_tapCount == 1 ? '' : 's'}',
                    style: TextStyle(
                      fontSize: 13,
                      color: _currentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              const SizedBox(height: 40),

              // ── Main CTA button ────────────────────────────────────────
              // onPressed toggles greeting text + accent color (setState)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentColor,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: _currentColor.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _onButtonPressed,
                  icon: const Icon(Icons.play_arrow_rounded, size: 22),
                  label: const Text(
                    'Try ClassSync',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Secondary action ───────────────────────────────────────
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  '← Back to demos',
                  style: TextStyle(color: subColor, fontSize: 14),
                ),
              ),

              const SizedBox(height: 32),

              // ── State explanation card ─────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _currentColor.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(14),
                  border:
                      Border.all(color: _currentColor.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.code, color: _currentColor, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'What\'s happening here?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _currentColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• _tapCount is mutable state inside a StatefulWidget\n'
                      '• onPressed calls setState(() { _tapCount++; })\n'
                      '• Flutter re-runs build() → greeting & color update\n'
                      '• AnimatedSwitcher adds smooth transitions for free',
                      style: TextStyle(
                          fontSize: 13,
                          color: _isDark ? Colors.white70 : Colors.black54,
                          height: 1.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
