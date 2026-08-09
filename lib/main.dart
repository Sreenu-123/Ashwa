import 'package:flutter/material.dart';
import 'Screens/Splash/splash_screen.dart';

void main() {
  runApp(const AshwaApp());
}

class AshwaApp extends StatefulWidget {
  const AshwaApp({super.key});

  @override
  State<AshwaApp> createState() => _AshwaAppState();
}

class _AshwaAppState extends State<AshwaApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  void changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ASHWA',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),

      themeMode: _themeMode,
      home: SplashScreen(onThemeChanged: changeTheme),
    );
  }
}
