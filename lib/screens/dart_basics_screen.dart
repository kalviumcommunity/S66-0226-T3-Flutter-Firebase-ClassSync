import 'package:flutter/material.dart';
import '../models/student.dart';

class DartBasicsScreen extends StatefulWidget {
  const DartBasicsScreen({super.key});

  @override
  State<DartBasicsScreen> createState() => _DartBasicsScreenState();
}

class _DartBasicsScreenState extends State<DartBasicsScreen> {
  final students = [
    Student('Aanya', 20, subject: 'Mathematics'),
    Student('Rohan', 22, subject: 'Physics'),
    Student('Priya', 21), // subject is null — shows null safety
  ];

  String _asyncResult = 'Tap "Fetch Profile" to simulate async Firebase call';
  bool _isLoading = false;
  int _selectedIndex = 0;

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _asyncResult = 'Fetching…';
    });

    final result = await students[_selectedIndex].fetchProfile();

    setState(() {
      _asyncResult = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Dart Basics',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Classes · Null Safety · Async · Type Inference',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(title: '1. Classes & Objects', color: Colors.orange),
            const SizedBox(height: 8),
            _ConceptBox(
              code:
                  'class Student {\n'
                  '  final String name;  // non-nullable\n'
                  '  final int age;\n'
                  '  String? subject;    // nullable\n\n'
                  '  Student(this.name, this.age, {this.subject});\n\n'
                  '  String introduce() =>\n'
                  '    "Hi, I\'m \$name and I\'m \$age years old.";\n'
                  '}',
              explanation:
                  'Dart classes use concise constructor shorthand (this.name). '
                  'Every value is an object — even int and String.',
            ),
            const SizedBox(height: 16),

            const Text(
              'Live Student Objects:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            ...students.asMap().entries.map(
              (e) => _StudentTile(
                student: e.value,
                isSelected: _selectedIndex == e.key,
                onTap: () => setState(() => _selectedIndex = e.key),
              ),
            ),
            const SizedBox(height: 24),

            _SectionHeader(title: '2. Null Safety', color: Colors.red.shade400),
            const SizedBox(height: 8),
            _ConceptBox(
              code:
                  'String? subject;          // nullable\n'
                  'String currentSubject() {\n'
                  '  return subject ?? "No subject assigned";\n'
                  '}',
              explanation:
                  'Dart null safety makes null errors compile-time, not runtime. '
                  'The ?? operator provides a fallback when a value is null. '
                  'Notice Priya has no subject — null safety handles it gracefully.',
            ),
            const SizedBox(height: 24),

            _SectionHeader(
              title: '3. Type Inference',
              color: Colors.purple.shade400,
            ),
            const SizedBox(height: 8),
            _ConceptBox(
              code:
                  '// Dart infers the type — no explicit type needed\n'
                  'var name = "Aanya";        // inferred: String\n'
                  'final age = 20;            // inferred: int\n'
                  'var students = [...];      // inferred: List<Student>',
              explanation:
                  'Dart is strongly typed but uses inference to keep code '
                  'clean. var/final let you skip explicit annotations without '
                  'losing type safety.',
            ),
            const SizedBox(height: 24),

            _SectionHeader(
              title: '4. Async / Await',
              color: Colors.green.shade600,
            ),
            const SizedBox(height: 8),
            _ConceptBox(
              code:
                  'Future<String> fetchProfile() async {\n'
                  '  await Future.delayed(Duration(seconds: 1));\n'
                  '  return "Profile loaded for \$name";\n'
                  '}',
              explanation:
                  'async/await makes asynchronous code look synchronous. '
                  'This same pattern is used when fetching documents from Firestore: '
                  'await firestore.collection("students").doc(id).get()',
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected: ${students[_selectedIndex].name}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _asyncResult,
                    style: TextStyle(
                      fontSize: 14,
                      color: _isLoading
                          ? Colors.grey.shade500
                          : Colors.green.shade800,
                      fontStyle: _isLoading
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _isLoading ? null : _fetchProfile,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.cloud_download_outlined),
                    label: Text(_isLoading ? 'Loading…' : 'Fetch Profile'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(color: color,borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ConceptBox extends StatelessWidget {
  final String code;
  final String explanation;

  const _ConceptBox({required this.code, required this.explanation});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2E),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Text(
            code,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: Color(0xFFCDD6F4),
              height: 1.6,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            explanation,
            style: const TextStyle(fontSize: 13, height: 1.5),
          ),
        ),
      ],
    );
  }
}

class _StudentTile extends StatelessWidget {
  final Student student;
  final bool isSelected;
  final VoidCallback onTap;

  const _StudentTile({
    required this.student,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.orange.withValues(alpha: 0.12)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.orange.withValues(alpha: 0.2),
              child: Text(
                student.name[0],
                style: const TextStyle(
                  color: Colors.orange,
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
                    student.introduce(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Subject: ${student.currentSubject()}',
                    style: TextStyle(
                      fontSize: 12,
                      color: student.subject == null
                          ? Colors.red.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.orange, size: 20),
          ],
        ),
      ),
    );
  }
}
