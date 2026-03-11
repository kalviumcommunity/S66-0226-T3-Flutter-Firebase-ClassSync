import 'package:flutter/material.dart';

class AnimationsTransitionsDemo extends StatefulWidget {
  const AnimationsTransitionsDemo({super.key});

  @override
  State<AnimationsTransitionsDemo> createState() =>
      _AnimationsTransitionsDemoState();
}

class _AnimationsTransitionsDemoState extends State<AnimationsTransitionsDemo>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  bool _visible = true;
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _toggleBox() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  void _toggleOpacity() {
    setState(() {
      _visible = !_visible;
    });
  }

  void _toggleRotation() {
    if (_rotationController.isAnimating) {
      _rotationController.stop();
      return;
    }
    _rotationController.repeat(reverse: true);
  }

  void _openTransitionPage() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        reverseTransitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _AnimatedDestinationPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              );

          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );

          return SlideTransition(
            position: slide,
            child: FadeTransition(opacity: fade, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animations & Transitions')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Implicit, explicit, and route transition animations in one screen.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AnimatedContainer',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      width: _expanded ? 220 : 120,
                      height: _expanded ? 120 : 180,
                      decoration: BoxDecoration(
                        color: _expanded
                            ? const Color(0xFF0F766E)
                            : const Color(0xFFEA580C),
                        borderRadius: BorderRadius.circular(
                          _expanded ? 24 : 12,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Tap to morph',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: _toggleBox,
                    child: const Text('Toggle Container Animation'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AnimatedOpacity',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: AnimatedOpacity(
                      opacity: _visible ? 1.0 : 0.2,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      child: Image.asset('assets/images/logo.png', width: 120),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: _toggleOpacity,
                    child: const Text('Toggle Opacity'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RotationTransition (Explicit)',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: RotationTransition(
                      turns: _rotationController,
                      child: const Icon(
                        Icons.flutter_dash,
                        size: 84,
                        color: Color(0xFF1D4ED8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _toggleRotation,
                    child: Text(
                      _rotationController.isAnimating
                          ? 'Stop Rotation'
                          : 'Start Rotation',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _openTransitionPage,
            icon: const Icon(Icons.swipe_right_alt),
            label: const Text('Open Page with Slide Transition'),
          ),
        ],
      ),
    );
  }
}

class _AnimatedDestinationPage extends StatelessWidget {
  const _AnimatedDestinationPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transition Target')),
      body: const Center(
        child: Text(
          'Smooth slide + fade transition complete.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
