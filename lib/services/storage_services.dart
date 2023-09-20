import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageServices {
  Future<String> uploadImageToDB(
    File? selectedImage,
  ) async {
    FirebaseStorage fs = FirebaseStorage.instance;
    Reference ref = fs.ref().child(DateTime.now().millisecondsSinceEpoch.toString());
    await ref.putFile(File(selectedImage!.path));
    String url = await ref.getDownloadURL();
    return url;
  }
}
