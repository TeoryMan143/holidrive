import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoreState extends GetxController {
  late SharedPreferences pref;

  @override
  void onReady() async {
    super.onReady();
    pref = await SharedPreferences.getInstance();

    String? theme = pref.getString('theme');

    switch (theme) {
      case 'ThemeMode.dark':
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case 'ThemeMode.light':
        Get.changeThemeMode(ThemeMode.light);
        break;
      default:
        Get.changeThemeMode(ThemeMode.system);
    }
  }

  Future<void> changeThemeMode(ThemeMode themeMode) async {
    Get.changeThemeMode(themeMode);
    pref.setString('theme', themeMode.toString());
  }
}
