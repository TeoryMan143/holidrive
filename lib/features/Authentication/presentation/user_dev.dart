import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holidrive/features/Authentication/controller/use_cases.dart';

class UserDev extends StatelessWidget {
  const UserDev({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    print(controller.user);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Obx(
                () => Text(
                  controller.user!.value!.fullName,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Obx(
                () => Text(
                  controller.user!.value!.email,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              TextButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: const Text(
                  'si',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
