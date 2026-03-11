import 'package:flutter/material.dart';

class ScrollableViewsScreen extends StatelessWidget {
  const ScrollableViewsScreen({super.key});

  static const List<_ClassCardData> _classrooms = [
    _ClassCardData(
      title: 'UI Design Fundamentals',
      mentor: 'Ms. Aina',
      schedule: 'Mon · 9:00 AM',
      icon: Icons.palette_outlined,
      color: Color(0xFF0F766E),
    ),
    _ClassCardData(
      title: 'Firebase Essentials',
      mentor: 'Mr. Daniel',
      schedule: 'Tue · 2:00 PM',
      icon: Icons.cloud_done_outlined,
      color: Color(0xFF2563EB),
    ),
    _ClassCardData(
      title: 'Mobile Architecture',
      mentor: 'Dr. Faris',
      schedule: 'Wed · 11:30 AM',
      icon: Icons.account_tree_outlined,
      color: Color(0xFF7C3AED),
    ),
    _ClassCardData(
      title: 'Testing Lab',
      mentor: 'Ms. Syaza',
      schedule: 'Thu · 4:15 PM',
      icon: Icons.science_outlined,
      color: Color(0xFFDC2626),
    ),
    _ClassCardData(
      title: 'Dart Patterns',
      mentor: 'Mr. Haziq',
      schedule: 'Fri · 10:00 AM',
      icon: Icons.code_outlined,
      color: Color(0xFFF59E0B),
    ),
  ];

  static const List<_ResourceTileData> _resources = [
    _ResourceTileData(
      label: 'Assignments',
      detail: '12 active tasks',
      icon: Icons.assignment_outlined,
      color: Color(0xFF1D4ED8),
    ),
    _ResourceTileData(
      label: 'Notes',
      detail: '24 synced files',
      icon: Icons.menu_book_outlined,
      color: Color(0xFF0F766E),
    ),
    _ResourceTileData(
      label: 'Attendance',
      detail: '98% this month',
      icon: Icons.fact_check_outlined,
      color: Color(0xFF7C3AED),
    ),
    _ResourceTileData(
      label: 'Announcements',
      detail: '3 new updates',
      icon: Icons.campaign_outlined,
      color: Color(0xFFC2410C),
    ),
    _ResourceTileData(
      label: 'Files',
      detail: '8 uploads today',
      icon: Icons.folder_open_outlined,
      color: Color(0xFFBE185D),
    ),
    _ResourceTileData(
      label: 'Progress',
      detail: '4 goals tracked',
      icon: Icons.trending_up_outlined,
      color: Color(0xFF15803D),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12355B),
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Scrollable Views',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'ListView + GridView in one responsive lesson',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF12355B), Color(0xFF1D4ED8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.view_carousel_outlined),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'ClassSync dashboard widgets often need mixed scrolling patterns.',
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This lesson uses a horizontal ListView for upcoming classes and a GridView for quick-access study modules.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: colorScheme.onPrimary.withValues(alpha: 0.88),
                    ),
                  ),
                ],
              ),
            ),
            const _SectionTitle(
              eyebrow: 'ListView.builder',
              title: 'Upcoming Classes',
              description:
                  'A horizontal list is useful for cards, feeds, or schedules without rendering everything upfront.',
            ),
            SizedBox(
              height: 228,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _classrooms.length,
                itemBuilder: (context, index) {
                  final classroom = _classrooms[index];
                  return Container(
                    width: 240,
                    margin: const EdgeInsets.only(right: 14, bottom: 8),
                    decoration: BoxDecoration(
                      color: classroom.color,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: classroom.color.withValues(alpha: 0.28),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              classroom.icon,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            classroom.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            classroom.mentor,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule_outlined,
                                color: Colors.white70,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                classroom.schedule,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 32, indent: 16, endIndent: 16),
            const _SectionTitle(
              eyebrow: 'GridView.builder',
              title: 'Study Resources',
              description:
                  'A grid works well for dashboards, galleries, modules, and shortcut panels with evenly sized items.',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final crossAxisCount = width >= 900
                      ? 3
                      : width >= 600
                      ? 2
                      : 2;
                  final childAspectRatio = width >= 900 ? 1.35 : 1.12;

                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _resources.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final resource = _resources[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFD7E2F0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: resource.color.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  resource.icon,
                                  color: resource.color,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                resource.label,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF102A43),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                resource.detail,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF486581),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFD7E2F0)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why builder constructors matter',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ListView.builder and GridView.builder only build visible items. That keeps scrolling smooth and avoids loading every card or tile into memory at once.',
                    style: TextStyle(fontSize: 13, height: 1.5),
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

class _SectionTitle extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String description;

  const _SectionTitle({
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: const TextStyle(
              fontSize: 12,
              letterSpacing: 1.2,
              color: Color(0xFF486581),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF102A43),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF486581),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassCardData {
  final String title;
  final String mentor;
  final String schedule;
  final IconData icon;
  final Color color;

  const _ClassCardData({
    required this.title,
    required this.mentor,
    required this.schedule,
    required this.icon,
    required this.color,
  });
}

class _ResourceTileData {
  final String label;
  final String detail;
  final IconData icon;
  final Color color;

  const _ResourceTileData({
    required this.label,
    required this.detail,
    required this.icon,
    required this.color,
  });
}
