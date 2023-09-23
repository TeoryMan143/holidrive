import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Authentication/presentation/sign_in.dart';
import 'package:holidrive/features/Authentication/widgets/google_button.dart';
import 'package:holidrive/features/Authentication/widgets/text_field.dart';
import 'package:holidrive/features/Authentication/controller/use_cases.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.app_registration_outlined,
                    size: 180,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 40),
                    child: Text(
                      Constants.signupTitle.tr,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 30,
                          ),
                    ),
                  ),
                  FormTextField(
                    controller: controller.name,
                    label: Constants.name.tr,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  FormTextField(
                    controller: controller.email,
                    label: Constants.email.tr,
                    email: true,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  FormTextField(
                    password: true,
                    controller: controller.password,
                    label: Constants.password.tr,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  FormTextField(
                    password: true,
                    controller: controller.confrimPassword,
                    label: Constants.confPassword.tr,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  FormTextField(
                    controller: controller.number,
                    label: Constants.number.tr,
                    numeric: true,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        if (controller.password.text.trim() ==
                            controller.confrimPassword.text.trim()) {
                          controller.registerUserLocal(
                            fullName: controller.name.text.trim(),
                            email: controller.email.text.trim(),
                            password: controller.password.text.trim(),
                            number: int.parse(controller.number.text.trim()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        textStyle: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontSize: 18),
                      ),
                      child: Text(Constants.signupButton.tr),
                    ),
                  ),
                  GoogleSignInButton(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        Constants.signupSec1.tr,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.off(
                            () => const SignInScreen(),
                            transition: Transition.downToUp,
                            duration: const Duration(milliseconds: 400),
                          );
                          controller.disposeControllers();
                        },
                        child: Text(
                          Constants.signupSec2.tr,
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
