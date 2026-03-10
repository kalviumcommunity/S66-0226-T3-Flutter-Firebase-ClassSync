import 'package:flutter/material.dart';

class DesignSystemScreen extends StatefulWidget {
  const DesignSystemScreen({super.key});

  @override
  State<DesignSystemScreen> createState() => _DesignSystemScreenState();
}

class _DesignSystemScreenState extends State<DesignSystemScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const List<_TabItem> _tabs = [
    _TabItem(icon: Icons.lightbulb_outline, label: 'Design'),
    _TabItem(icon: Icons.palette_outlined, label: 'Tokens'),
    _TabItem(icon: Icons.widgets_outlined, label: 'Widgets'),
    _TabItem(icon: Icons.devices_outlined, label: 'Adaptive'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: DSColors.surface,
      appBar: AppBar(
        backgroundColor: DSColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Design System',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Figma → Flutter · Design Thinking',
              style: TextStyle(
                fontSize: isTablet ? 12 : 10,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: _tabs
              .map(
                (t) => Tab(
                  icon: Icon(t.icon, size: isTablet ? 20 : 18),
                  text: isTablet ? t.label : null,
                  iconMargin: const EdgeInsets.only(bottom: 2),
                ),
              )
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _DesignThinkingTab(),
          _DesignTokensTab(),
          _WidgetCatalogTab(),
          _AdaptiveLayoutTab(),
        ],
      ),
    );
  }
}

abstract final class DSColors {
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color secondary = Color(0xFF0EA5E9);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color surfaceCard = Colors.white;
  static const Color onSurface = Color(0xFF1E293B);
  static const Color onSurfaceMuted = Color(0xFF64748B);
  static const Color divider = Color(0xFFE2E8F0);
}

abstract final class DSSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

abstract final class DSRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double full = 999;
}

