import 'package:flutter/material.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Welcome/presentation/steps.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 90,
        title: Image.asset(
          Constants.logoText,
          width: 250,
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

  List<Step> steps() => [const Step(title: Text(''), content: StepOne())];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stepper(
        steps: steps(),
        type: StepperType.horizontal,
      ),
    );
  }
}
