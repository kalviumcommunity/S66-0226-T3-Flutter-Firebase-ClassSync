import 'package:flutter/material.dart';

/// CounterScreen — demonstrates a StatefulWidget.
///
/// How it works:
///  1. _CounterScreenState holds mutable state: [count].
///  2. increment() and decrement() call setState(), notifying
///     Flutter that the widget tree must be re-evaluated.
///  3. Flutter re-runs build() and repaints only the affected parts.
class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  // Mutable state — any change here must go through setState().
  int count = 0;

  void increment() {
    setState(() {
      count++;
    });
  }

  void decrement() {
    setState(() {
      if (count > 0) count--;
    });
  }

  void reset() {
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Counter App',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Text('StatefulWidget + setState() Demo',
                style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Reset counter',
            onPressed: reset,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ── Explanation banner ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.3)),
              ),
              child: const Text(
                'Every time you tap + or −, setState() is called.\n'
                'Flutter marks the widget as dirty and re-runs\n'
                'build() to repaint only the counter Text widget.',
                style: TextStyle(fontSize: 14),
              ),
            ),

            const SizedBox(height: 48),

            // ── Counter display ─────────────────────────────────────────
            Text(
              'Count',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Text(
                '$count',
                key: ValueKey(count),
                style: const TextStyle(
                  fontSize: 88,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),

            const SizedBox(height: 48),

            // ── Buttons ─────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CounterButton(
                  icon: Icons.remove,
                  label: 'Decrement',
                  color: Colors.redAccent,
                  onPressed: decrement,
                ),
                const SizedBox(width: 24),
                _CounterButton(
                  icon: Icons.add,
                  label: 'Increment',
                  color: Colors.deepPurple,
                  onPressed: increment,
                ),
              ],
            ),

            const SizedBox(height: 48),

            // ── Code snippet ────────────────────────────────────────────
            _CodeSnippet(
              code: 'void increment() {\n'
                  '  setState(() {\n'
                  '    count++; // mutate state inside setState\n'
                  '  });\n'
                  '}',
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _CounterButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            elevation: 4,
          ),
          onPressed: onPressed,
          child: Icon(icon, size: 32),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
      ],
    );
  }
}

class _CodeSnippet extends StatelessWidget {
  final String code;
  const _CodeSnippet({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: Color(0xFFCDD6F4),
          height: 1.6,
        ),
      ),
    );
  }
}
