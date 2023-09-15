import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Welcome/presentation/widgets/text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                    Icons.login,
                    size: 180,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 48),
                    child: Text(
                      Constants.loginTitle.tr,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 35,
                          ),
                    ),
                  ),
                  FormTextField(
                    icon: Icons.email_outlined,
                    label: Constants.email.tr,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FormTextField(
                    icon: Icons.lock_outline,
                    label: Constants.password.tr,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 20),
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
                      child: Text(Constants.loginButton.tr),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        Constants.loginSec1.tr,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () => '',
                        child: Text(
                          Constants.loginSec2.tr,
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
