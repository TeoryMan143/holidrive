import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/lang/lang.dart';
import 'package:holidrive/core/loading_screen.dart';
import 'package:holidrive/core/theme/theme.dart';
import 'package:holidrive/core/controllers/use_case.dart';
import 'package:holidrive/core/controllers/storage_controller.dart';
import 'firebase_options.dart';
import 'package:holidrive/core/controllers/auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(StorageRepository());
  Get.put(AuthRepository(), permanent: true);
  Get.put(CoreState());
  FirebaseDatabase.instance.setPersistenceEnabled(true);
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
      home: const LoadingScreen(),
    );
  }
}
