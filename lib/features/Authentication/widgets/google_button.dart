import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Authentication/controller/use_cases.dart';

class GoogleSignInButton extends StatelessWidget {
  GoogleSignInButton({super.key});

  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: controller.signInWithGoogle,
      icon: FaIcon(
        FontAwesomeIcons.google,
        color: Theme.of(context).colorScheme.surface,
      ),
      label: Text(Constants.signinGoogleButton.tr),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(
            color: Theme.of(context).colorScheme.surface,
            width: 3,
          ),
        ),
        textStyle:
            Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 18),
      ),
    );
  }
}