class _SectionHeading extends StatelessWidget {
  final String text;
  const _SectionHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DSSpacing.sm),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: DSColors.onSurface,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const _Card({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(DSSpacing.md),
      decoration: BoxDecoration(
        color: DSColors.surfaceCard,
        borderRadius: BorderRadius.circular(DSRadius.md),
        border: Border.all(color: DSColors.divider),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _DesignThinkingTab extends StatelessWidget {
  const _DesignThinkingTab();

  static const List<_Stage> _stages = [
    _Stage(
      step: '01',
      label: 'Empathize',
      icon: Icons.favorite_border,
      color: Color(0xFF4F46E5),
      description:
          'Understand the user\'s context, frustrations, and goals. For ClassSync, students need fewer taps to add tasks and want instant visibility of pending work.',
      figmaNote: 'User journey maps & persona cards.',
    ),
    _Stage(
      step: '02',
      label: 'Define',
      icon: Icons.center_focus_strong_outlined,
      color: Color(0xFF0EA5E9),
      description:
          'Narrow to the core problem: "Students lose track of deadlines because task entry is buried in menus." This drives every layout decision.',
      figmaNote: 'Problem statement sticky notes in FigJam.',
    ),
    _Stage(
      step: '03',
      label: 'Ideate',
      icon: Icons.emoji_objects_outlined,
      color: Color(0xFF10B981),
      description:
          'Sketch multiple layout options — bottom FAB for quick add, card-based task list, colour-coded urgency flags. Pick the highest-impact idea.',
      figmaNote: 'Low-fidelity wireframes in Figma.',
    ),
    _Stage(
      step: '04',
      label: 'Prototype',
      icon: Icons.design_services_outlined,
      color: Color(0xFFF59E0B),
      description:
          'Build interactive Figma screens with Auto Layout, component variants, and a shared style guide (colours, type scale, spacing tokens).',
      figmaNote: 'Clickable Figma prototype with transitions.',
    ),
    _Stage(
      step: '05',
      label: 'Test',
      icon: Icons.science_outlined,
      color: Color(0xFFEF4444),
      description:
          'Translate the prototype to Flutter. Measure real device rendering, iterate on spacing and contrast, and gather feedback before the next sprint.',
      figmaNote: 'Flutter implementation (this screen).',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double hPad =
        MediaQuery.of(context).size.width >= 600 ? DSSpacing.xl : DSSpacing.md;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: DSSpacing.lg),
      children: [
        _Card(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DSSpacing.md),
                decoration: BoxDecoration(
                  color: DSColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(DSRadius.md),
                ),
                child: const Icon(Icons.design_services,
                    color: DSColors.primary, size: 32),
              ),
              const SizedBox(width: DSSpacing.md),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Figma → Flutter',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: DSColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Human-centred design translated into responsive Flutter UI using the 5-stage Design Thinking process.',
                      style: TextStyle(
                        fontSize: 13,
                        color: DSColors.onSurfaceMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: DSSpacing.lg),
        const _SectionHeading('The 5 Stages'),
        ..._stages.map((s) => _StageCard(stage: s)),
      ],
    );
  }
}

class _StageCard extends StatelessWidget {
  final _Stage stage;
  const _StageCard({required this.stage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DSSpacing.sm),
      child: _Card(
        padding: const EdgeInsets.all(DSSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: stage.color,
                borderRadius: BorderRadius.circular(DSRadius.full),
              ),
              alignment: Alignment.center,
              child: Text(
                stage.step,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: DSSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(stage.icon, color: stage.color, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        stage.label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: stage.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    stage.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: DSColors.onSurface,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome,
                          size: 12, color: DSColors.onSurfaceMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          stage.figmaNote,
                          style: const TextStyle(
                            fontSize: 11,
                            color: DSColors.onSurfaceMuted,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesignTokensTab extends StatelessWidget {
  const _DesignTokensTab();

  @override
  Widget build(BuildContext context) {
    final double hPad =
        MediaQuery.of(context).size.width >= 600 ? DSSpacing.xl : DSSpacing.md;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: DSSpacing.lg),
      children: [
        const _SectionHeading('Color Palette'),
        _Card(
          child: Wrap(
            spacing: DSSpacing.sm,
            runSpacing: DSSpacing.sm,
            children: const [
              _ColorSwatch(
                  label: 'Primary', hex: '#4F46E5', color: DSColors.primary),
              _ColorSwatch(
                  label: 'Primary Light',
                  hex: '#818CF8',
                  color: DSColors.primaryLight),
              _ColorSwatch(
                  label: 'Secondary',
                  hex: '#0EA5E9',
                  color: DSColors.secondary),
              _ColorSwatch(
                  label: 'Success', hex: '#10B981', color: DSColors.success),
              _ColorSwatch(
                  label: 'Warning', hex: '#F59E0B', color: DSColors.warning),
              _ColorSwatch(
                  label: 'Error', hex: '#EF4444', color: DSColors.error),
            ],
          ),
        ),
        const SizedBox(height: DSSpacing.lg),

        const _SectionHeading('Typography Scale'),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _TypeSample(
                  label: 'DisplayLarge',
                  fontSize: 28,
                  weight: FontWeight.bold,
                  sample: 'ClassSync'),
              _TypeSample(
                  label: 'HeadlineMedium',
                  fontSize: 22,
                  weight: FontWeight.bold,
                  sample: 'Dashboard'),
              _TypeSample(
                  label: 'TitleLarge',
                  fontSize: 18,
                  weight: FontWeight.w600,
                  sample: 'Sprint #4'),
              _TypeSample(
                  label: 'BodyLarge',
                  fontSize: 16,
                  weight: FontWeight.normal,
                  sample: 'Body paragraph text appears here'),
              _TypeSample(
                  label: 'BodySmall',
                  fontSize: 13,
                  weight: FontWeight.normal,
                  sample: 'Captions and helper text'),
              _TypeSample(
                  label: 'LabelSmall',
                  fontSize: 11,
                  weight: FontWeight.w600,
                  sample: 'LABEL / TAG'),
            ],
          ),
        ),
        const SizedBox(height: DSSpacing.lg),

        const _SectionHeading('Spacing Scale'),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _SpacingSample(token: 'xs', value: DSSpacing.xs),
              _SpacingSample(token: 'sm', value: DSSpacing.sm),
              _SpacingSample(token: 'md', value: DSSpacing.md),
              _SpacingSample(token: 'lg', value: DSSpacing.lg),
              _SpacingSample(token: 'xl', value: DSSpacing.xl),
              _SpacingSample(token: 'xxl', value: DSSpacing.xxl),
            ],
          ),
        ),
        const SizedBox(height: DSSpacing.lg),

        const _SectionHeading('Border Radius'),
        _Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _RadiusSample(token: 'sm', value: DSRadius.sm),
              _RadiusSample(token: 'md', value: DSRadius.md),
              _RadiusSample(token: 'lg', value: DSRadius.lg),
              _RadiusSample(token: 'full', value: 24),
            ],
          ),
        ),
        const SizedBox(height: DSSpacing.md),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final String label;
  final String hex;
  final Color color;
  const _ColorSwatch(
      {required this.label, required this.hex, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(DSRadius.md),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: DSColors.onSurface),
          textAlign: TextAlign.center,
        ),
        Text(
          hex,
          style: const TextStyle(
            fontSize: 10,
            color: DSColors.onSurfaceMuted,
                      ),
        ),
      ],
    );
  }
}

