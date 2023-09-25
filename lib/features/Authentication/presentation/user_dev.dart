import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holidrive/features/Authentication/controller/use_cases.dart';

class UserDev extends StatelessWidget {
  const UserDev({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GetX<AuthController>(
            init: AuthController(),
            builder: (controller) => controller.isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: <Widget>[
                      const SizedBox(height: 100),
                      Text(
                        controller.user!.fullName,
                        style: const TextStyle(fontSize: 25),
                      ),
                      ElevatedButton(
                          onPressed: controller.logOut,
                          child: const Text('salir')),
                      ElevatedButton(
                          onPressed: controller.upload,
                          child: const Text('salir'))
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
