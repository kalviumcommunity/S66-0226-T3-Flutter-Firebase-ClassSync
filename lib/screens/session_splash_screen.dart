import 'package:flutter/material.dart';

class SessionSplashScreen extends StatelessWidget {
  const SessionSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEEF2FF), Color(0xFFDDE7FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFF4F46E5)),
              SizedBox(height: 16),
              Text(
                'Checking saved session...',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
