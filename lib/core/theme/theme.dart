import 'package:flutter/material.dart';

abstract class Themes {
  static final lightTheme = ThemeData(
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
      surface: Color(0xffFF8C33),
      onSurface: Color(0xffE4DBD1),
    ),
    fontFamily: 'Catamaran',
    cardTheme: const CardTheme(
      color: Color(0xffFD6904),
      surfaceTintColor: Color(0xffffffff),
    ),
  );
  static final darkTheme = ThemeData(
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
      surface: Color(0xffFF8C33),
      onSurface: Color(0xffE4DBD1),
    ),
    fontFamily: 'Catamaran',
    cardTheme: const CardTheme(
      color: Color(0xffFD6904),
      surfaceTintColor: Color(0xffffffff),
    ),
  );
}
