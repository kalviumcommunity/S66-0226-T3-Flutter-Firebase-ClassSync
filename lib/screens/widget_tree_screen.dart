import 'package:flutter/material.dart';

/// WidgetTreeScreen — demonstrates the Flutter widget tree and reactive UI.
///
/// Concepts demonstrated:
///  - Widget tree: every UI element is a node in a parent→child hierarchy
///  - StatefulWidget + setState(): state change triggers selective rebuilds
///  - Reactive model: Flutter diffs the widget tree and repaints only what changed
///
/// Interactive demos:
///  1. Profile card — shows parent/child widget nesting visually with highlights
///  2. Color tapper — background color cycles on tap (setState visual proof)
///  3. Counter — classic increment/decrement showing number state rebuild
///  4. Visibility toggle — widget appears/disappears without full screen repaint
class WidgetTreeScreen extends StatefulWidget {
  const WidgetTreeScreen({super.key});

  @override
  State<WidgetTreeScreen> createState() => _WidgetTreeScreenState();
}

class _WidgetTreeScreenState extends State<WidgetTreeScreen> {
  // ── State variables ───────────────────────────────────────────────────────
  int _counter = 0;
  int _colorIndex = 0;
  bool _cardVisible = true;
  bool _showTreeOverlay = false;

  static const List<Color> _bgColors = [
    Color(0xFFEEF2FF), // indigo tint
    Color(0xFFF0FDF4), // green tint
    Color(0xFFFFF7ED), // orange tint
    Color(0xFFFDF2F8), // pink tint
    Color(0xFFF0F9FF), // sky tint
  ];

  static const List<String> _colorNames = [
    'Indigo Tint',
    'Green Tint',
    'Orange Tint',
    'Pink Tint',
    'Sky Tint',
  ];

  void _incrementCounter() => setState(() => _counter++);
  void _decrementCounter() => setState(() => _counter--);
  void _resetCounter() => setState(() => _counter = 0);

  void _cycleColor() =>
      setState(() => _colorIndex = (_colorIndex + 1) % _bgColors.length);

  void _toggleCard() => setState(() => _cardVisible = !_cardVisible);
  void _toggleTree() => setState(() => _showTreeOverlay = !_showTreeOverlay);

  @override
  Widget build(BuildContext context) {
    // ── Widget tree root ──────────────────────────────────────────────────
    // MaterialApp → Scaffold → AppBar / body
    //                body → AnimatedContainer → SingleChildScrollView
    //                         → Column → [sections…]
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Widget Tree & Reactive UI',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'How Flutter builds and updates the UI',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showTreeOverlay ? Icons.account_tree : Icons.account_tree_outlined,
            ),
            tooltip: 'Toggle widget tree diagram',
            onPressed: _toggleTree,
          ),
        ],
      ),

      // ── Reactive body ─────────────────────────────────────────────────────
      // AnimatedContainer re-renders smoothly when _colorIndex changes.
      // Only THIS container and its children rebuild — not the AppBar.
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        color: _bgColors[_colorIndex],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1 ── Concept explanation ──────────────────────────────────
              _ConceptBanner(),

              const SizedBox(height: 16),

              // 2 ── Widget tree diagram (toggleable) ────────────────────
              if (_showTreeOverlay) ...[
                _TreeDiagramCard(),
                const SizedBox(height: 16),
              ],

              // 3 ── Profile card demo ───────────────────────────────────
              _SectionHeader(
                label: 'Demo 1 — Widget Nesting',
                sublabel: 'Scaffold → Column → Card → Row → Text',
                icon: Icons.account_tree_outlined,
                color: const Color(0xFF7C3AED),
              ),
              const SizedBox(height: 8),
              _ProfileCard(),

              const SizedBox(height: 20),

              // 4 ── Color tapper ────────────────────────────────────────
              _SectionHeader(
                label: 'Demo 2 — setState() Color Change',
                sublabel:
                    'Tap the button → setState() → AnimatedContainer rebuilds',
                icon: Icons.color_lens_outlined,
                color: Colors.teal,
              ),
              const SizedBox(height: 8),
              _ColorTapCard(
                colorName: _colorNames[_colorIndex],
                colorIndex: _colorIndex,
                onTap: _cycleColor,
              ),

              const SizedBox(height: 20),

              // 5 ── Counter demo ────────────────────────────────────────
              _SectionHeader(
                label: 'Demo 3 — Reactive Counter',
                sublabel: 'count changes → only Text widget rebuilds',
                icon: Icons.calculate_outlined,
                color: Colors.deepOrange,
              ),
              const SizedBox(height: 8),
              _CounterCard(
                count: _counter,
                onIncrement: _incrementCounter,
                onDecrement: _decrementCounter,
                onReset: _resetCounter,
              ),

              const SizedBox(height: 20),

              // 6 ── Visibility toggle ───────────────────────────────────
              _SectionHeader(
                label: 'Demo 4 — Toggle Widget Visibility',
                sublabel: 'setState() adds/removes a widget from the tree',
                icon: Icons.visibility_outlined,
                color: Colors.pink,
              ),
              const SizedBox(height: 8),
              _VisibilityCard(
                visible: _cardVisible,
                onToggle: _toggleCard,
              ),

              const SizedBox(height: 20),

              // 7 ── Reactive model explainer ────────────────────────────
              _ReactiveModelCard(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Supporting widgets — each is its own node in the widget tree
// ═══════════════════════════════════════════════════════════════════════════

class _ConceptBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF7C3AED).withValues(alpha: 0.25),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Color(0xFF7C3AED), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'In Flutter, every UI element is a widget — a node in a tree. '
              'When state changes, Flutter rebuilds only the affected subtree, '
              'not the entire screen. Tap the demos below to see this live.',
              style: TextStyle(fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.color,
  });

  final String label;
  final String sublabel;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                sublabel,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Widget tree diagram ──────────────────────────────────────────────────
