/// MAD201-01 Project 1
/// Darshilkumar Karkar - A00203357
/// Theme Notifier for managing light/dark mode
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  bool _isDarkMode = false;

  // Getter for the app to know if it's in dark mode
  bool get isDarkMode => _isDarkMode;

  // Getter for the MaterialApp to set its theme
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Loads the saved theme preference from disk
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  /// Toggles the theme and saves the preference
  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }
}
