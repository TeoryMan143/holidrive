import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class Themes {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xffFEF3E6),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xffFD6904),
      onPrimary: Color(0xffffffff),
      secondary: Color(0xffdd5500),
      onSecondary: Color(0xffffffff),
      error: Colors.red,
      onError: Color(0xffffffff),
      background: Color(0xffFEF3E6),
      onBackground: Color(0xff19141E),
      surface: Color(0xffFF914D),
      onSurface: Color(0xFFFFF6EC),
    ),
    fontFamily: 'Catamaran',
    cardTheme: const CardTheme(
      color: Color(0xffFD6904),
      surfaceTintColor: Color(0xffffffff),
    ),
    buttonTheme: Get.theme.buttonTheme.copyWith(
      colorScheme: Get.theme.colorScheme.copyWith(
        background: const Color(0xffFF914D),
      ),
    ),
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        letterSpacing: 3,
      ),
    ),
  );
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xff19141E),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffFD6904),
      onPrimary: Color(0xffffffff),
      secondary: Color(0xffdd5500),
      onSecondary: Color(0xffffffff),
      error: Colors.red,
      onError: Color(0xffffffff),
      background: Color(0xff19141E),
      onBackground: Color(0xffA29487),
      surface: Color(0xffFF914D),
      onSurface: Color(0xff2E2435),
    ),
    fontFamily: 'Catamaran',
    cardTheme: const CardTheme(
      color: Color(0xffFD6904),
      surfaceTintColor: Color(0xffffffff),
    ),
    buttonTheme: Get.theme.buttonTheme.copyWith(
      colorScheme: Get.theme.colorScheme.copyWith(
        background: const Color(0xffFF914D),
      ),
    ),
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        letterSpacing: 3,
      ),
    ),
  );
}
