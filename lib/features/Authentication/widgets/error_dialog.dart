import 'package:flutter/material.dart';
import 'package:get/get.dart';

void errorDialog({required String title, String? body}) {
  Get.dialog(
    AlertDialog.adaptive(
      title: Text(
        title,
        style: Theme.of(Get.context!).textTheme.headlineSmall?.copyWith(
              color: Theme.of(Get.context!).colorScheme.surface,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
      ),
      content: body != null ? Text(body, softWrap: true) : null,
      actions: <Widget>[
        ElevatedButton(onPressed: Get.back, child: const Text('Ok'))
      ],
    ),
  );
}
