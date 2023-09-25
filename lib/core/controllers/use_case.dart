import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoreState extends GetxController {
  late SharedPreferences pref;

  late Rx<ThemeMode> _themeMode;
  ThemeMode get themeMode => _themeMode.value;

  @override
  void onReady() async {
    super.onReady();
    pref = await SharedPreferences.getInstance();

    String? theme = pref.getString('theme');

    switch (theme) {
      case 'ThemeMode.dark':
        Get.changeThemeMode(ThemeMode.dark);
        _themeMode = Rx<ThemeMode>(ThemeMode.dark);
        break;
      case 'ThemeMode.light':
        Get.changeThemeMode(ThemeMode.light);
        _themeMode = Rx<ThemeMode>(ThemeMode.light);

        break;
      default:
        Get.changeThemeMode(ThemeMode.system);
        _themeMode = Rx<ThemeMode>(ThemeMode.system);
    }
  }

  void changeThemeMode(ThemeMode? themeMode) {
    if (themeMode == null) {
      return;
    }
    Get.changeThemeMode(themeMode);
    _themeMode = Rx<ThemeMode>(themeMode);
    pref.setString('theme', themeMode.toString());
  }
}
