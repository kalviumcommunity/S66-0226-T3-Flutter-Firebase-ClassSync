import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AssetsDemoScreen extends StatelessWidget {
  const AssetsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Assets Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: width < 600 ? 170 : 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.45),
                    ],
                  ),
                ),
                child: const Text(
                  'Managing Images, Icons, and Local Assets',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 82,
                      height: 82,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Text(
                        'Local image loaded via Image.asset from assets/images/logo.png',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Image.asset('assets/icons/star.png', width: 38),
                        const SizedBox(height: 6),
                        const Text('Local Icon'),
                      ],
                    ),
                    const Column(
                      children: [
                        Icon(Icons.flutter_dash, color: Colors.blue, size: 40),
                        SizedBox(height: 6),
                        Text('Material'),
                      ],
                    ),
                    const Column(
                      children: [
                        Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.red,
                          size: 38,
                        ),
                        SizedBox(height: 6),
                        Text('Cupertino'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/banner.png',
                height: width < 600 ? 150 : 220,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
