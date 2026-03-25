import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class UploadedMedia {
  final String fileName;
  final String storagePath;
  final String downloadUrl;
  final DateTime uploadedAt;
  final String? recordId;

  const UploadedMedia({
    required this.fileName,
    required this.storagePath,
    required this.downloadUrl,
    required this.uploadedAt,
    this.recordId,
  });
}

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UploadedMedia> uploadImage(
    XFile xfile, {
    String folder = 'uploads/user_images',
    void Function(double progress)? onProgress,
  }) async {
    final bytes = await xfile.readAsBytes();
    final ext = _safeExtension(xfile.name);
    final contentType = _contentTypeForExtension(ext);
    final filename = '${DateTime.now().millisecondsSinceEpoch}_${xfile.name}';
    final path = '$folder/$filename';
    final ref = _storage.ref().child(path);

    final task = ref.putData(bytes, SettableMetadata(contentType: contentType));

    task.snapshotEvents.listen((snapshot) {
      if (snapshot.totalBytes > 0 && onProgress != null) {
        onProgress(snapshot.bytesTransferred / snapshot.totalBytes);
      }
    });

    final snapshot = await task;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return UploadedMedia(
      fileName: filename,
      storagePath: path,
      downloadUrl: downloadUrl,
      uploadedAt: DateTime.now(),
    );
  }

  Future<UploadedMedia> uploadImageAndSaveRecord(
    XFile xfile, {
    void Function(double progress)? onProgress,
  }) async {
    final uploaded = await uploadImage(xfile, onProgress: onProgress);
    final recordId = await saveUploadRecord(uploaded);
    return UploadedMedia(
      fileName: uploaded.fileName,
      storagePath: uploaded.storagePath,
      downloadUrl: uploaded.downloadUrl,
      uploadedAt: uploaded.uploadedAt,
      recordId: recordId,
    );
  }

  Future<String> saveUploadRecord(UploadedMedia media) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw FirebaseAuthException(
        code: 'not-authenticated',
        message: 'Please sign in before uploading media.',
      );
    }
    final doc = await _firestore.collection('media_uploads').add({
      'uid': uid,
      'fileName': media.fileName,
      'storagePath': media.storagePath,
      'downloadUrl': media.downloadUrl,
      'uploadedAt': Timestamp.fromDate(media.uploadedAt),
    });
    return doc.id;
  }

  Future<void> deleteFile(String storagePath) async {
    await _storage.ref(storagePath).delete();
  }

  Future<void> deleteUploadedMedia(UploadedMedia media) async {
    await deleteFile(media.storagePath);
    final recordId = media.recordId;
    if (recordId != null && recordId.isNotEmpty) {
      await _firestore.collection('media_uploads').doc(recordId).delete();
    }
  }

  Future<List<Reference>> listUploads() async {
    final result = await _storage.ref().child('uploads').listAll();
    return result.items;
  }

  String _safeExtension(String fileName) {
    final parts = fileName.split('.');
    if (parts.length < 2) return 'jpg';
    return parts.last.toLowerCase();
  }

  String _contentTypeForExtension(String ext) {
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      case 'heic':
      case 'heif':
        return 'image/heic';
      case 'jpeg':
      case 'jpg':
      default:
        return 'image/jpeg';
    }
  }
}
