import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Authentication/presentation/sign_up.dart';
import 'package:holidrive/features/Authentication/widgets/google_button.dart';
import 'package:holidrive/features/Authentication/widgets/text_field.dart';
import 'package:holidrive/features/Authentication/controller/use_cases.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
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
                    Icons.login,
                    size: 180,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 48),
                    child: Text(
                      Messages.loginTitle.tr,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 35,
                          ),
                    ),
                  ),
                  FormTextField(
                    controller: controller.email,
                    icon: Icons.email_outlined,
                    label: Messages.email.tr,
                    email: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FormTextField(
                    password: true,
                    controller: controller.password,
                    icon: Icons.lock_outline,
                    label: Messages.password.tr,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        controller.logInUserLocal(controller.email.text.trim(),
                            controller.password.text.trim());
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
                      child: Text(Messages.loginButton.tr),
                    ),
                  ),
                  GoogleSignInButton(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        Messages.loginSec1.tr,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.offAll(
                            () => const SignUpScreen(),
                            transition: Transition.downToUp,
                            duration: const Duration(milliseconds: 400),
                          );
                          controller.resetControllers();
                        },
                        child: Text(
                          Messages.loginSec2.tr,
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
