import 'package:flutter/material.dart';
import 'custom_widgets_details_screen.dart';
import '../widgets/like_toggle_button.dart';
import '../widgets/reusable_info_card.dart';

class CustomWidgetsDemoScreen extends StatelessWidget {
  const CustomWidgetsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reusable Custom Widgets')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'The same reusable widgets are used here and in the details screen.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          const ReusableInfoCard(
            title: 'Profile',
            subtitle: 'View your account details and learning preferences.',
            icon: Icons.person_outline,
            accent: Color(0xFF0F766E),
            trailing: LikeToggleButton(),
          ),
          const SizedBox(height: 10),
          const ReusableInfoCard(
            title: 'Assignments',
            subtitle:
                'Check due dates and submissions with one consistent tile.',
            icon: Icons.assignment_outlined,
            accent: Color(0xFF1D4ED8),
            trailing: LikeToggleButton(),
          ),
          const SizedBox(height: 10),
          const ReusableInfoCard(
            title: 'Attendance',
            subtitle: 'Monitor attendance trend using shared card UI.',
            icon: Icons.fact_check_outlined,
            accent: Color(0xFFF59E0B),
            trailing: LikeToggleButton(),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CustomWidgetsDetailsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open Details Screen (Reused Widgets)'),
          ),
        ],
      ),
    );
  }
}
