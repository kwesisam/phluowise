import 'package:flutter/material.dart';
import 'package:phluowise/utils/hexColor.dart';

class AppTheme {
  // Common colors
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color accentColor = Color(0xFF03DAC6);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: HexColor('#202225'),
    appBarTheme: AppBarTheme(
      backgroundColor: HexColor('#292B2F'),
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(),
    fontFamily: 'Roboto',
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: HexColor('#060606'),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(),
    fontFamily: 'Roboto',
  );

  static ThemeData grayTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: HexColor('#202225'),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(),
  );
}
