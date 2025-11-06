/// MAD201-01 Project 1
/// Darshilkumar Karkar - A00203357
/// Main Application Entry Point
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // Import your splash screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Budget Tracker',
      theme: ThemeData.light(), // Default theme
      darkTheme: ThemeData.dark(), // Default dark theme
      themeMode: ThemeMode.system, // We will control this from settings later
      home: SplashScreen(), // Start with the splash screen
    );
  }
}
