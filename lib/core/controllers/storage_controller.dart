import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StorageRepository extends GetxController {
  static final instance = Get.find<StorageRepository>();

  final _storageRef = FirebaseStorage.instance.ref();

  Future<void> uploadFile(
    String fileName,
    String filePath,
    String parentFolder,
  ) async {
    final profilePictureRef = _storageRef.child('$parentFolder/$fileName');
    final file = File(filePath);

    try {
      await profilePictureRef.putFile(file);
    } on FirebaseException catch (e) {
      debugPrint('Failed with expeption ${e.message}, code ${e.code}');
    }
  }
}