class _TreeDiagramCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_tree, color: Color(0xFF7C3AED)),
                const SizedBox(width: 8),
                const Text(
                  'Widget Tree — this screen',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _TreeNode(label: 'MaterialApp', depth: 0, isRoot: true),
            const _TreeNode(label: 'Scaffold', depth: 1),
            const _TreeNode(label: '├── AppBar', depth: 2),
            const _TreeNode(label: '│      └── Column (title)', depth: 3),
            const _TreeNode(label: '│             ├── Text (title)', depth: 4),
            const _TreeNode(label: '│             └── Text (subtitle)', depth: 4),
            const _TreeNode(label: '└── body: AnimatedContainer', depth: 2, isReactive: true),
            const _TreeNode(label: '       └── SingleChildScrollView', depth: 3),
            const _TreeNode(label: '              └── Column', depth: 4),
            const _TreeNode(label: '                     ├── _ConceptBanner', depth: 5),
            const _TreeNode(label: '                     ├── _ProfileCard', depth: 5),
            const _TreeNode(label: '                     ├── _ColorTapCard  ← setState', depth: 5, isReactive: true),
            const _TreeNode(label: '                     ├── _CounterCard   ← setState', depth: 5, isReactive: true),
            const _TreeNode(label: '                     └── _VisibilityCard← setState', depth: 5, isReactive: true),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Orange = rebuilds on setState()',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TreeNode extends StatelessWidget {
  const _TreeNode({
    required this.label,
    required this.depth,
    this.isRoot = false,
    this.isReactive = false,
  });

  final String label;
  final int depth;
  final bool isRoot;
  final bool isReactive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: isReactive
            ? BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.orange.shade200),
              )
            : null,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            fontWeight: isRoot ? FontWeight.bold : FontWeight.normal,
            color: isReactive ? Colors.orange.shade800 : Colors.black87,
          ),
        ),
      ),
    );
  }
}

// ── Demo 1: Profile card showing widget nesting ──────────────────────────
class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Card → Padding → Column → Row + Text + ElevatedButton
    // Each widget is a child node of the one above it.
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Row → CircleAvatar + Column(name, role)
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor:
                      const Color(0xFF7C3AED).withValues(alpha: 0.15),
                  child: const Icon(
                    Icons.person,
                    size: 34,
                    color: Color(0xFF7C3AED),
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shebin',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Flutter Developer · ClassSync',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(),
            const SizedBox(height: 10),
            // Row of stat chips
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatChip(label: 'Screens', value: '13'),
                _StatChip(label: 'Services', value: '3'),
                _StatChip(label: 'Models', value: '1'),
              ],
            ),
            const SizedBox(height: 14),
            // Widget tree path label
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Card → Padding → Column → Row → CircleAvatar + Column',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF7C3AED),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }
}