class _TypeSample extends StatelessWidget {
  final String label;
  final double fontSize;
  final FontWeight weight;
  final String sample;
  const _TypeSample(
      {required this.label,
      required this.fontSize,
      required this.weight,
      required this.sample});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: DSColors.onSurfaceMuted,
                              ),
            ),
          ),
          Expanded(
            child: Text(
              sample,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: weight,
                color: DSColors.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpacingSample extends StatelessWidget {
  final String token;
  final double value;
  const _SpacingSample({required this.token, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              token,
              style: const TextStyle(
                fontSize: 12,
                color: DSColors.onSurfaceMuted,
                              ),
            ),
          ),
          Text(
            '${value.toInt()} dp',
            style: const TextStyle(
              fontSize: 12,
              color: DSColors.onSurfaceMuted,
            ),
          ),
          const SizedBox(width: DSSpacing.md),
          Container(
            width: value * 1.5,
            height: 14,
            decoration: BoxDecoration(
              color: DSColors.primary.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(3),
              border:
                  Border.all(color: DSColors.primary.withValues(alpha: 0.4)),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadiusSample extends StatelessWidget {
  final String token;
  final double value;
  const _RadiusSample({required this.token, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: DSColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(value),
            border:
                Border.all(color: DSColors.primary.withValues(alpha: 0.4)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          token,
          style: const TextStyle(fontSize: 11, color: DSColors.onSurfaceMuted),
        ),
        Text(
          '${value.toInt()} dp',
          style: const TextStyle(
            fontSize: 10,
            color: DSColors.onSurfaceMuted,
                      ),
        ),
      ],
    );
  }
}

class _WidgetCatalogTab extends StatefulWidget {
  const _WidgetCatalogTab();

  @override
  State<_WidgetCatalogTab> createState() => _WidgetCatalogTabState();
}

class _WidgetCatalogTabState extends State<_WidgetCatalogTab> {
  final TextEditingController _taskCtrl = TextEditingController();
  bool _switchVal = true;
  double _sliderVal = 0.4;
  String _selectedChip = 'All';

  @override
  void dispose() {
    _taskCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double hPad =
        MediaQuery.of(context).size.width >= 600 ? DSSpacing.xl : DSSpacing.md;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: DSSpacing.lg),
      children: [
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.compare_arrows,
                      color: DSColors.primary, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Figma Component → Flutter Widget',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: DSColors.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DSSpacing.sm),
              const Divider(color: DSColors.divider),
              ..._widgetMap.map(_MappingRow.new),
            ],
          ),
        ),
        const SizedBox(height: DSSpacing.lg),

        const _SectionHeading('Buttons'),
        _Card(
          child: Wrap(
            spacing: DSSpacing.sm,
            runSpacing: DSSpacing.sm,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DSColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(DSRadius.sm),
                  ),
                ),
                onPressed: () {},
                child: const Text('ElevatedButton'),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: DSColors.primary,
                  side: const BorderSide(color: DSColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(DSRadius.sm),
                  ),
                ),
                onPressed: () {},
                child: const Text('OutlinedButton'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'TextButton',
                  style: TextStyle(color: DSColors.primary),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add_circle_outline,
                    color: DSColors.primary),
                tooltip: 'IconButton',
              ),
              FloatingActionButton.small(
                heroTag: 'catalog_fab',
                backgroundColor: DSColors.primary,
                onPressed: () {},
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: DSSpacing.lg),

        const _SectionHeading('TextField (Input Field)'),
        _Card(
          child: Column(
            children: [
              TextField(
                controller: _taskCtrl,
                decoration: InputDecoration(
                  labelText: 'Enter task title',
                  hintText: 'e.g. Submit assignment #3',
                  prefixIcon: const Icon(Icons.edit_outlined,
                      color: DSColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DSRadius.sm),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DSRadius.sm),
                    borderSide:
                        const BorderSide(color: DSColors.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                ),
              ),
              const SizedBox(height: DSSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DSColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DSRadius.sm),
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Task'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: DSSpacing.lg),

        const _SectionHeading('Cards'),
        _Card(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _TaskRow(
                title: 'Submit assignment #3',
                subtitle: 'Due Today · Math',
                urgency: DSColors.error,
                done: false,
              ),
              const Divider(height: 1, color: DSColors.divider),
              _TaskRow(
                title: 'Review lecture notes',
                subtitle: 'Due Tomorrow · Physics',
                urgency: DSColors.warning,
                done: false,
              ),
              const Divider(height: 1, color: DSColors.divider),
              _TaskRow(
                title: 'Group project kickoff',
                subtitle: 'Mar 8 · Computer Science',
                urgency: DSColors.success,
                done: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: DSSpacing.lg),

        const _SectionHeading('Filter Chips'),
        _Card(
          child: Wrap(
            spacing: DSSpacing.sm,
            runSpacing: DSSpacing.sm,
            children: ['All', 'Pending', 'Done', 'Math', 'Physics', 'CS']
                .map(
                  (label) => FilterChip(
                    label: Text(label),
                    selected: _selectedChip == label,
                    onSelected: (_) =>
                        setState(() => _selectedChip = label),
                    selectedColor:
                        DSColors.primary.withValues(alpha: 0.15),
                    checkmarkColor: DSColors.primary,
                    labelStyle: TextStyle(
                      color: _selectedChip == label
                          ? DSColors.primary
                          : DSColors.onSurfaceMuted,
                      fontWeight: _selectedChip == label
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: DSSpacing.lg),

        const _SectionHeading('Toggle & Slider'),
        _Card(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Push notifications',
                    style: TextStyle(
                      fontSize: 14,
                      color: DSColors.onSurface,
                    ),
                  ),
                  Switch(
                    value: _switchVal,
                    activeColor: DSColors.primary,
                    onChanged: (v) => setState(() => _switchVal = v),
                  ),
                ],
              ),
              const Divider(color: DSColors.divider),
              Row(
                children: [
                  const Text(
                    'Progress',
                    style: TextStyle(fontSize: 14, color: DSColors.onSurface),
                  ),
                  Expanded(
                    child: Slider(
                      value: _sliderVal,
                      activeColor: DSColors.primary,
                      onChanged: (v) =>
                          setState(() => _sliderVal = v),
                    ),
                  ),
                  Text(
                    '${(_sliderVal * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      color: DSColors.onSurfaceMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: DSSpacing.md),
      ],
    );
  }
}

class _MappingRow extends StatelessWidget {
  final _WidgetMapItem item;
  const _MappingRow(this.item);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.square_rounded,
                    size: 8, color: DSColors.primary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    item.figma,
                    style: const TextStyle(
                      fontSize: 12,
                      color: DSColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward, size: 14, color: DSColors.onSurfaceMuted),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                item.flutter,
                style: const TextStyle(
                  fontSize: 12,
                  color: DSColors.primary,
                                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color urgency;
  final bool done;
  const _TaskRow({
    required this.title,
    required this.subtitle,
    required this.urgency,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: DSSpacing.md, vertical: DSSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 36,
            decoration: BoxDecoration(
              color: urgency,
              borderRadius: BorderRadius.circular(DSRadius.full),
            ),
          ),
          const SizedBox(width: DSSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: DSColors.onSurface,
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: DSColors.onSurfaceMuted,
                  ),
                ),
              ],
            ),
          ),
          if (done)
            const Icon(Icons.check_circle, color: DSColors.success, size: 20)
          else
            Icon(Icons.radio_button_unchecked, color: urgency, size: 20),
        ],
      ),
    );
  }
}

