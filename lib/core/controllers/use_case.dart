import 'dart:ui' as ui;
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoreState extends GetxController {
  late SharedPreferences pref;

  late Rx<ThemeMode> _themeMode;
  ThemeMode get themeMode => _themeMode.value;

  static final instance = Get.find<CoreState>();

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
    holeMarkerIcon = await _getBytesFromAsset(Constants.holeMarkerImg, 90);
    roadWorkMarkerIcon =
        await _getBytesFromAsset(Constants.roadWorkMarkerImg, 90);
    dangerMarkerIcon =
        await _getBytesFromAsset(Constants.dangerZoneMarkerImg, 90);
  }

  late final Uint8List holeMarkerIcon;
  late final Uint8List roadWorkMarkerIcon;
  late final Uint8List dangerMarkerIcon;

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
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