// ── Demo 2: Color tap card ────────────────────────────────────────────────
class _ColorTapCard extends StatelessWidget {
  const _ColorTapCard({
    required this.colorName,
    required this.colorIndex,
    required this.onTap,
  });

  final String colorName;
  final int colorIndex;
  final VoidCallback onTap;

  static const _colors = [
    Color(0xFF7C3AED),
    Color(0xFF059669),
    Color(0xFFEA580C),
    Color(0xFFDB2777),
    Color(0xFF0284C7),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 80,
              decoration: BoxDecoration(
                color: _colors[colorIndex].withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _colors[colorIndex].withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  colorName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _colors[colorIndex],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.color_lens),
                label: const Text('Cycle Background Color'),
                style: FilledButton.styleFrom(
                  backgroundColor: _colors[colorIndex],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'setState() → _colorIndex++ → AnimatedContainer rebuilds',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Demo 3: Counter card ──────────────────────────────────────────────────
class _CounterCard extends StatelessWidget {
  const _CounterCard({
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    required this.onReset,
  });

  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final isPositive = count > 0;
    final isNegative = count < 0;
    final countColor = isPositive
        ? Colors.green.shade700
        : isNegative
            ? Colors.red.shade700
            : Colors.grey.shade700;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Count display — only THIS Text rebuilds when count changes
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Text(
                '$count',
                key: ValueKey(count),
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: countColor,
                ),
              ),
            ),
            Text(
              'current count',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CircleButton(
                  icon: Icons.remove,
                  color: Colors.red,
                  onTap: onDecrement,
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: onReset,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 16),
                _CircleButton(
                  icon: Icons.add,
                  color: Colors.green,
                  onTap: onIncrement,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Only the Text("$count") node rebuilds — not the buttons',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Icon(icon, color: color, size: 24),
        ),
      ),
    );
  }
}

// ── Demo 4: Visibility toggle ─────────────────────────────────────────────
class _VisibilityCard extends StatelessWidget {
  const _VisibilityCard({required this.visible, required this.onToggle});

  final bool visible;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: visible
                  ? Container(
                      key: const ValueKey('shown'),
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.pink.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.visibility,
                              color: Colors.pink.shade400, size: 22),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'This widget is in the tree.\n'
                              'setState() with visible=false removes it.',
                              style: TextStyle(fontSize: 13, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      key: const ValueKey('hidden'),
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.visibility_off,
                              color: Colors.grey.shade400, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            'Widget removed from tree.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onToggle,
                icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
                label: Text(visible ? 'Hide Widget' : 'Show Widget'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              visible
                  ? 'visible=true → widget node present in tree'
                  : 'visible=false → widget node removed from tree',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reactive model explainer card ─────────────────────────────────────────
class _ReactiveModelCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFF7C3AED).withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_graph, color: Color(0xFF7C3AED)),
                SizedBox(width: 8),
                Text(
                  'Why Flutter is Reactive',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF7C3AED),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _BulletPoint(
              icon: Icons.looks_one_outlined,
              text:
                  'State changes via setState() tell Flutter "something changed here".',
            ),
            _BulletPoint(
              icon: Icons.looks_two_outlined,
              text:
                  'Flutter calls build() on the modified widget and produces a new widget tree.',
            ),
            _BulletPoint(
              icon: Icons.looks_3_outlined,
              text:
                  'The framework diffs the old and new trees (reconciliation) to find what actually changed.',
            ),
            _BulletPoint(
              icon: Icons.looks_4_outlined,
              text:
                  'Only the changed nodes are repainted on the GPU layer — buttons, AppBar, etc. are untouched.',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'setState() → build() → diff → repaint changed nodes',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7C3AED),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF7C3AED)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
