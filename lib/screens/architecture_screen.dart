import 'package:flutter/material.dart';

/// ArchitectureScreen — StatelessWidget explaining Flutter's 3 core layers.
class ArchitectureScreen extends StatelessWidget {
  const ArchitectureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Flutter Architecture',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Text('Framework · Engine · Embedder',
                style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Key Idea ───────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade50, Colors.indigo.shade100],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.indigo),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Key Idea: Flutter does NOT use native UI components. '
                      'It renders every pixel itself via the Skia/Impeller engine, '
                      'ensuring pixel-perfect design consistency across Android & iOS.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.indigo.shade800,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Core Layers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // ── Layer cards ────────────────────────────────────────────
            _LayerCard(
              number: '1',
              name: 'Framework Layer',
              language: 'Written in Dart',
              color: Colors.indigo,
              icon: Icons.auto_awesome_mosaic_outlined,
              description:
                  'The layer you interact with every day. Contains:\n'
                  '• Material & Cupertino widgets\n'
                  '• Layout, painting, and gesture system\n'
                  '• Animation and routing libraries\n'
                  '• State management primitives (StatefulWidget)',
            ),

            const SizedBox(height: 12),

            _LayerCard(
              number: '2',
              name: 'Engine Layer',
              language: 'Built in C++',
              color: Colors.blue,
              icon: Icons.settings_outlined,
              description:
                  'The rendering powerhouse. Handles:\n'
                  '• Skia / Impeller graphics rendering\n'
                  '• Text layout and font rendering\n'
                  '• Platform channels (Dart ↔ Native)\n'
                  '• Dart runtime and garbage collection',
            ),

            const SizedBox(height: 12),

            _LayerCard(
              number: '3',
              name: 'Embedder Layer',
              language: 'Platform-specific (Java/Kotlin, Swift/ObjC)',
              color: Colors.teal,
              icon: Icons.devices_outlined,
              description:
                  'Bridges Flutter with the host OS. Responsible for:\n'
                  '• Creating and managing a surface to render on\n'
                  '• Forwarding input events (touch, keyboard)\n'
                  '• Integrating with Android / iOS / Web / Desktop APIs\n'
                  '• Lifecycle management of the Flutter engine',
            ),

            const SizedBox(height: 24),

            // ── Widget Tree section ────────────────────────────────────
            const Text(
              'Widget Tree',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'In Flutter, EVERYTHING is a widget — text, buttons, '
                    'layout containers, padding, even the app itself.',
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  _WidgetRow(
                    label: 'MaterialApp',
                    depth: 0,
                    color: Colors.indigo,
                  ),
                  _WidgetRow(
                    label: 'Scaffold',
                    depth: 1,
                    color: Colors.blue,
                  ),
                  _WidgetRow(
                    label: 'AppBar → Text("Hello")',
                    depth: 2,
                    color: Colors.teal,
                  ),
                  _WidgetRow(
                    label: 'Body → Center → Text("Welcome")',
                    depth: 2,
                    color: Colors.green,
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

class _LayerCard extends StatelessWidget {
  final String number;
  final String name;
  final String language;
  final Color color;
  final IconData icon;
  final String description;

  const _LayerCard({
    required this.number,
    required this.name,
    required this.language,
    required this.color,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  radius: 18,
                  child: Text(
                    number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        language,
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(icon, color: color.withValues(alpha: 0.5)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(fontSize: 14, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _WidgetRow extends StatelessWidget {
  final String label;
  final int depth;
  final Color color;

  const _WidgetRow({
    required this.label,
    required this.depth,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: depth * 20.0, bottom: 8),
      child: Row(
        children: [
          if (depth > 0)
            Text(
              '└─ ',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
