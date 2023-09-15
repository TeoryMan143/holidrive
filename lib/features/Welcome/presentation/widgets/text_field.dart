import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final IconData? icon;
  final String label;

  const FormTextField({
    super.key,
    this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: Text(label),
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
