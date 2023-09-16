import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';

class FormTextField extends StatelessWidget {
  final IconData? icon;
  final String label;
  final bool numeric;
  final bool email;
  final bool password;
  final TextEditingController controller;

  const FormTextField({
    super.key,
    this.icon,
    required this.label,
    this.numeric = false,
    this.email = false,
    this.password = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: password,
      textAlignVertical: TextAlignVertical.center,
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        border: const OutlineInputBorder(),
        label: Text(label),
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor: Theme.of(context).colorScheme.onSurface,
      ),
      // ignore: body_might_complete_normally_nullable
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${Constants.fieldErrorMessage.tr} $label';
        } else if (email) {
          if (EmailValidator.validate(controller.text)) {
            return null;
          }
          return Constants.emailFieldError.tr;
        }
        return null;
      },
      keyboardType: numeric ? TextInputType.number : null,
      inputFormatters: numeric
          ? [
              FilteringTextInputFormatter.digitsOnly // Allow only digits
            ]
          : null,
    );
  }
}
