import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'Screens/Splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();

  // Default appearance is Light
  final savedAppearance = prefs.getString('settings_appearance') ?? 'Light';

  ThemeMode initialTheme;

  if (savedAppearance == 'Dark') {
    initialTheme = ThemeMode.dark;
  } else if (savedAppearance == 'System') {
    initialTheme = ThemeMode.system;
  } else {
    initialTheme = ThemeMode.light;
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
