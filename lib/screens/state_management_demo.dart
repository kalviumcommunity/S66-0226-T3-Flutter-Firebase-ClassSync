import 'package:flutter/material.dart';

class StateManagementDemo extends StatefulWidget {
  const StateManagementDemo({super.key});

  @override
  State<StateManagementDemo> createState() => _StateManagementDemoState();
}

class _StateManagementDemoState extends State<StateManagementDemo> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasReachedGoal = _counter >= 5;

    return Scaffold(
      appBar: AppBar(title: const Text('State Management Demo')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: hasReachedGoal
                    ? const Color(0xFFD1FAE5)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: hasReachedGoal
                      ? const Color(0xFF059669)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: [
                  Text('Button pressed:', style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    '$_counter times',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hasReachedGoal
                        ? 'Threshold reached: background changed'
                        : 'Keep tapping to reach 5',
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton.icon(
                        onPressed: _incrementCounter,
                        icon: const Icon(Icons.add),
                        label: const Text('Increment'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _decrementCounter,
                        icon: const Icon(Icons.remove),
                        label: const Text('Decrement'),
                      ),
                      TextButton.icon(
                        onPressed: _resetCounter,
                        icon: const Icon(Icons.replay),
                        label: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
