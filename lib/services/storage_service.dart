import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

    task.snapshotEvents.listen((snapshot) {
      if (snapshot.totalBytes > 0 && onProgress != null) {
        onProgress(snapshot.bytesTransferred / snapshot.totalBytes);
      }
    });

    final snapshot = await task;
    return await snapshot.ref.getDownloadURL();
  }

  Future<List<Reference>> listUploads() async {
    final result = await _storage.ref().child('uploads').listAll();
    return result.items;
  }
}
