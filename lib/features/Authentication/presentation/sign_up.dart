import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Welcome/presentation/widgets/text_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Form(
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
                    padding: const EdgeInsets.only(top: 15, bottom: 40),
                    child: Text(
                      Constants.signupTitle.tr,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 30,
                          ),
                    ),
                  ),
                  FormTextField(
                    label: Constants.email.tr,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  FormTextField(
                    label: Constants.password.tr,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  FormTextField(
                    label: Constants.confPassword.tr,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  FormTextField(
                    label: Constants.number.tr,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: ElevatedButton(
                      onPressed: () => '',
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
                        onPressed: () => '',
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
