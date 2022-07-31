import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  Future<String> uploadFileToFirestoreDatabase({
    required String path,
    required File file,
  }) async {
    UploadTask uploadTask =
        FirebaseStorage.instance.ref().child(path).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
