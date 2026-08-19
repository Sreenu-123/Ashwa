import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/Splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final savedAppearance = prefs.getString('settings_appearance') ?? 'Dark';

  ThemeMode initialTheme;

  if (savedAppearance == 'Light') {
    initialTheme = ThemeMode.light;
  } else if (savedAppearance == 'System') {
    initialTheme = ThemeMode.system;
  } else {
    initialTheme = ThemeMode.dark;
  }

  runApp(AshwaApp(initialThemeMode: initialTheme));
}

class AshwaApp extends StatefulWidget {
  final ThemeMode initialThemeMode;

  const AshwaApp({super.key, required this.initialThemeMode});

  @override
  State<AshwaApp> createState() => _AshwaAppState();
}

class _AshwaAppState extends State<AshwaApp> {
  // ================= THEME =================

  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();

    _themeMode = widget.initialThemeMode;
  }

  // ================= CHANGE THEME =================

  void changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'ASHWA',

      // ================= LIGHT THEME =================
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),

      // ================= DARK THEME =================
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),

      // ================= CURRENT THEME =================
      themeMode: _themeMode,

      // ================= HOME =================
      home: SplashScreen(onThemeChanged: changeTheme),
    );
  }
}
