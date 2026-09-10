import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  late ThemeMode _themeMode;
  late SharedPreferences _prefs;

  ThemeMode get themeMode => _themeMode;

  // Initialize with SharedPreferences
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final savedTheme = _prefs.getString('theme') ?? 'system';
      _setThemeMode(savedTheme);
    } catch (e) {
      print('[ThemeNotifier] Error initializing: $e');
      _themeMode = ThemeMode.system;
    }
  }

  void setTheme(String theme) async {
    try {
      await _prefs.setString('theme', theme);
      _setThemeMode(theme);
    } catch (e) {
      print('[ThemeNotifier] Error saving theme: $e');
    }
  }

  void _setThemeMode(String theme) {
    switch (theme) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'system':
      default:
        _themeMode = ThemeMode.system;
        break;
    }
    notifyListeners();
  }
}
