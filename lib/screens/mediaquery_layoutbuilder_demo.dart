import 'package:flutter/material.dart';

class MediaQueryLayoutBuilderDemo extends StatelessWidget {
  const MediaQueryLayoutBuilderDemo({super.key});

  static const double _tabletBreakpoint = 600;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;
    final isPortrait = media.orientation == Orientation.portrait;

    final horizontalPadding = screenWidth < _tabletBreakpoint ? 16.0 : 28.0;
    final titleSize = screenWidth < _tabletBreakpoint ? 18.0 : 24.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Responsive Design Demo')),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 16,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= _tabletBreakpoint;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DeviceHeader(
                  width: screenWidth,
                  height: screenHeight,
                  isPortrait: isPortrait,
                  isTablet: isTablet,
                ),
                const SizedBox(height: 16),
                Text(
                  isTablet ? 'Tablet Layout' : 'Mobile Layout',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontSize: titleSize),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: isTablet
                      ? _TabletPanels(maxWidth: constraints.maxWidth)
                      : _MobilePanels(maxWidth: constraints.maxWidth),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DeviceHeader extends StatelessWidget {
  final double width;
  final double height;
  final bool isPortrait;
  final bool isTablet;

  const _DeviceHeader({
    required this.width,
    required this.height,
    required this.isPortrait,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F766E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            isTablet ? Icons.tablet_mac_outlined : Icons.phone_android_outlined,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${width.toInt()} x ${height.toInt()} • ${isPortrait ? 'Portrait' : 'Landscape'}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

class _MobilePanels extends StatelessWidget {
  final double maxWidth;

  const _MobilePanels({required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _AdaptivePanel(
          width: maxWidth * 0.9,
          height: 110,
          title: 'Mobile Primary Panel',
          color: const Color(0xFFE0F2FE),
        ),
        const SizedBox(height: 12),
        _AdaptivePanel(
          width: maxWidth * 0.9,
          height: 110,
          title: 'Mobile Secondary Panel',
          color: const Color(0xFFDCFCE7),
        ),
      ],
    );
  }
}

class _TabletPanels extends StatelessWidget {
  final double maxWidth;

  const _TabletPanels({required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _AdaptivePanel(
          width: maxWidth * 0.46,
          height: 180,
          title: 'Tablet Left Panel',
          color: const Color(0xFFFEF3C7),
        ),
        _AdaptivePanel(
          width: maxWidth * 0.46,
          height: 180,
          title: 'Tablet Right Panel',
          color: const Color(0xFFE9D5FF),
        ),
      ],
    );
  }
}

class _AdaptivePanel extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final Color color;

  const _AdaptivePanel({
    required this.width,
    required this.height,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
