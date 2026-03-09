import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final _service = FirestoreService();
  final _taskCtrl = TextEditingController();
  bool _adding = false;
  late Future<DocumentSnapshot?> _latestTaskFuture;

  @override
  void initState() {
    super.initState();
    _latestTaskFuture = _service.getLatestTaskDocument();
  }

  void _reloadLatestTaskFuture() {
    setState(() {
      _latestTaskFuture = _service.getLatestTaskDocument();
    });
  }

  @override
  void dispose() {
    _taskCtrl.dispose();
    super.dispose();
  }

  Future<void> _addTask() async {
    final title = _taskCtrl.text.trim();
    if (title.isEmpty) return;
    setState(() => _adding = true);
    await _service.addTask(title);
    _taskCtrl.clear();
    if (mounted) {
      setState(() => _adding = false);
      _reloadLatestTaskFuture();
    }
  }

  Future<void> _showEditDialog(String id, String currentTitle) async {
    final ctrl = TextEditingController(text: currentTitle);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Task title',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (newTitle != null && newTitle.isNotEmpty && newTitle != currentTitle) {
      await _service.updateTask(id, newTitle);
      _reloadLatestTaskFuture();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Firestore Real-Time',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Live data sync — no refresh needed',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                _PulseDot(),
                const SizedBox(width: 4),
                const Text(
                  'LIVE',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.sync, color: Colors.blue.shade700),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Firestore streams push updates to ALL connected clients '
                    'instantly. Open this screen on two devices — add a task '
                    'on one and watch it appear on the other without refreshing.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue.shade900,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskCtrl,
                    decoration: InputDecoration(
                      hintText: 'Type a task and tap Add…',
                      prefixIcon: const Icon(Icons.task_alt_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    onPressed: _adding ? null : _addTask,
                    child: _adding
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _CodeBlock(
              code:
                  'StreamBuilder<QuerySnapshot>(\n'
                  '  stream: tasks.snapshots(), // real-time!\n'
                  '  builder: (ctx, snapshot) {\n'
                  '    final docs = snapshot.data!.docs;\n'
                  '    return ListView(children:\n'
                  '      docs.map((d) => Text(d[\'title\'])).toList()\n'
                  '    );\n'
                  '  },\n'
                  ')',
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: StreamBuilder<QuerySnapshot>(
              stream: _service.getPendingTasks(),
              builder: (context, snapshot) {
                final pendingCount = snapshot.data?.docs.length ?? 0;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Text(
                    'Pending tasks (filtered read): $pendingCount',
                    style: TextStyle(
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FutureBuilder<DocumentSnapshot?>(
              future: _latestTaskFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text('Could not read latest task document.');
                }
                final doc = snapshot.data;
                if (doc == null || !doc.exists) {
                  return const Text('Latest task (one-time read): no data');
                }
                final data = doc.data() as Map<String, dynamic>?;
                final title = data?['title'] as String? ?? 'Untitled task';
                final completed = data?['completed'] as bool? ?? false;
                return Text(
                  'Latest task (one-time document read): $title | completed: $completed',
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tasks (synced in real time)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),

          const SizedBox(height: 6),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _service.getTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return _ErrorWidget(message: snapshot.error.toString());
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No tasks yet. Add one above!',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: docs.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data()! as Map<String, dynamic>;
                    final title = data['title'] as String? ?? '';
                    final completed = data['completed'] as bool? ?? false;
                    final ts = data['createdAt'] as Timestamp?;
                    final time = ts != null ? _formatTime(ts.toDate()) : '';

                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: () async {
                            await _service.toggleTask(doc.id, completed);
                            _reloadLatestTaskFuture();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: completed
                                  ? Colors.blue.shade600
                                  : Colors.transparent,
                              border: Border.all(
                                color: completed
                                    ? Colors.blue.shade600
                                    : Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                            child: completed
                                ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            decoration: completed
                                ? TextDecoration.lineThrough
                                : null,
                            color: completed
                                ? Colors.grey.shade500
                                : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          time,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit_outlined,
                                color: Colors.blue.shade300,
                                size: 20,
                              ),
                              tooltip: 'Edit',
                              onPressed: () => _showEditDialog(doc.id, title),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red.shade300,
                                size: 20,
                              ),
                              tooltip: 'Delete',
                              onPressed: () async {
                                await _service.deleteTask(doc.id);
                                _reloadLatestTaskFuture();
                              },
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
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day}/${dt.month}/${dt.year} $hour:$min';
  }
}


class _PulseDot extends StatefulWidget {
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _anim = Tween(begin: 0.5, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.greenAccent,
        ),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;
  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: Color(0xFFCDD6F4),
          height: 1.6,
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  const _ErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'Firebase not configured yet',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Run "flutterfire configure" to connect to a real Firebase project.\n\n$message',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
