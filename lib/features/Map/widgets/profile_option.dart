import 'package:flutter/material.dart';

class ProfileOption extends StatelessWidget {
  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    this.action = const SizedBox.shrink(),
    this.onTap,
  });

  final IconData icon;
  final String title;
  final void Function()? onTap;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 38,
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 22,
                ),
              ),
              const SizedBox(width: 30),
              SizedBox(height: 50, width: 100, child: action)
            ],
          ),
        ),
      ),
    );
  }
}
