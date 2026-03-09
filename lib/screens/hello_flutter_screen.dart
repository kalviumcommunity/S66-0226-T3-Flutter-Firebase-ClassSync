import 'package:flutter/material.dart';

class HelloFlutterScreen extends StatelessWidget {
  const HelloFlutterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Hello Flutter',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Text('StatelessWidget Demo', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.widgets_outlined, size: 80, color: Colors.teal.shade300),
              const SizedBox(height: 24),
              Text(
                'Welcome to Flutter!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'This screen is a StatelessWidget.\n'
                'It has no internal state — the build() method runs\n'
                'once and produces a fixed, unchanging UI.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 32),
              _InfoBox(
                label: 'StatelessWidget',
                description:
                    'Use when the UI does NOT depend on any mutable state.\n'
                    'Examples: labels, icons, decorative containers, static screens.',
                color: Colors.teal,
              ),
              const SizedBox(height: 16),
              _InfoBox(
                label: 'Hot Reload Tip',
                description:
                    'Try changing the "Welcome to Flutter!" text above, '
                    'save the file, and watch it update instantly — '
                    'no restart needed!',
                color: Colors.blueGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String description;
  final Color color;

  const _InfoBox({
    required this.label,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
