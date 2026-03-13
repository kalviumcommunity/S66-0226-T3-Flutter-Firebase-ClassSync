import 'dart:async';
import 'dart:developer';

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
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  TextEditingController? _limitCtrl;
  bool _adding = false;
  DateTime? _selectedDeadline;
  String? _selectedTaskId;
  String _lastChangeMessage = 'Waiting for live changes...';
  bool _onlyPending = false;
  bool _newestFirst = true;
  int _resultLimit = 10;
  StreamSubscription<QuerySnapshot>? _taskChangesSub;
  late Future<DocumentSnapshot?> _latestTaskFuture;

  @override
  void initState() {
    super.initState();
    _limitCtrl = TextEditingController(text: _resultLimit.toString());
    _latestTaskFuture = _service.getLatestTaskDocument();
    _taskChangesSub = _service.getTasks().listen((snapshot) {
      if (!mounted || snapshot.docChanges.isEmpty) return;
      final change = snapshot.docChanges.first;
      final title =
          (change.doc.data() as Map<String, dynamic>?)?['title'] ?? 'task';
      final label = switch (change.type) {
        DocumentChangeType.added => 'Added',
        DocumentChangeType.modified => 'Updated',
        DocumentChangeType.removed => 'Removed',
      };
      setState(() {
        _lastChangeMessage = '$label: $title';
      });
    });
  }

  void _reloadLatestTaskFuture() {
    setState(() {
      _latestTaskFuture = _service.getLatestTaskDocument();
    });
  }

  @override
  void dispose() {
    _taskChangesSub?.cancel();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _limitCtrl?.dispose();
    super.dispose();
  }

  TextEditingController get _limitController {
    return _limitCtrl ??= TextEditingController(text: _resultLimit.toString());
  }

  void _applyLimitInput() {
    final parsed = int.tryParse(_limitController.text.trim());
    if (parsed == null || parsed <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid limit (1 or more)')),
      );
      return;
    }
    setState(() => _resultLimit = parsed);
  }

  Future<void> _addTask() async {
    final title = _titleCtrl.text.trim();
    final description = _descCtrl.text.trim();
    if (title.isEmpty || description.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => _adding = true);
    try {
      await _service.addTask(
        title: title,
        description: description,
        deadline: _selectedDeadline,
      );
      _titleCtrl.clear();
      _descCtrl.clear();
      _selectedDeadline = null;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added successfully')),
        );
      }
    } catch (e, st) {
      log('Failed to add task', error: e, stackTrace: st);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not add task right now')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _adding = false);
        _reloadLatestTaskFuture();
      }
    }
  }

  Future<void> _showEditDialog(
    String id,
    String currentTitle,
    String currentDescription,
    Timestamp? currentDueAt,
  ) async {
    final titleCtrl = TextEditingController(text: currentTitle);
    final descCtrl = TextEditingController(text: currentDescription);
    DateTime? draftDeadline = currentDueAt?.toDate();
    final updated = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Task title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      draftDeadline == null
                          ? 'No deadline'
                          : 'Deadline: ${_formatDateTime(draftDeadline!)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await _pickDateTime(
                        initial: draftDeadline,
                      );
                      if (picked != null) {
                        setDialogState(() => draftDeadline = picked);
                      }
                    },
                    child: const Text('Pick date & time'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, {
                'title': titleCtrl.text.trim(),
                'description': descCtrl.text.trim(),
                'deadline': draftDeadline,
              }),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    titleCtrl.dispose();
    descCtrl.dispose();

    if (updated == null) return;
    final newTitle = updated['title'] as String? ?? '';
    final newDescription = updated['description'] as String? ?? '';
    final newDeadline = updated['deadline'] as DateTime?;
    if (newTitle.isEmpty || newDescription.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and description are required')),
      );
      return;
    }
    if (newTitle == currentTitle && newDescription == currentDescription) {
      return;
    }

    try {
      await _service.updateTask(
        id,
        title: newTitle,
        description: newDescription,
        deadline: newDeadline,
      );
      _reloadLatestTaskFuture();
    } catch (e, st) {
      log('Failed to update task', error: e, stackTrace: st);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update task right now')),
        );
      }
    }
  }

  Future<void> _mergeLatestTaskMetadata() async {
    final latest = await _service.getLatestTaskDocument();
    if (latest == null || !latest.exists) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No task found to merge metadata')),
      );
      return;
    }
    try {
      await _service.mergeTaskFields(latest.id, {
        'lastWriteMode': 'set-merge',
        'updatedAt': Timestamp.now(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Set merge write applied to latest task'),
          ),
        );
      }
      _reloadLatestTaskFuture();
    } catch (e, st) {
      log('Failed to merge task metadata', error: e, stackTrace: st);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Set merge write failed')));
      }
    }
  }

  Future<void> _pickCreateDeadline() async {
    final picked = await _pickDateTime(initial: _selectedDeadline);
    if (picked != null) {
      setState(() => _selectedDeadline = picked);
    }
  }

  Future<DateTime?> _pickDateTime({DateTime? initial}) async {
    final now = DateTime.now();
    final initialDate = initial ?? now;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return null;
    if (!mounted) return null;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    if (pickedTime == null) {
      return DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        initialDate.hour,
        initialDate.minute,
      );
    }

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
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
          IconButton(
            onPressed: _mergeLatestTaskMetadata,
            tooltip: 'Set merge write',
            icon: const Icon(Icons.merge_type),
          ),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _service.queryTasks(
          onlyPending: _onlyPending,
          newestFirst: _newestFirst,
          limit: _resultLimit,
        ),
        builder: (context, snapshot) {
          final docs = (snapshot.data?.docs ?? []).toList();
          if (_onlyPending) {
            docs.sort((a, b) {
              final aTs =
                  (a.data()! as Map<String, dynamic>)['createdAt']
                      as Timestamp?;
              final bTs =
                  (b.data()! as Map<String, dynamic>)['createdAt']
                      as Timestamp?;
              final aMs = aTs?.millisecondsSinceEpoch ?? 0;
              final bMs = bTs?.millisecondsSinceEpoch ?? 0;
              return _newestFirst ? bMs.compareTo(aMs) : aMs.compareTo(bMs);
            });
            if (docs.length > _resultLimit) {
              docs.removeRange(_resultLimit, docs.length);
            }
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: 16),
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
                child: Column(
                  children: [
                    TextField(
                      controller: _titleCtrl,
                      decoration: InputDecoration(
                        hintText: 'Task title',
                        prefixIcon: const Icon(Icons.task_alt_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _descCtrl,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Task description',
                        prefixIcon: const Icon(Icons.description_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDeadline == null
                                ? 'No deadline selected'
                                : 'Deadline: ${_formatDateTime(_selectedDeadline!)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        TextButton(
                          onPressed: _pickCreateDeadline,
                          child: const Text('Pick date & time'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _adding ? null : _addTask,
                        icon: _adding
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.add),
                        label: Text(_adding ? 'Saving...' : 'Add Task'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.indigo.shade200),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(child: Text('Only pending tasks')),
                          Switch(
                            value: _onlyPending,
                            onChanged: (value) {
                              setState(() => _onlyPending = value);
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text('Sort by createdAt')),
                          DropdownButton<bool>(
                            value: _newestFirst,
                            items: const [
                              DropdownMenuItem(
                                value: true,
                                child: Text('Newest first'),
                              ),
                              DropdownMenuItem(
                                value: false,
                                child: Text('Oldest first'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() => _newestFirst = value);
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text('Limit results')),
                          SizedBox(
                            width: 96,
                            child: TextField(
                              controller: _limitController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                isDense: true,
                                hintText: 'e.g. 10',
                              ),
                              onSubmitted: (_) => _applyLimitInput(),
                            ),
                          ),
                          IconButton(
                            onPressed: _applyLimitInput,
                            icon: const Icon(Icons.check),
                            tooltip: 'Apply limit',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal.shade200),
                  ),
                  child: Text(
                    'Live activity: $_lastChangeMessage',
                    style: TextStyle(
                      color: Colors.teal.shade900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _selectedTaskId == null
                    ? const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Tap a task to view live document updates.',
                        ),
                      )
                    : StreamBuilder<DocumentSnapshot>(
                        stream: _service.watchTaskDocument(_selectedTaskId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const _InlineLoadingState(
                              message: 'Listening for document changes...',
                            );
                          }
                          if (snapshot.hasError) {
                            return _InlineErrorState(
                              title: 'Unable to load selected task',
                              message:
                                  'We could not fetch live document updates right now.',
                              onRetry: () => setState(() {}),
                            );
                          }
                          final data =
                              snapshot.data?.data() as Map<String, dynamic>?;
                          if (data == null) {
                            return const _InlineEmptyState(
                              message: 'Selected task document not found.',
                            );
                          }
                          final liveTitle =
                              data['title'] as String? ?? 'Untitled';
                          final liveDone = data['completed'] as bool? ?? false;
                          return Text(
                            'Live document: $liveTitle | completed: $liveDone',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _service.getPendingTasks(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const _InlineLoadingState(
                        message: 'Loading pending task count...',
                      );
                    }
                    if (snapshot.hasError) {
                      return _InlineErrorState(
                        title: 'Pending tasks unavailable',
                        message:
                            'Could not read pending tasks count. Please try again.',
                        onRetry: () => setState(() {}),
                      );
                    }
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
                      return const _InlineLoadingState(
                        message: 'Loading latest task...',
                      );
                    }
                    if (snapshot.hasError) {
                      return _InlineErrorState(
                        title: 'Latest task unavailable',
                        message:
                            'Could not read latest task document right now.',
                        onRetry: _reloadLatestTaskFuture,
                      );
                    }
                    final doc = snapshot.data;
                    if (doc == null || !doc.exists) {
                      return const _InlineEmptyState(
                        message: 'Latest task (one-time read): no data yet.',
                      );
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
              if (snapshot.connectionState == ConnectionState.waiting)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: _LoadingState(
                    message: 'Fetching tasks from Firestore...',
                  ),
                )
              else if (snapshot.hasError)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _ErrorWidget(
                    message: snapshot.error.toString(),
                    onRetry: () => setState(() {}),
                  ),
                )
              else if (docs.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: _EmptyState(
                    title: 'No tasks yet',
                    message: 'Tap Add Task above to create your first item.',
                  ),
                )
              else
                ...docs.map((doc) {
                  final data = doc.data()! as Map<String, dynamic>;
                  final title = data['title'] as String? ?? '';
                  final completed = data['completed'] as bool? ?? false;
                  final description =
                      data['description'] as String? ?? 'No description';
                  final ts = data['createdAt'] as Timestamp?;
                  final dueTs = data['dueAt'] as Timestamp?;
                  final time = ts != null ? _formatTime(ts.toDate()) : '';
                  final due = dueTs != null
                      ? 'Due: ${_formatDateTime(dueTs.toDate())}'
                      : 'Due: not set';
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _selectedTaskId = doc.id;
                          });
                        },
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
                          '$description\n$due\n$time',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                              onPressed: () => _showEditDialog(
                                doc.id,
                                title,
                                description,
                                dueTs,
                              ),
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
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day}/${dt.month}/${dt.year} $hour:$min';
  }

  String _formatDate(DateTime dt) {
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    return '${dt.year}-$month-$day';
  }

  String _formatDateTime(DateTime dt) {
    final date = _formatDate(dt);
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$date $hour:$minute';
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

class _LoadingState extends StatelessWidget {
  final String message;
  const _LoadingState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String message;

  const _EmptyState({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 56, color: color.outline),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: color.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineLoadingState extends StatelessWidget {
  final String message;

  const _InlineLoadingState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(message, style: const TextStyle(fontSize: 12))),
      ],
    );
  }
}

class _InlineEmptyState extends StatelessWidget {
  final String message;

  const _InlineEmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(message, style: Theme.of(context).textTheme.bodySmall);
  }
}

class _InlineErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const _InlineErrorState({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(message, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final isIndexError =
        message.contains('failed-precondition') &&
        message.toLowerCase().contains('requires an index');
    final title = isIndexError
        ? 'Missing Firestore index'
        : 'Could not load tasks';
    final detail = isIndexError
        ? 'This query needs a Firestore composite index. Open the link in the error text to create it, then reload the page.'
        : 'We could not load tasks right now. Please check your connection and try again.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