class _AdaptiveLayoutTab extends StatelessWidget {
  const _AdaptiveLayoutTab();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth >= 600;

    final double hPad = isTablet ? DSSpacing.xl : DSSpacing.md;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: DSSpacing.lg),
      children: [
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline, color: DSColors.primary, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Live MediaQuery Values',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: DSColors.onSurface,
                    ),
                  ),
                ],
              ),
              const Divider(color: DSColors.divider, height: 20),
              _InfoRow(label: 'Screen width', value: '${screenWidth.toInt()} dp'),
              _InfoRow(
                  label: 'Screen height', value: '${screenHeight.toInt()} dp'),
              _InfoRow(
                  label: 'Orientation',
                  value: MediaQuery.of(context).orientation ==
                          Orientation.portrait
                      ? 'Portrait'
                      : 'Landscape'),
              _InfoRow(
                  label: 'Device pixel ratio',
                  value: MediaQuery.of(context)
                      .devicePixelRatio
                      .toStringAsFixed(1)),
              _InfoRow(
                  label: 'Text scale factor',
                  value: MediaQuery.of(context)
                      .textScaler
                      .scale(1.0)
                      .toStringAsFixed(2)),
              _InfoRow(
                  label: 'Platform',
                  value: Theme.of(context).platform.name),
              _InfoRow(label: 'Layout', value: isTablet ? 'Tablet' : 'Phone'),
            ],
          ),
        ),
        const SizedBox(height: DSSpacing.lg),

        const _SectionHeading('OrientationBuilder'),
        _Card(
          child: OrientationBuilder(
            builder: (context, orientation) {
              final bool portrait = orientation == Orientation.portrait;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        portrait
                            ? Icons.stay_current_portrait
                            : Icons.stay_current_landscape,
                        color: DSColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        portrait ? 'Portrait mode' : 'Landscape mode',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: DSColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DSSpacing.sm),
                  portrait
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            _MiniPanel(
                                label: 'Stats', color: Color(0xFFEDE9FE)),
                            SizedBox(height: DSSpacing.xs),
                            _MiniPanel(
                                label: 'Tasks', color: Color(0xFFDCFCE7)),
                            SizedBox(height: DSSpacing.xs),
                            _MiniPanel(
                                label: 'Schedule', color: Color(0xFFE0F2FE)),
                          ],
                        )
                      : Row(
                          children: const [
                            Expanded(
                              child: _MiniPanel(
                                  label: 'Stats', color: Color(0xFFEDE9FE)),
                            ),
                            SizedBox(width: DSSpacing.xs),
                            Expanded(
                              child: _MiniPanel(
                                  label: 'Tasks', color: Color(0xFFDCFCE7)),
                            ),
                            SizedBox(width: DSSpacing.xs),
                            Expanded(
                              child: _MiniPanel(
                                  label: 'Schedule',
                                  color: Color(0xFFE0F2FE)),
                            ),
                          ],
                        ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: DSSpacing.lg),

        const _SectionHeading('LayoutBuilder'),
        _Card(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double maxW = constraints.maxWidth;
              final int cols = maxW > 480 ? 3 : maxW > 300 ? 2 : 1;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available width: ${maxW.toInt()} dp → $cols column${cols > 1 ? "s" : ""}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: DSColors.onSurfaceMuted,
                    ),
                  ),
                  const SizedBox(height: DSSpacing.sm),
                  Wrap(
                    spacing: DSSpacing.sm,
                    runSpacing: DSSpacing.sm,
                    children: List.generate(
                      6,
                      (i) => SizedBox(
                        width: (maxW - (cols - 1) * DSSpacing.sm) / cols,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color:
                                DSColors.primary.withValues(alpha: 0.08 + i * 0.04),
                            borderRadius: BorderRadius.circular(DSRadius.sm),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Card ${i + 1}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: DSColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: DSSpacing.lg),

        const _SectionHeading('Flexible vs Expanded'),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Expanded (fills all remaining space):',
                style: TextStyle(fontSize: 12, color: DSColors.onSurfaceMuted),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 36,
                    color: const Color(0xFFEDE9FE),
                    alignment: Alignment.center,
                    child: const Text('Fixed',
                        style: TextStyle(
                            fontSize: 11,
                            color: DSColors.primary,
                            fontWeight: FontWeight.w600)),
                  ),
                  Expanded(
                    child: Container(
                      height: 36,
                      color: DSColors.primary,
                      alignment: Alignment.center,
                      child: const Text('Expanded',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DSSpacing.sm),
              const Text(
                'Flexible (wraps content, allows shrinking):',
                style: TextStyle(fontSize: 12, color: DSColors.onSurfaceMuted),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: const Color(0xFFDCFCE7),
                      child: const Text('Flexible — takes only what it needs',
                          style: TextStyle(
                              fontSize: 11,
                              color: DSColors.success,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 60,
                    height: 36,
                    color: const Color(0xFFE0F2FE),
                    alignment: Alignment.center,
                    child: const Text('Fixed',
                        style: TextStyle(
                            fontSize: 11,
                            color: DSColors.secondary,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: DSSpacing.lg),

        const _SectionHeading('Responsive Dashboard Preview'),
        _DashboardPreview(isTablet: isTablet),
        const SizedBox(height: DSSpacing.md),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: DSColors.onSurfaceMuted,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: DSColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniPanel extends StatelessWidget {
  final String label;
  final Color color;
  const _MiniPanel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(DSRadius.sm),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: DSColors.onSurface,
        ),
      ),
    );
  }
}

class _DashboardPreview extends StatelessWidget {
  final bool isTablet;
  const _DashboardPreview({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    if (isTablet) {
      return _Card(
        padding: const EdgeInsets.all(DSSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _PreviewSidebar(),
            SizedBox(width: DSSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatsRow(),
                  SizedBox(height: DSSpacing.sm),
                  _PreviewTaskList(),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return _Card(
      padding: const EdgeInsets.all(DSSpacing.md),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StatsRow(),
          SizedBox(height: DSSpacing.sm),
          _PreviewTaskList(),
        ],
      ),
    );
  }
}

class _PreviewSidebar extends StatelessWidget {
  const _PreviewSidebar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(DSSpacing.sm),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FE),
        borderRadius: BorderRadius.circular(DSRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Navigation',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: DSColors.primary,
            ),
          ),
          const SizedBox(height: DSSpacing.sm),
          ...[
            (Icons.home_outlined, 'Home'),
            (Icons.assignment_outlined, 'Tasks'),
            (Icons.calendar_today_outlined, 'Schedule'),
            (Icons.settings_outlined, 'Settings'),
          ].map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Icon(item.$1, size: 14, color: DSColors.primary),
                  const SizedBox(width: 6),
                  Text(item.$2,
                      style: const TextStyle(
                          fontSize: 12, color: DSColors.onSurface)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    const stats = [
      ('12', 'Classes', DSColors.primary),
      ('5', 'Pending', DSColors.warning),
      ('98%', 'Attend.', DSColors.success),
    ];
    return Row(
      children: stats.map((s) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: s.$3.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(DSRadius.sm),
              border: Border.all(color: s.$3.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Text(
                  s.$1,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: s.$3,
                  ),
                ),
                Text(
                  s.$2,
                  style: const TextStyle(
                    fontSize: 10,
                    color: DSColors.onSurfaceMuted,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PreviewTaskList extends StatelessWidget {
  const _PreviewTaskList();

  @override
  Widget build(BuildContext context) {
    const tasks = [
      ('Submit assignment #3', DSColors.error),
      ('Review lecture notes', DSColors.warning),
      ('Group project kickoff', DSColors.success),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tasks',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: DSColors.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        ...tasks.map(
          (t) => Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(
                horizontal: DSSpacing.sm, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(DSRadius.sm),
              border: Border(
                left: BorderSide(color: t.$2, width: 3),
              ),
            ),
            child: Text(
              t.$1,
              style: const TextStyle(fontSize: 12, color: DSColors.onSurface),
            ),
          ),
        ),
      ],
    );
  }
}

class _TabItem {
  final IconData icon;
  final String label;
  const _TabItem({required this.icon, required this.label});
}

class _Stage {
  final String step;
  final String label;
  final IconData icon;
  final Color color;
  final String description;
  final String figmaNote;
  const _Stage({
    required this.step,
    required this.label,
    required this.icon,
    required this.color,
    required this.description,
    required this.figmaNote,
  });
}

class _WidgetMapItem {
  final String figma;
  final String flutter;
  const _WidgetMapItem(this.figma, this.flutter);
}

const List<_WidgetMapItem> _widgetMap = [
  _WidgetMapItem('Text / Heading', 'Text() + TextStyle'),
  _WidgetMapItem('Frame / Container', 'Container() / SizedBox()'),
  _WidgetMapItem('Auto Layout (H)', 'Row() + Expanded()'),
  _WidgetMapItem('Auto Layout (V)', 'Column() + Expanded()'),
  _WidgetMapItem('Card', 'Card() or Container + BoxDecoration'),
  _WidgetMapItem('Button (Filled)', 'ElevatedButton()'),
  _WidgetMapItem('Button (Outlined)', 'OutlinedButton()'),
  _WidgetMapItem('Button (Ghost)', 'TextButton()'),
  _WidgetMapItem('Icon Button', 'IconButton()'),
  _WidgetMapItem('FAB', 'FloatingActionButton()'),
  _WidgetMapItem('Input Field', 'TextField() + InputDecoration'),
  _WidgetMapItem('Toggle', 'Switch()'),
  _WidgetMapItem('Chip / Tag', 'FilterChip() / Chip()'),
  _WidgetMapItem('Scrollable Area', 'SingleChildScrollView() / ListView()'),
  _WidgetMapItem('Navigation Bar', 'BottomNavigationBar() / NavigationBar()'),
];
