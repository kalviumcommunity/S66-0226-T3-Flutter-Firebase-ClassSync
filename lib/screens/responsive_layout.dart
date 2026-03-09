import 'package:flutter/material.dart';

class ResponsiveLayoutScreen extends StatelessWidget {
  const ResponsiveLayoutScreen({super.key});

  static const double _tabletBreakpoint = 600.0;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final bool isTablet = screenWidth >= _tabletBreakpoint;

    final double hPadding = isTablet ? 32 : 16;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Responsive Layout',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Container · Row · Column · MediaQuery',
              style: TextStyle(fontSize: isTablet ? 12 : 10, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DeviceBanner(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              isTablet: isTablet,
              isLandscape: isLandscape,
            ),
            const SizedBox(height: 20),

            _SectionTitle(title: '1. Container'),
            const SizedBox(height: 10),
            _ContainerDemo(screenWidth: screenWidth, isTablet: isTablet),
            const SizedBox(height: 24),

            _SectionTitle(title: '2. Row — mainAxisAlignment'),
            const SizedBox(height: 10),
            const _RowDemo(),
            const SizedBox(height: 24),

            _SectionTitle(title: '3. Column — crossAxisAlignment'),
            const SizedBox(height: 10),
            const _ColumnDemo(),
            const SizedBox(height: 24),

            _SectionTitle(
              title: isTablet
                  ? '4. Tablet — two-column layout'
                  : isLandscape
                      ? '4. Landscape — side-by-side panels'
                      : '4. Phone — stacked layout',
            ),
            const SizedBox(height: 10),
            _CombinedLayout(isTablet: isTablet, isLandscape: isLandscape),
            const SizedBox(height: 24),

            _SectionTitle(title: '5. Expanded — proportional columns'),
            const SizedBox(height: 10),
            const _ExpandedDemo(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DeviceBanner extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final bool isTablet;
  final bool isLandscape;

  const _DeviceBanner({
    required this.screenWidth,
    required this.screenHeight,
    required this.isTablet,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4F46E5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isTablet
                ? Icons.tablet_mac_outlined
                : Icons.phone_android_outlined,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isTablet ? 'Tablet / Large Screen' : 'Phone',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${screenWidth.toInt()} × ${screenHeight.toInt()} dp  •  '
                  '${isLandscape ? 'Landscape' : 'Portrait'}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isTablet ? 'Tablet' : 'Phone',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
    );
  }
}

class _ContainerDemo extends StatelessWidget {
  final double screenWidth;
  final bool isTablet;

  const _ContainerDemo({required this.screenWidth, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final double containerWidth =
        screenWidth > 600 ? 500 : double.infinity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: containerWidth,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0EA5E9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Container — width ${screenWidth > 600 ? "capped at 500 dp (tablet)" : "fills screen (phone)"}',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(16),
                color: const Color(0xFFBAE6FD),
                child: const Text(
                  'margin: 8\npadding: 16',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF0C4A6E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.all(24),
                color: const Color(0xFFFED7AA),
                child: const Text(
                  'margin: 2\npadding: 24',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7C2D12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Center(
            child: Text(
              'Container with gradient + borderRadius',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}

class _RowDemo extends StatelessWidget {
  const _RowDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labelledRow(
          label: 'spaceEvenly',
          alignment: MainAxisAlignment.spaceEvenly,
          colors: [
            const Color(0xFF4F46E5),
            const Color(0xFF0EA5E9),
            const Color(0xFF10B981),
          ],
        ),
        const SizedBox(height: 8),

        _labelledRow(
          label: 'spaceBetween',
          alignment: MainAxisAlignment.spaceBetween,
          colors: [
            const Color(0xFFF59E0B),
            const Color(0xFFEF4444),
            const Color(0xFF8B5CF6),
          ],
        ),
        const SizedBox(height: 8),

        _labelledRow(
          label: 'center',
          alignment: MainAxisAlignment.center,
          colors: [
            const Color(0xFF0EA5E9),
            const Color(0xFF4F46E5),
          ],
        ),
      ],
    );
  }

  Widget _labelledRow({
    required String label,
    required MainAxisAlignment alignment,
    required List<Color> colors,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: alignment,
            children: colors
                .map(
                  (c) => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: c,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ColumnDemo extends StatelessWidget {
  const _ColumnDemo();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'start',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _pill('Text Widget', const Color(0xFF4F46E5)),
                const SizedBox(height: 6),
                _pill('SizedBox(h:8)', Colors.transparent,
                    textColor: const Color(0xFF94A3B8)),
                const SizedBox(height: 6),
                _pill('ElevatedButton', const Color(0xFF0EA5E9)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'end',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _pill('Welcome!', const Color(0xFF10B981)),
                const SizedBox(height: 6),
                _pill('SizedBox(h:10)', Colors.transparent,
                    textColor: const Color(0xFF94A3B8)),
                const SizedBox(height: 6),
                _pill('Click Me', const Color(0xFFF59E0B)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'center',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _pill('Header', const Color(0xFF8B5CF6)),
                const SizedBox(height: 6),
                _pill('Body', const Color(0xFFEF4444)),
                const SizedBox(height: 6),
                _pill('Footer', const Color(0xFF4F46E5)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _pill(String text, Color bg, {Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bg == Colors.transparent ? const Color(0xFFF1F5F9) : bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: textColor ?? Colors.white,
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _CombinedLayout extends StatelessWidget {
  final bool isTablet;
  final bool isLandscape;

  const _CombinedLayout({required this.isTablet, required this.isLandscape});

  @override
  Widget build(BuildContext context) {
    const header = _HeaderPanel();
    const leftPanel = _SidePanel(
      label: 'Left Panel',
      color: Color(0xFFFEF3C7),
      borderColor: Color(0xFFF59E0B),
      textColor: Color(0xFF92400E),
      icon: Icons.menu_book_outlined,
    );
    const rightPanel = _SidePanel(
      label: 'Right Panel',
      color: Color(0xFFD1FAE5),
      borderColor: Color(0xFF10B981),
      textColor: Color(0xFF065F46),
      icon: Icons.assignment_outlined,
    );

    if (isTablet || isLandscape) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: leftPanel),
              const SizedBox(width: 10),
              const Expanded(child: rightPanel),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        const SizedBox(height: 10),
        leftPanel,
        const SizedBox(height: 10),
        rightPanel,
      ],
    );
  }
}

class _HeaderPanel extends StatelessWidget {
  const _HeaderPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8B5CF6)),
      ),
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.web_outlined, color: Color(0xFF6D28D9)),
            SizedBox(width: 8),
            Text(
              'Header Section',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF4C1D95),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidePanel extends StatelessWidget {
  final String label;
  final Color color;
  final Color borderColor;
  final Color textColor;
  final IconData icon;

  const _SidePanel({
    required this.label,
    required this.color,
    required this.borderColor,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandedDemo extends StatelessWidget {
  const _ExpandedDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FlexRow(
          flexValues: const [1, 2, 1],
          colors: const [Color(0xFF4F46E5), Color(0xFF0EA5E9), Color(0xFF10B981)],
          labels: const ['1x', '2x', '1x'],
        ),
        const SizedBox(height: 8),
        _FlexRow(
          flexValues: const [1, 1, 1],
          colors: const [Color(0xFFF59E0B), Color(0xFFEF4444), Color(0xFF8B5CF6)],
          labels: const ['1x', '1x', '1x'],
        ),
        const SizedBox(height: 8),
        _FlexRow(
          flexValues: const [3, 1],
          colors: const [Color(0xFF0EA5E9), Color(0xFF4F46E5)],
          labels: const ['3x', '1x'],
        ),
      ],
    );
  }
}

class _FlexRow extends StatelessWidget {
  final List<int> flexValues;
  final List<Color> colors;
  final List<String> labels;

  const _FlexRow({
    required this.flexValues,
    required this.colors,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 44,
        child: Row(
          children: List.generate(flexValues.length, (i) {
            return Expanded(
              flex: flexValues[i],
              child: Container(
                color: colors[i],
                alignment: Alignment.center,
                child: Text(
                  labels[i],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
