import 'package:flutter/material.dart';

import '../../services/api_services.dart';
import '../Authentication/login_screen.dart';
import '../Home/main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const SplashScreen({super.key, required this.onThemeChanged});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _checkAuthentication();
  }

  // ============================================================
  // CHECK AUTHENTICATION
  // ============================================================

  Future<void> _checkAuthentication() async {
    // Keep splash screen visible for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    try {
      // ----------------------------------------------------------
      // CHECK STORED TOKEN
      // ----------------------------------------------------------

      final token = await ApiService.getAccessToken();

      // ----------------------------------------------------------
      // NO TOKEN → LOGIN
      // ----------------------------------------------------------

      if (token == null || token.isEmpty) {
        _goToLogin();
        return;
      }

      // ----------------------------------------------------------
      // TOKEN EXISTS → VERIFY WITH BACKEND
      // ----------------------------------------------------------

      await ApiService.getCurrentUser();

      // ----------------------------------------------------------
      // VALID TOKEN → HOME
      // ----------------------------------------------------------

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              NavigationScreen(onThemeChanged: widget.onThemeChanged),
        ),
      );
    } catch (e) {
      // ----------------------------------------------------------
      // INVALID / EXPIRED TOKEN → LOGOUT
      // ----------------------------------------------------------

      await ApiService.logout();

      if (!mounted) return;

      _goToLogin();
    }
  }

  // ============================================================
  // GO TO LOGIN
  // ============================================================

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LoginScreen(onThemeChanged: widget.onThemeChanged),
      ),
    );
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // ================= LOGO =================
          Center(
            child: Image.asset(
              'assets/images/ashwa.png',
              width: 180,
              height: 180,
            ),
          ),

          // ================= APP NAME =================
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ashwa',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 33,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Your Intelligent Horse Riding Trainer',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
