import 'package:flutter/material.dart';

class ThemeConfig {
  static ThemeData buildLightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[100],
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
        elevation: 1,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.black87, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        color: Colors.grey[50],
        elevation: 2,
      ),
    );
  }

  static ThemeData buildDarkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[850],
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.grey, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.grey, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        color: Colors.grey[800],
        elevation: 2,
      ),
    );
  }
}
