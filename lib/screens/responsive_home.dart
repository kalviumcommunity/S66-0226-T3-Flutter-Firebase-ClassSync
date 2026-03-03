import 'package:flutter/material.dart';

/// ResponsiveHomeScreen — Sprint #3 Deliverable
///
/// Demonstrates:
/// • MediaQuery for device dimensions and orientation detection
/// • LayoutBuilder for constraint-based responsiveness
/// • Expanded, Flexible, FittedBox, AspectRatio widgets
/// • Wrap, GridView.builder for adaptive positioning
/// • Conditional layouts: phone single-column vs tablet two-column
class ResponsiveHomeScreen extends StatefulWidget {
  const ResponsiveHomeScreen({super.key});

  @override
  State<ResponsiveHomeScreen> createState() => _ResponsiveHomeScreenState();
}

class _ResponsiveHomeScreenState extends State<ResponsiveHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // ── Responsive breakpoints ─────────────────────────────────────────────────
  static const double _tabletBreakpoint = 600.0;
  static const double _desktopBreakpoint = 900.0;

  String _deviceLabel(double width) {
    if (width >= _desktopBreakpoint) return 'Desktop / Large Tablet';
    if (width >= _tabletBreakpoint) return 'Tablet';
    return 'Phone';
  }

  IconData _deviceIcon(double width) {
    if (width >= _desktopBreakpoint) return Icons.desktop_mac_outlined;
    if (width >= _tabletBreakpoint) return Icons.tablet_mac_outlined;
    return Icons.phone_android_outlined;
  }

  // ── Feature data ───────────────────────────────────────────────────────────
  final List<_FeatureItem> _features = const [
    _FeatureItem(
      icon: Icons.search,
      color: Color(0xFF4F46E5),
      label: 'Smart Search',
      description: 'Find classes, notes, and assignments instantly.',
    ),
    _FeatureItem(
      icon: Icons.calendar_today_outlined,
      color: Color(0xFF0EA5E9),
      label: 'Schedule',
      description: 'View upcoming classes and deadlines in one place.',
    ),
    _FeatureItem(
      icon: Icons.group_outlined,
      color: Color(0xFF10B981),
      label: 'Groups',
      description: 'Collaborate with classmates in real time.',
    ),
    _FeatureItem(
      icon: Icons.notifications_outlined,
      color: Color(0xFFF59E0B),
      label: 'Alerts',
      description: 'Never miss an important classroom update.',
    ),
    _FeatureItem(
      icon: Icons.bar_chart_outlined,
      color: Color(0xFFEF4444),
      label: 'Analytics',
      description: 'Track your academic progress with insights.',
    ),
    _FeatureItem(
      icon: Icons.cloud_sync_outlined,
      color: Color(0xFF8B5CF6),
      label: 'Sync',
      description: 'Keep data in sync across all your devices.',
    ),
  ];

  // ── Stats data ─────────────────────────────────────────────────────────────
  final List<_StatItem> _stats = const [
    _StatItem(value: '12', label: 'Classes'),
    _StatItem(value: '5', label: 'Assignments'),
    _StatItem(value: '3', label: 'Pending'),
    _StatItem(value: '98%', label: 'Attendance'),
  ];

  @override
  Widget build(BuildContext context) {
    // ── MediaQuery values ──────────────────────────────────────────────────
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;
    final bool isPortrait =
        mediaQuery.orientation == Orientation.portrait;
    final bool isTablet = screenWidth >= _tabletBreakpoint;
    final bool isDesktop = screenWidth >= _desktopBreakpoint;

    // Adaptive padding & font scale
    final double horizontalPadding = isDesktop
        ? 48
        : isTablet
            ? 32
            : 16;
    final double titleFontSize = isDesktop
        ? 28
        : isTablet
            ? 24
            : 20;
    final double bodyFontSize = isTablet ? 15 : 13;

    // Adaptive grid columns for feature cards
    final int gridColumns = isDesktop
        ? 3
        : isTablet
            ? 2
            : (isPortrait ? 1 : 2);

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // ── AppBar / Custom Header ─────────────────────────────────────────
      appBar: _buildAppBar(
        context,
        screenWidth,
        titleFontSize,
        isTablet,
        colorScheme,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 20,
          ),
          child: isTablet && isPortrait
              ? _buildTabletPortraitLayout(
                  context,
                  screenWidth,
                  screenHeight,
                  gridColumns,
                  titleFontSize,
                  bodyFontSize,
                  isDesktop,
                )
              : _buildPhoneLayout(
                  context,
                  screenWidth,
                  screenHeight,
                  gridColumns,
                  titleFontSize,
                  bodyFontSize,
                  isPortrait,
                ),
        ),
      ),
      // ── Footer / Bottom action bar ────────────────────────────────────
      bottomNavigationBar: _buildFooter(
        context,
        isTablet,
        colorScheme,
        bodyFontSize,
      ),
    );
  }

  // ── Custom AppBar ──────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    double screenWidth,
    double titleFontSize,
    bool isTablet,
    ColorScheme colorScheme,
  ) {
    return AppBar(
      backgroundColor: const Color(0xFF4F46E5),
      foregroundColor: Colors.white,
      elevation: 0,
      title: LayoutBuilder(
        builder: (ctx, constraints) {
          return Row(
            children: [
              const Icon(Icons.school_outlined, color: Colors.white70),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ClassSync — Responsive Layout',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: titleFontSize,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'Sprint #3 · MediaQuery & LayoutBuilder Demo',
                      style: TextStyle(
                        fontSize: isTablet ? 12 : 10,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: const Icon(Icons.person_outline, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // ── Phone / Landscape layout (single-column) ───────────────────────────────
  Widget _buildPhoneLayout(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    int gridColumns,
    double titleFontSize,
    double bodyFontSize,
    bool isPortrait,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Device info banner
        _DeviceInfoBanner(
          width: screenWidth,
          height: screenHeight,
          label: _deviceLabel(screenWidth),
          icon: _deviceIcon(screenWidth),
        ),
        const SizedBox(height: 20),

        // Hero / greeting section
        _HeroSection(
          titleFontSize: titleFontSize,
          bodyFontSize: bodyFontSize,
          isRow: !isPortrait, // landscape→ side-by-side
        ),
        const SizedBox(height: 20),

        // Stats row
        _StatsRow(stats: _stats, isTablet: false),
        const SizedBox(height: 24),

        // Section title
        Text(
          'Features',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),

        // Feature grid — uses LayoutBuilder for column count
        _FeatureGrid(
          features: _features,
          columns: gridColumns,
          bodyFontSize: bodyFontSize,
        ),
        const SizedBox(height: 24),

        // Wrap demo — chips
        _WrapChipSection(bodyFontSize: bodyFontSize),
        const SizedBox(height: 24),

        // Aspect-ratio card
        _AspectRatioCard(titleFontSize: titleFontSize),
        const SizedBox(height: 16),
      ],
    );
  }

  // ── Tablet portrait layout (two-column side-by-side) ─────────────────────
  Widget _buildTabletPortraitLayout(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    int gridColumns,
    double titleFontSize,
    double bodyFontSize,
    bool isDesktop,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DeviceInfoBanner(
          width: screenWidth,
          height: screenHeight,
          label: _deviceLabel(screenWidth),
          icon: _deviceIcon(screenWidth),
        ),
        const SizedBox(height: 20),

        // Two-column layout for tablet
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column — hero + stats
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroSection(
                    titleFontSize: titleFontSize,
                    bodyFontSize: bodyFontSize,
                    isRow: false,
                  ),
                  const SizedBox(height: 20),
                  _StatsRow(stats: _stats, isTablet: true),
                  const SizedBox(height: 20),
                  _WrapChipSection(bodyFontSize: bodyFontSize),
                ],
              ),
            ),
            const SizedBox(width: 24),
            // Right column — features + aspect ratio
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Features',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _FeatureGrid(
                    features: _features,
                    columns: gridColumns,
                    bodyFontSize: bodyFontSize,
                  ),
                  const SizedBox(height: 20),
                  _AspectRatioCard(titleFontSize: titleFontSize),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ── Footer / Bottom nav bar ────────────────────────────────────────────────
  Widget _buildFooter(
    BuildContext context,
    bool isTablet,
    ColorScheme colorScheme,
    double bodyFontSize,
  ) {
    final actions = [
      _FooterAction(icon: Icons.home_outlined, label: 'Home'),
      _FooterAction(icon: Icons.class_outlined, label: 'Classes'),
      _FooterAction(icon: Icons.assignment_outlined, label: 'Tasks'),
      _FooterAction(icon: Icons.settings_outlined, label: 'Settings'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: isTablet ? 48 : 8,
      ),
      child: SafeArea(
        top: false,
        child: isTablet
            // Tablet footer: labelled text buttons side by side
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actions
                    .map(
                      (a) => TextButton.icon(
                        onPressed: () {},
                        icon: Icon(a.icon,
                            color: const Color(0xFF4F46E5)),
                        label: Text(
                          a.label,
                          style: TextStyle(
                            color: const Color(0xFF4F46E5),
                            fontSize: bodyFontSize,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              )
            // Phone footer: icon-only bottom nav
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: actions
                    .map(
                      (a) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(a.icon,
                              color: const Color(0xFF4F46E5), size: 22),
                          const SizedBox(height: 2),
                          Text(
                            a.label,
                            style: TextStyle(
                              fontSize: 10,
                              color: const Color(0xFF4F46E5),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

/// Banner showing current device info from MediaQuery
class _DeviceInfoBanner extends StatelessWidget {
  final double width;
  final double height;
  final String label;
  final IconData icon;

  const _DeviceInfoBanner({
    required this.width,
    required this.height,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Width: ${width.toStringAsFixed(0)} px  •  Height: ${height.toStringAsFixed(0)} px',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? '↕ Portrait'
                  : '↔ Landscape',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Hero greeting section, switches between Row (landscape) and Column (portrait)
class _HeroSection extends StatelessWidget {
  final double titleFontSize;
  final double bodyFontSize;
  final bool isRow;

  const _HeroSection({
    required this.titleFontSize,
    required this.bodyFontSize,
    required this.isRow,
  });

  @override
  Widget build(BuildContext context) {
    final textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            'Good Morning, Student! 👋',
            style: TextStyle(
              fontSize: titleFontSize + 2,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Your responsive ClassSync dashboard adapts to\nany screen size using MediaQuery & LayoutBuilder.',
          style: TextStyle(
            fontSize: bodyFontSize,
            color: const Color(0xFF64748B),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            _PrimaryButton(
              label: 'View Schedule',
              icon: Icons.calendar_today_outlined,
            ),
            _OutlineButton(
              label: 'My Profile',
              icon: Icons.person_outline,
            ),
          ],
        ),
      ],
    );

    // AspectRatio image-like card on hero
    final heroVisual = AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0EA5E9), Color(0xFF4F46E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Icon(
            Icons.school_outlined,
            color: Colors.white,
            size: 64,
          ),
        ),
      ),
    );

    if (isRow) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 5, child: textContent),
          const SizedBox(width: 20),
          Expanded(flex: 4, child: heroVisual),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textContent,
        const SizedBox(height: 16),
        heroVisual,
      ],
    );
  }
}

/// Stats row — Flexible so it wraps gracefully on small screens
class _StatsRow extends StatelessWidget {
  final List<_StatItem> stats;
  final bool isTablet;

  const _StatsRow({
    required this.stats,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: stats
              .map(
                (s) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 14 : 10,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              s.value,
                              style: TextStyle(
                                fontSize: isTablet ? 22 : 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4F46E5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              s.label,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

/// Feature grid built with GridView.builder + LayoutBuilder
class _FeatureGrid extends StatelessWidget {
  final List<_FeatureItem> features;
  final int columns;
  final double bodyFontSize;

  const _FeatureGrid({
    required this.features,
    required this.columns,
    required this.bodyFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth =
            (constraints.maxWidth - (columns - 1) * 12) / columns;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: features.map((f) {
            return SizedBox(
              width: itemWidth,
              child: _FeatureCard(
                feature: f,
                bodyFontSize: bodyFontSize,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final _FeatureItem feature;
  final double bodyFontSize;

  const _FeatureCard({
    required this.feature,
    required this.bodyFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: feature.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(feature.icon, color: feature.color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            feature.label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: bodyFontSize,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            feature.description,
            style: TextStyle(
              fontSize: bodyFontSize - 1,
              color: const Color(0xFF64748B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Wrap chip demo — shows Wrap widget adapting to available width
class _WrapChipSection extends StatelessWidget {
  final double bodyFontSize;
  const _WrapChipSection({required this.bodyFontSize});

  static const _tags = [
    'MediaQuery',
    'LayoutBuilder',
    'Expanded',
    'Flexible',
    'FittedBox',
    'AspectRatio',
    'Wrap',
    'GridView',
    'Responsive',
    'Flutter',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Concepts Used',
          style: TextStyle(
            fontSize: bodyFontSize + 2,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _tags
              .map(
                (tag) => Chip(
                  label: Text(
                    tag,
                    style: TextStyle(
                      fontSize: bodyFontSize - 1,
                      color: const Color(0xFF4F46E5),
                    ),
                  ),
                  backgroundColor:
                      const Color(0xFF4F46E5).withValues(alpha: 0.1),
                  side: const BorderSide(
                    color: Color(0xFF4F46E5),
                    width: 0.5,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

/// AspectRatio card demo
class _AspectRatioCard extends StatelessWidget {
  final double titleFontSize;
  const _AspectRatioCard({required this.titleFontSize});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 21 / 9,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF0EA5E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'AspectRatio Widget',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'This container always maintains a 21:9 ratio, regardless of screen width.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const Icon(
              Icons.aspect_ratio_outlined,
              color: Colors.white,
              size: 48,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Action Buttons ─────────────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  const _PrimaryButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final IconData icon;
  const _OutlineButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF4F46E5),
        side: const BorderSide(color: Color(0xFF4F46E5)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// ── Data classes ───────────────────────────────────────────────────────────

class _FeatureItem {
  final IconData icon;
  final Color color;
  final String label;
  final String description;
  const _FeatureItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.description,
  });
}

class _StatItem {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});
}

class _FooterAction {
  final IconData icon;
  final String label;
  const _FooterAction({required this.icon, required this.label});
}
