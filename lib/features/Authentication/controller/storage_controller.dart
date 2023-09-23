import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageController {
  final _storageRef = FirebaseStorage.instance.ref();

  Future<void> uploadProfilePicture(String fileName, String filePath) async {
    final profilePictureRef = _storageRef.child('profilePictures/');
    final file = File(filePath);

    try {
      await profilePictureRef.child('${fileName}pf').putFile(file);
    } catch (e) {
      print('Exeption $e');
    }
  }
}
