import 'package:flutter/material.dart';

class DevToolsDemoScreen extends StatelessWidget {
  const DevToolsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        title: const Text('Hot Reload & DevTools'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionHeader(
              icon: Icons.bolt,
              iconColor: Color(0xFFF59E0B),
              label: 'Hot Reload',
              description:
                  'Edit the widget below, save (⌘S), and press r in the '
                  'terminal — the change appears instantly without restarting.',
            ),
            SizedBox(height: 10),
            _HotReloadCard(),
            SizedBox(height: 20),
            _SectionHeader(
              icon: Icons.terminal,
              iconColor: Color(0xFF22C55E),
              label: 'Debug Console',
              description:
                  'Tap the buttons to emit debugPrint() messages. '
                  'Watch them appear in the VS Code Debug Console or terminal.',
            ),
            SizedBox(height: 10),
            _DebugConsoleCard(),
            SizedBox(height: 20),
            _SectionHeader(
              icon: Icons.developer_mode,
              iconColor: Color(0xFF6366F1),
              label: 'Flutter DevTools',
              description:
                  'Run `flutter pub global run devtools` to open the suite. '
                  'Use the panels below to inspect widgets and check performance.',
            ),
            SizedBox(height: 10),
            _DevToolsCard(),
            SizedBox(height: 20),
            _SectionHeader(
              icon: Icons.speed,
              iconColor: Color(0xFFEC4899),
              label: 'Performance Widget',
              description:
                  'Scroll and animate this list while DevTools > Performance '
                  'is open to capture real frame-render data.',
            ),
            SizedBox(height: 10),
            _PerformanceCard(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}


class _HotReloadCard extends StatelessWidget {
  const _HotReloadCard();

  @override
  Widget build(BuildContext context) {
    const String demoText = 'Hello, Flutter!'; // ← try: 'Welcome to Hot Reload!'
    const Color demoColor = Color(0xFF4F46E5); // ← try: Color(0xFF059669)

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: demoColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.auto_awesome, color: demoColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  demoText,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: demoColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.edit_note,
            color: demoColor,
            text: 'Edit demoText or demoColor in the source, then save.',
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.keyboard,
            color: demoColor,
            text: 'Press  r  in the terminal to hot reload.',
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.check_circle_outline,
            color: const Color(0xFF059669),
            text: 'State (scroll position, counters) is preserved — no full restart.',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '// Before',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                ),
                Text(
                  "Text('Hello, Flutter!');",
                  style: TextStyle(
                      color: Color(0xFF93C5FD),
                      fontSize: 13,
                      fontFamily: 'monospace'),
                ),
                SizedBox(height: 8),
                Text(
                  '// After',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                ),
                Text(
                  "Text('Welcome to Hot Reload!');",
                  style: TextStyle(
                      color: Color(0xFF86EFAC),
                      fontSize: 13,
                      fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _DebugConsoleCard extends StatefulWidget {
  const _DebugConsoleCard();

  @override
  State<_DebugConsoleCard> createState() => _DebugConsoleCardState();
}

class _DebugConsoleCardState extends State<_DebugConsoleCard> {
  int _tapCount = 0;
  final List<_LogEntry> _logs = [];

  void _logInfo() {
    final msg = 'ℹ️  [INFO] Button tapped — tap #${_tapCount + 1}';
    debugPrint(msg);
    setState(() {
      _tapCount++;
      _logs.insert(0, _LogEntry(msg, _LogLevel.info));
      if (_logs.length > 8) _logs.removeLast();
    });
  }

  void _logWarning() {
    const msg = '⚠️  [WARN] Simulated warning — check your logic';
    debugPrint(msg);
    setState(() {
      _logs.insert(0, const _LogEntry(msg, _LogLevel.warning));
      if (_logs.length > 8) _logs.removeLast();
    });
  }

  void _logError() {
    const msg = '🔴 [ERROR] Simulated error — this would appear in red';
    debugPrint(msg);
    setState(() {
      _logs.insert(0, const _LogEntry(msg, _LogLevel.error));
      if (_logs.length > 8) _logs.removeLast();
    });
  }

  void _logRebuild() {
    final msg = '🔄 [DEBUG] Widget rebuilt — tap count: $_tapCount';
    debugPrint(msg);
    setState(() {
      _logs.insert(0, _LogEntry(msg, _LogLevel.debug));
      if (_logs.length > 8) _logs.removeLast();
    });
  }

  void _clearLogs() => setState(() => _logs.clear());

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'void increment() {',
                  style: TextStyle(
                      color: Color(0xFF93C5FD),
                      fontSize: 12,
                      fontFamily: 'monospace'),
                ),
                Text(
                  '  setState(() {',
                  style: TextStyle(
                      color: Color(0xFFE2E8F0),
                      fontSize: 12,
                      fontFamily: 'monospace'),
                ),
                Text(
                  '    count++;',
                  style: TextStyle(
                      color: Color(0xFFE2E8F0),
                      fontSize: 12,
                      fontFamily: 'monospace'),
                ),
                Text(
                  "    debugPrint('Button tapped! Count: \$count');",
                  style: TextStyle(
                      color: Color(0xFF86EFAC),
                      fontSize: 12,
                      fontFamily: 'monospace'),
                ),
                Text(
                  '  });',
                  style: TextStyle(
                      color: Color(0xFFE2E8F0),
                      fontSize: 12,
                      fontFamily: 'monospace'),
                ),
                Text(
                  '}',
                  style: TextStyle(
                      color: Color(0xFF93C5FD),
                      fontSize: 12,
                      fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _LogButton(
                label: 'Log Info',
                color: const Color(0xFF3B82F6),
                icon: Icons.info_outline,
                onPressed: _logInfo,
              ),
              _LogButton(
                label: 'Log Warning',
                color: const Color(0xFFF59E0B),
                icon: Icons.warning_amber_rounded,
                onPressed: _logWarning,
              ),
              _LogButton(
                label: 'Log Error',
                color: const Color(0xFFEF4444),
                icon: Icons.error_outline,
                onPressed: _logError,
              ),
              _LogButton(
                label: 'Rebuild',
                color: const Color(0xFF8B5CF6),
                icon: Icons.refresh,
                onPressed: _logRebuild,
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Debug Console output',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151)),
              ),
              if (_logs.isNotEmpty)
                GestureDetector(
                  onTap: _clearLogs,
                  child: const Text(
                    'Clear',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        decoration: TextDecoration.underline),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 60),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _logs.isEmpty
                ? const Text(
                    '// Tap a button to emit a log',
                    style: TextStyle(
                        color: Color(0xFF475569),
                        fontSize: 12,
                        fontFamily: 'monospace'),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _logs
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                e.message,
                                style: TextStyle(
                                  color: e.level.color,
                                  fontSize: 11,
                                                                    height: 1.4,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.lightbulb_outline,
            color: const Color(0xFFF59E0B),
            text:
                'Prefer debugPrint() over print() — it rate-limits output and '
                'avoids flooding the console on rapid state changes.',
          ),
        ],
      ),
    );
  }
}

enum _LogLevel {
  info(Color(0xFF60A5FA)),
  warning(Color(0xFFFBBF24)),
  error(Color(0xFFF87171)),
  debug(Color(0xFFA78BFA));

  final Color color;
  const _LogLevel(this.color);
}

class _LogEntry {
  final String message;
  final _LogLevel level;
  const _LogEntry(this.message, this.level);
}


class _DevToolsCard extends StatelessWidget {
  const _DevToolsCard();

  static const _panels = [
    _Panel(
      icon: Icons.account_tree_outlined,
      color: Color(0xFF6366F1),
      title: 'Widget Inspector',
      description:
          'Click any widget in the inspector to highlight it on screen. '
          'See the full widget tree, layout constraints, and property values '
          'without touching the source code.',
    ),
    _Panel(
      icon: Icons.speed,
      color: Color(0xFFEC4899),
      title: 'Performance',
      description:
          'Each bar represents one frame (target: ≤ 16 ms for 60 fps). '
          'Red bars indicate jank. Click a bar to see which build/layout/paint '
          'phase caused the spike.',
    ),
    _Panel(
      icon: Icons.memory,
      color: Color(0xFF10B981),
      title: 'Memory',
      description:
          'Track the Dart heap over time. A steadily growing heap without '
          'release is a memory leak. Use the allocation profiler to find which '
          'objects are accumulating.',
    ),
    _Panel(
      icon: Icons.wifi,
      color: Color(0xFF0EA5E9),
      title: 'Network',
      description:
          'Inspect HTTP and Firebase requests in real time — status codes, '
          'payload sizes, and timing. Useful for spotting over-fetching or '
          'missing error handling.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '# Option 1 — VS Code: Run → Open DevTools',
                  style: TextStyle(color: Color(0xFF475569), fontSize: 11),
                ),
                SizedBox(height: 6),
                Text(
                  '# Option 2 — Terminal',
                  style: TextStyle(color: Color(0xFF475569), fontSize: 11),
                ),
                Text(
                  'flutter pub global activate devtools',
                  style: TextStyle(
                      color: Color(0xFF86EFAC),
                      fontSize: 12,
                      fontFamily: 'monospace'),
                ),
                Text(
                  'flutter pub global run devtools',
                  style: TextStyle(
                      color: Color(0xFF86EFAC),
                      fontSize: 12,
                      fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._panels.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: p.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(p.icon, color: p.color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: p.color,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            p.description,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                                height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _Panel {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  const _Panel(
      {required this.icon,
      required this.color,
      required this.title,
      required this.description});
}


class _PerformanceCard extends StatefulWidget {
  const _PerformanceCard();

  @override
  State<_PerformanceCard> createState() => _PerformanceCardState();
}

class _PerformanceCardState extends State<_PerformanceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  int _rebuildCount = 0;
  bool _running = false;

  static const _items = [
    'Widget Inspector — select any widget on screen',
    'Performance — frame timeline (target < 16 ms)',
    'Memory — heap allocations over time',
    'Network — Firebase & HTTP request log',
    'Logging — structured debugPrint() output',
    'CPU Profiler — identify hot functions',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.addListener(() {
      if (_running) setState(() => _rebuildCount++);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _running = !_running);
    if (_running) {
      _controller.repeat(reverse: true);
      debugPrint('▶️  [PERF] Animation started — watch DevTools > Performance');
    } else {
      _controller.stop();
      debugPrint('⏸️  [PERF] Animation paused — rebuild count: $_rebuildCount');
    }
  }

  void _resetCount() => setState(() => _rebuildCount = 0);

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_rebuildCount',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFEC4899),
                    ),
                  ),
                  const Text(
                    'rebuild() calls',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
              Row(
                children: [
                  _LogButton(
                    label: _running ? 'Pause' : 'Animate',
                    color: const Color(0xFFEC4899),
                    icon: _running ? Icons.pause : Icons.play_arrow,
                    onPressed: _toggle,
                  ),
                  const SizedBox(width: 8),
                  _LogButton(
                    label: 'Reset',
                    color: const Color(0xFF6B7280),
                    icon: Icons.refresh,
                    onPressed: _resetCount,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) => Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color(0xFFF3F4F6),
              ),
              child: FractionallySizedBox(
                widthFactor: _animation.value,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'DevTools panels to open while animating:',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151)),
          ),
          const SizedBox(height: 8),
          ..._items.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${e.key + 1}.',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEC4899)),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        e.value,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4B5563),
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}


class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String description;

  const _SectionHeader({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF6B7280), height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

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
      padding: const EdgeInsets.all(18),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _InfoRow(
      {required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF4B5563), height: 1.4)),
        ),
      ],
    );
  }
}

class _LogButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const _LogButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 15),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );
  }
}
