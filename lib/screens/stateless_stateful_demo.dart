import 'package:flutter/material.dart';

/// StatelessStatefulDemo — side-by-side demonstration of both widget types.
///
/// Concepts demonstrated:
///  - StatelessWidget: receives data via constructor, never rebuilds on its own
///  - StatefulWidget: owns mutable state; setState() triggers selective rebuilds
///  - How Flutter rebuilds only the dirty subtree, not the whole screen
///
/// Layout:
///  - [_AppBanner]          → StatelessWidget — static title / description
///  - [_CounterSection]     → StatefulWidget  — tap to increment / decrement
///  - [_ColorToggleSection] → StatefulWidget  — toggle between two theme colors
///  - [_VisibilitySection]  → StatefulWidget  — show / hide a message card
///  - [_SummaryCard]        → StatelessWidget — comparison table, always static
class StatelessStatefulDemo extends StatelessWidget {
  const StatelessStatefulDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        title: const Text('Stateless vs Stateful'),
        centerTitle: true,
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── static banner (StatelessWidget) ─────────────────────────
            _AppBanner(),
            SizedBox(height: 16),

            // ── interactive demos (StatefulWidget) ──────────────────────
            _CounterSection(),
            SizedBox(height: 16),
            _ColorToggleSection(),
            SizedBox(height: 16),
            _VisibilitySection(),
            SizedBox(height: 20),

