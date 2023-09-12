import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/core/lang/lang.dart';
import 'package:holidrive/core/theme/theme.dart';
import 'package:holidrive/core/use_case.dart';
import 'features/Welcome/presentation/home_page.dart';
import 'firebase_options.dart';
import 'package:page_transition/page_transition.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(CoreState());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: MainMessages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      home: AnimatedSplashScreen(
        backgroundColor: const Color(0xffFBF3EB),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        splash: Column(
          children: <Widget>[
            Image.asset(
              Constants.logo,
              width: 100,
              fit: BoxFit.contain,
            ),
            const Text(
              'HOLIDRIVE',
              style: TextStyle(
                color: Color(0xffFD6904),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                letterSpacing: 10,
                fontSize: 20,
              ),
            )
          ],
        ),
        nextScreen: const HomePage(),
      ),
    );
  }
}
