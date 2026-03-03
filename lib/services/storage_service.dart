import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

/// StorageService — uploads media to Firebase Cloud Storage.
///
/// Uses XFile.readAsBytes() so the same code works on
/// both mobile (Android/iOS) and web without any platform checks.
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ── Upload image ─────────────────────────────────────────────────────────
  /// Uploads [xfile] to Firebase Storage under `uploads/{filename}`.
  /// Returns the public download URL on success, or null on failure.
  ///
  /// [onProgress] callback receives 0.0–1.0 upload progress.
  Future<String?> uploadImage(
    XFile xfile, {
    void Function(double progress)? onProgress,
  }) async {
    final bytes = await xfile.readAsBytes();
    final filename =
        '${DateTime.now().millisecondsSinceEpoch}_${xfile.name}';
    final ref = _storage.ref().child('uploads/$filename');

    final task = ref.putData(
      bytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    // Listen to upload progress
    task.snapshotEvents.listen((snapshot) {
      if (snapshot.totalBytes > 0 && onProgress != null) {
        onProgress(snapshot.bytesTransferred / snapshot.totalBytes);
      }
    });

    final snapshot = await task;
    return await snapshot.ref.getDownloadURL();
  }

  // ── List uploaded files ──────────────────────────────────────────────────
  Future<List<Reference>> listUploads() async {
    final result = await _storage.ref().child('uploads').listAll();
    return result.items;
  }
}
