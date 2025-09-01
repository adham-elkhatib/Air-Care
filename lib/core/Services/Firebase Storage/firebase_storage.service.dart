import 'package:firebase_storage/firebase_storage.dart';

import '../Error Handling/error_handling.service.dart';
import 'src/models/storage_file.model.dart';

class FirebaseStorageService {
  //
  static final _storage = FirebaseStorage.instance;

  //

  //
  static UploadTask? uploadSingle(String path, StorageFile file) {
    try {
      // check if file exists and delete..
      Reference ref = _storage.ref(
        '$path/${file.fileName}.${file.fileExtension}',
      );
      return ref.putData(
        file.data,
        SettableMetadata(contentType: "image/jpeg"),
      );
    } catch (e) {
      ErrorHandlingService.handle(e, 'StorageService/uploadSingle');
    }
    return null;
  }

  static UploadTask? uploadMultiple(String path, StorageFile file) {
    try {
      // check if file exists and delete..
      Reference ref = _storage.ref(
        '$path/${file.fileName}.${file.fileExtension}',
      );
      return ref.putData(
        file.data,
        SettableMetadata(contentType: "image/jpeg"),
      );
    } catch (e) {
      ErrorHandlingService.handle(e, 'StorageService/uploadSingle');
    }
    return null;
  }
}
