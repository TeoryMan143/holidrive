import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/lang/lang.dart';
import 'package:holidrive/core/theme/theme.dart';
import 'package:holidrive/core/use_case.dart';
import 'package:holidrive/features/Authentication/presentation/sign_in.dart';
import 'firebase_options.dart';
import 'package:holidrive/core/auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthRepository());
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
      title: 'Holidrive',
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      home: const SignInScreen(),
    );
  }
}
