import 'package:flutter/material.dart';
import '../widgets/like_toggle_button.dart';
import '../widgets/reusable_info_card.dart';

class CustomWidgetsDetailsScreen extends StatelessWidget {
  const CustomWidgetsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reusable Widgets - Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ReusableInfoCard(
            title: 'Announcements',
            subtitle: 'School updates and reminders are grouped in one place.',
            icon: Icons.campaign_outlined,
            accent: Color(0xFF7C3AED),
            trailing: LikeToggleButton(),
          ),
          SizedBox(height: 10),
          ReusableInfoCard(
            title: 'Submissions',
            subtitle: 'Track assignment status with clean, reusable tiles.',
            icon: Icons.assignment_turned_in_outlined,
            accent: Color(0xFF0EA5E9),
            trailing: LikeToggleButton(),
          ),
          SizedBox(height: 10),
          ReusableInfoCard(
            title: 'Chat Support',
            subtitle: 'Reach mentors quickly when you need guidance.',
            icon: Icons.support_agent_outlined,
            accent: Color(0xFF059669),
            trailing: LikeToggleButton(),
          ),
        ],
      ),
    );
  }
}
