import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/storage_service.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  final _service = StorageService();
  final _picker = ImagePicker();

  XFile? _pickedFile;
  double? _uploadProgress;
  String? _downloadUrl;
  String? _error;
  bool _uploading = false;

  Future<void> _pickImage() async {
    final xfile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (xfile != null) {
      setState(() {
        _pickedFile = xfile;
        _downloadUrl = null;
        _error = null;
        _uploadProgress = null;
      });
    }
  }

  Future<void> _upload() async {
    if (_pickedFile == null) return;
    setState(() {
      _uploading = true;
      _error = null;
      _uploadProgress = 0;
    });

    try {
      final url = await _service.uploadImage(
        _pickedFile!,
        onProgress: (p) {
          if (mounted) setState(() => _uploadProgress = p);
        },
      );
      if (mounted) {
        setState(() {
          _downloadUrl = url;
          _uploading = false;
          _uploadProgress = 1.0;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _uploading = false;
          _uploadProgress = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Firebase Storage',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Text('Upload images to Cloud Storage', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.cloud_upload_outlined,
                      color: Colors.green.shade700),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Firebase Storage stores media files (images, videos, PDFs). '
                      'It returns a permanent public download URL you can save '
                      'in Firestore and load anywhere.',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.green.shade900,
                          height: 1.4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _StepCard(
              step: '1',
              title: 'Pick an Image',
              color: Colors.green.shade700,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green.shade700,
                      side: BorderSide(color: Colors.green.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _uploading ? null : _pickImage,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(
                      _pickedFile == null
                          ? 'Choose from Gallery'
                          : '✓  ${_pickedFile!.name}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _StepCard(
              step: '2',
              title: 'Upload to Firebase Storage',
              color: Colors.blue.shade600,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: (_pickedFile == null || _uploading)
                        ? null
                        : _upload,
                    icon: _uploading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.cloud_upload),
                    label: Text(
                      _uploading ? 'Uploading…' : 'Upload Image',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),

                  if (_uploadProgress != null) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _uploadProgress,
                        minHeight: 8,
                        backgroundColor: Colors.blue.shade100,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue.shade600),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${((_uploadProgress ?? 0) * 100).toInt()}%',
                      style: TextStyle(
                          fontSize: 12, color: Colors.blue.shade700),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 12),

            _StepCard(
              step: '3',
              title: 'Download URL (stored in Firestore)',
              color: Colors.purple.shade600,
              child: _downloadUrl != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _downloadUrl!,
                            style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 10,
                                color: Colors.blue),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Uploaded image preview:',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            _downloadUrl!,
                            height: 200,
                            fit: BoxFit.cover,
                            loadingBuilder: (ctx, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                height: 200,
                                color: Colors.grey.shade200,
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Upload an image above to get its permanent URL.',
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 13),
                    ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.cloud_off,
                            color: Colors.red.shade600, size: 18),
                        const SizedBox(width: 6),
                        const Text('Firebase not configured yet',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Run "flutterfire configure" to connect to a real '
                      'Firebase project, then enable Storage in the console.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '// Upload using bytes — works on web + mobile\n'
                'final bytes = await xfile.readAsBytes();\n'
                'final ref = FirebaseStorage.instance\n'
                '    .ref().child(\'uploads/\${filename}\');\n'
                'final snapshot = await ref.putData(bytes);\n'
                'final url = await snapshot.ref.getDownloadURL();',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Color(0xFFCDD6F4),
                  height: 1.7,
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String step;
  final String title;
  final Color color;
  final Widget child;

  const _StepCard({
    required this.step,
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: color,
                  child: Text(
                    step,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}
