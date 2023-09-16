import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDev extends StatelessWidget {
  const UserDev({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Text('si'),
          Text('Soy'),
          TextButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            child: Text('si'),
          ),
        ],
      )),
    );
  }
}