            // ── comparison summary (StatelessWidget) ────────────────────
            _SummaryCard(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STATELESS: App Banner
// ═══════════════════════════════════════════════════════════════════════════

/// Pure display widget — rendered once, never mutates.
/// All data is passed in via the constructor (here hardcoded as constants).
class _AppBanner extends StatelessWidget {
  const _AppBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x334F46E5),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'STATELESS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.lock_outline, color: Colors.white70, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Interactive Demo App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'This banner is a StatelessWidget — it is built once and '
            'never rebuilds. Scroll down to interact with StatefulWidgets '
            'that update in real time.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STATEFUL: Counter Section
// ═══════════════════════════════════════════════════════════════════════════

class _CounterSection extends StatefulWidget {
  const _CounterSection();

  @override
  State<_CounterSection> createState() => _CounterSectionState();
}

class _CounterSectionState extends State<_CounterSection> {
  int _count = 0;

  void _increment() => setState(() => _count++);
  void _decrement() => setState(() => _count--);
  void _reset() => setState(() => _count = 0);

  Color get _countColor {
    if (_count > 0) return const Color(0xFF059669); // green for positive
    if (_count < 0) return const Color(0xFFDC2626); // red for negative
    return const Color(0xFF4F46E5); // indigo for zero
  }

  @override
  Widget build(BuildContext context) {
    return _DemoShell(
      label: 'STATEFUL',
      labelColor: const Color(0xFF059669),
      title: 'Counter',
      icon: Icons.add_circle_outline,
      description:
          'Each tap calls setState() — only this section rebuilds, not the '
          'banner above or any other widget on screen.',
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Text(
              '$_count',
              key: ValueKey(_count),
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w900,
                color: _countColor,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _count == 0
                ? 'Tap + or − to change the count'
                : _count > 0
                    ? '↑ Count is positive'
                    : '↓ Count is negative',
            style: TextStyle(fontSize: 13, color: _countColor),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ActionButton(
                icon: Icons.remove,
                color: const Color(0xFFDC2626),
                onPressed: _decrement,
                tooltip: 'Decrement',
              ),
              const SizedBox(width: 12),
              _ActionButton(
                icon: Icons.refresh,
                color: const Color(0xFF6B7280),
                onPressed: _reset,
                tooltip: 'Reset',
              ),
              const SizedBox(width: 12),
              _ActionButton(
                icon: Icons.add,
                color: const Color(0xFF059669),
                onPressed: _increment,
                tooltip: 'Increment',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STATEFUL: Color Toggle Section
// ═══════════════════════════════════════════════════════════════════════════

class _ColorToggleSection extends StatefulWidget {
  const _ColorToggleSection();

  @override
  State<_ColorToggleSection> createState() => _ColorToggleSectionState();
}

class _ColorToggleSectionState extends State<_ColorToggleSection> {
  static const _themes = [
    _ThemeOption('Indigo', Color(0xFF4F46E5), Color(0xFFEEF2FF)),
    _ThemeOption('Emerald', Color(0xFF059669), Color(0xFFF0FDF4)),
    _ThemeOption('Rose', Color(0xFFE11D48), Color(0xFFFFF1F2)),
    _ThemeOption('Amber', Color(0xFFD97706), Color(0xFFFFFBEB)),
    _ThemeOption('Sky', Color(0xFF0284C7), Color(0xFFF0F9FF)),
  ];

  int _themeIndex = 0;

  void _nextTheme() =>
      setState(() => _themeIndex = (_themeIndex + 1) % _themes.length);

  _ThemeOption get _current => _themes[_themeIndex];

  @override
  Widget build(BuildContext context) {
    return _DemoShell(
      label: 'STATEFUL',
      labelColor: const Color(0xFF0284C7),
      title: 'Color Toggle',
      icon: Icons.palette_outlined,
      description:
          'setState() changes _themeIndex — Flutter rebuilds only the '
          'AnimatedContainer and its children.',
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: _current.bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _current.accent.withValues(alpha: 0.4)),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _current.name,
                  key: ValueKey(_themeIndex),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: _current.accent,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ..._themes.asMap().entries.map((e) => GestureDetector(
                    onTap: () => setState(() => _themeIndex = e.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _themeIndex == e.key ? 24 : 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: e.value.accent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _nextTheme,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('Next Theme'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _current.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeOption {
  final String name;
  final Color accent;
  final Color bg;
  const _ThemeOption(this.name, this.accent, this.bg);
}

// ═══════════════════════════════════════════════════════════════════════════
// STATEFUL: Visibility Toggle Section
// ═══════════════════════════════════════════════════════════════════════════

class _VisibilitySection extends StatefulWidget {
  const _VisibilitySection();

  @override
  State<_VisibilitySection> createState() => _VisibilitySectionState();
}

class _VisibilitySectionState extends State<_VisibilitySection> {
  bool _visible = true;

  void _toggle() => setState(() => _visible = !_visible);

  @override
  Widget build(BuildContext context) {
    return _DemoShell(
      label: 'STATEFUL',
      labelColor: const Color(0xFF7C3AED),
      title: 'Visibility Toggle',
      icon: Icons.visibility_outlined,
      description:
          'Toggling _visible via setState() adds or removes the card '
          'widget from the element tree entirely.',
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SizeTransition(
                sizeFactor: anim,
                axisAlignment: -1,
                child: child,
              ),
            ),
            child: _visible
                ? Card(
                    key: const ValueKey('card'),
                    margin: EdgeInsets.zero,
                    color: const Color(0xFFF5F3FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF7C3AED), width: 1),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: Color(0xFF7C3AED)),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'I am visible! Flutter added me to the '
                              'element tree when _visible became true.',
                              style: TextStyle(
                                color: Color(0xFF5B21B6),
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _toggle,
              icon: Icon(
                _visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 18,
              ),
              label: Text(_visible ? 'Hide Message' : 'Show Message'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STATELESS: Summary Comparison Card
// ═══════════════════════════════════════════════════════════════════════════

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'STATELESS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Quick Comparison',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827))),
              ],
            ),
            const SizedBox(height: 16),
            _ComparisonRow(
              property: 'State',
              stateless: 'None — data via constructor only',
              stateful: 'Internal — mutable _state object',
            ),
            _ComparisonRow(
              property: 'Rebuilds',
              stateless: 'Only when parent rebuilds it',
              stateful: 'On setState() or external trigger',
            ),
            _ComparisonRow(
              property: 'Use when',
              stateless: 'UI is purely derived from inputs',
              stateful: 'UI changes due to interaction / time',
            ),
            _ComparisonRow(
              property: 'Examples',
              stateless: 'Labels, icons, static cards, headers',
              stateful: 'Counters, forms, toggles, animations',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final String property;
  final String stateless;
  final String stateful;
  final bool isLast;

  const _ComparisonRow({
    required this.property,
    required this.stateless,
    required this.stateful,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 72,
                child: Text(
                  property,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Tag(text: stateless, color: const Color(0xFF4F46E5)),
                    const SizedBox(height: 4),
                    _Tag(text: stateful, color: const Color(0xFF059669)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: Color(0xFFF3F4F6)),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  const _Tag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: color, height: 1.3),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SHARED UTILITIES (StatelessWidgets used by stateful sections)
// ═══════════════════════════════════════════════════════════════════════════

/// Shell card wrapping each demo section — itself a StatelessWidget.
/// The mutable state lives in the child widget passed to it.
class _DemoShell extends StatelessWidget {
  final String label;
  final Color labelColor;
  final String title;
  final IconData icon;
  final String description;
  final Widget child;

  const _DemoShell({
    required this.label,
    required this.labelColor,
    required this.title,
    required this.icon,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── header ────────────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: labelColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: labelColor,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, size: 18, color: labelColor),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF6B7280), height: 1.45),
            ),
            const SizedBox(height: 16),
            // ── interactive content ───────────────────────────────────
            child,
          ],
        ),
      ),
    );
  }
}

/// Circular icon button used in the counter section.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String tooltip;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
      ),
    );
  }
}
