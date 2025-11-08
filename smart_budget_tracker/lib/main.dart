/// MAD201-01 Project 1
/// Darshilkumar Karkar - A00203357
/// Main Application Entry Point
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'providers/theme_notifier.dart'; // Import the notifier
import 'screens/splash_screen.dart';

void main() async {
  // We need to initialize widgets first to load the theme
  WidgetsFlutterBinding.ensureInitialized();

  // Create the notifier and load the saved theme
  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadTheme();

  runApp(
    // Wrap the app in the provider
    ChangeNotifierProvider(create: (context) => themeNotifier, child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use a Consumer to listen for theme changes
    return Consumer<ThemeNotifier>(
      builder: (context, notifier, child) {
        return MaterialApp(
          title: 'Smart Budget Tracker',

          // --- LIGHT THEME (Beige) ---
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFF5F5DC),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFD2B48C),
              foregroundColor: Colors.black,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFD2B48C),
              brightness: Brightness.light,
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFFFFF8E1),
              elevation: 1,
            ),
          ),

          // --- DARK THEME (Brown) ---
          darkTheme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFF3E2723),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF5D4037),
              foregroundColor: Colors.white,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.brown,
              brightness: Brightness.dark,
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFF4E342E),
              elevation: 1,
            ),
          ),

          // Set the themeMode from the notifier
          themeMode: notifier.themeMode,

          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}
