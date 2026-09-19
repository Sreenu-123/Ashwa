import 'package:flutter/material.dart';

import '../../services/api_services.dart';
import '../Home/main_navigation_screen.dart';
import './forget_password_screen.dart';
import './register_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const LoginScreen({super.key, required this.onThemeChanged});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ============================================================
  // FORM KEY
  // ============================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ============================================================
  // VARIABLES
  // ============================================================

  bool obscurePassword = true;
  bool isLoading = false;

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> login() async {
    FocusScope.of(context).unfocus();

    // ------------------------------------------------------------
    // VALIDATE FORM
    // ------------------------------------------------------------

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // ------------------------------------------------------------
    // START LOADING
    // ------------------------------------------------------------

    setState(() {
      isLoading = true;
    });

    try {
      // ==========================================================
      // LOGIN THROUGH FASTAPI BACKEND
      // ==========================================================

      final result = await ApiService.loginUser(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      // ==========================================================
      // SUCCESS
      // ==========================================================

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']?.toString() ?? 'Login successful!'),
        ),
      );

      // ==========================================================
      // GO TO MAIN NAVIGATION
      // ==========================================================

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              NavigationScreen(onThemeChanged: widget.onThemeChanged),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      final String message = e.toString().replaceFirst('Exception: ', '');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // GOOGLE LOGIN
  // ============================================================

  void googleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Login will be connected next.')),
    );
  }

  // ============================================================
  // FACEBOOK LOGIN
  // ============================================================

  void facebookLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Facebook Login will be connected next.')),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ========================================================
                // HEADER
                // ========================================================

                const SizedBox(height: 20),

                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Sign in to continue your riding journey',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 32),

                // ========================================================
                // EMAIL
                // ========================================================
                Text(
                  'Email',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                  decoration: inputDecoration(
                    context,
                    hintText: 'Enter your email',
                    icon: Icons.email_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }

                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ========================================================
                // PASSWORD
                // ========================================================
                Text(
                  'Password',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                  decoration:
                      inputDecoration(
                        context,
                        hintText: 'Enter your password',
                        icon: Icons.lock_outline,
                      ).copyWith(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 8),

                // ========================================================
                // FORGOT PASSWORD
                // ========================================================
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgetPasswordScreen(),
                              ),
                            );
                          },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // ========================================================
                // LOGIN BUTTON
                // ========================================================
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.blue.withValues(
                        alpha: 0.5,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 28),

                // ========================================================
                // DIVIDER
                // ========================================================
                Row(
                  children: [
                    Expanded(child: Divider(color: colorScheme.outlineVariant)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'or continue with',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: colorScheme.outlineVariant)),
                  ],
                ),

                const SizedBox(height: 22),

                // ========================================================
                // SOCIAL LOGIN
                // ========================================================
                Row(
                  children: [
                    Expanded(
                      child: socialLoginButton(
                        context: context,
                        assetPath: 'assets/images/google.png',
                        title: 'Google',
                        iconSize: 22,
                        onPressed: googleLogin,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: socialLoginButton(
                        context: context,
                        assetPath: 'assets/images/facebook.png',
                        title: 'Facebook',
                        iconSize: 22,
                        onPressed: facebookLogin,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 45),

                // ========================================================
                // REGISTER
                // ========================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),

                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(
                                    onThemeChanged: widget.onThemeChanged,
                                  ),
                                ),
                              );
                            },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SOCIAL LOGIN BUTTON
  // ============================================================

  Widget socialLoginButton({
    required BuildContext context,
    required String assetPath,
    required String title,
    required double iconSize,
    required VoidCallback onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetPath, width: iconSize, height: iconSize),

            const SizedBox(width: 8),

            Text(
              title,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration inputDecoration(
    BuildContext context, {
    required String hintText,
    required IconData icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      prefixIcon: Icon(icon, color: colorScheme.onSurfaceVariant),
      filled: true,
      fillColor: colorScheme.surfaceContainer,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}
