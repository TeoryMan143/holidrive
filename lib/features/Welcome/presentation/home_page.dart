import 'package:flutter/material.dart';
import 'package:holidrive/core/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 90,
        title: Image.asset(
          'assets/core/logo-text.png',
          width: 230,
        ),
      ),
      body: const WelcomeStepper(),
    );
  }
}

class WelcomeStepper extends StatefulWidget {
  const WelcomeStepper({super.key});

  @override
  State<WelcomeStepper> createState() => _WelcomeStepperState();
}

class _WelcomeStepperState extends State<WelcomeStepper> {
  var currentStep = 0;

  List<Step> steps() => [const Step(title: Text(''), content: Placeholder())];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[Image.asset(Constants.logoMarker)],
    );
  }
}
