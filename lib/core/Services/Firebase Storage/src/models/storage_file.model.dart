// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

class StorageFile {
  Uint8List data;
  String fileName;
  String fileExtension;

  StorageFile({
    required this.data,
    required this.fileName,
    required this.fileExtension,
  });

  StorageFile copyWith({
    Uint8List? data,
    String? fileName,
    String? fileExtension,
  }) {
    return StorageFile(
      data: data ?? this.data,
      fileName: fileName ?? this.fileName,
      fileExtension: fileExtension ?? this.fileExtension,
    );
  }

  @override
  String toString() =>
      'StorageFile(data: $data, fileName: $fileName, fileExtension: $fileExtension)';

  @override
  bool operator ==(covariant StorageFile other) {
    if (identical(this, other)) return true;

    return other.data == data &&
        other.fileName == fileName &&
        other.fileExtension == fileExtension;
  }

  @override
  int get hashCode =>
      data.hashCode ^ fileName.hashCode ^ fileExtension.hashCode;
}
