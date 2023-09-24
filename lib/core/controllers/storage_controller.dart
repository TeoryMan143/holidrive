import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class StorageRepository extends GetxController {
  static final instance = Get.find<StorageRepository>();

  final _storageRef = FirebaseStorage.instance.ref();

  void uploadProfilePicture(String fileName, String filePath) async {
    final profilePictureRef =
        _storageRef.child('profilePictures/${fileName}pf.jpg');
    final file = File(filePath);

    try {
      await profilePictureRef.putFile(file);
    } on FirebaseException catch (e) {
      print('Failed with expeption ${e.message}, code ${e.code}');
    }
  }
}
