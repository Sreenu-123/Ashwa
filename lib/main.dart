import 'package:flutter/material.dart';
import 'Screens/Home/main_navigation_screen.dart';

void main() {
  runApp(const AshwaApp());
}

class AshwaApp extends StatelessWidget {
  const AshwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ASHWA',
      home: const NavigationScreen(),
    );
  }
}
