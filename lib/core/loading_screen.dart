import 'package:flutter/material.dart';
import 'package:holidrive/core/constants.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(Constants.loadingGif, height: 200),
      ),
    );
  }
}
