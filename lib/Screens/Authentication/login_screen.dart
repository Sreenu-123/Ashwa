import 'package:flutter/material.dart';

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
  // PASSWORD VISIBILITY
  // ============================================================

  bool obscurePassword = true;

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

  void login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NavigationScreen(onThemeChanged: widget.onThemeChanged),
      ),
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
                // ============================================================
                // HEADER
                // ============================================================
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

                // ============================================================
                // EMAIL
                // ============================================================
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

                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ============================================================
                // PASSWORD
                // ============================================================
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

                // ============================================================
                // FORGOT PASSWORD
                // ============================================================
                Align(
                  alignment: Alignment.centerRight,

                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgetPasswordScreen(),
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

                // ============================================================
                // LOGIN BUTTON
                // ============================================================
                SizedBox(
                  width: double.infinity,
                  height: 56,

                  child: ElevatedButton(
                    onPressed: login,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,

                      foregroundColor: Colors.white,

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    child: const Text(
                      'Login',

                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ============================================================
                // DIVIDER
                // ============================================================
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

                // ============================================================
                // SOCIAL LOGIN
                // ============================================================
                Row(
                  children: [
                    Expanded(
                      child: socialLoginButton(
                        context: context,
                        assetPath: 'assets/images/google.png',
                        title: 'Google',
                        iconSize: 22,
                        onPressed: () {},
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: socialLoginButton(
                        context: context,
                        assetPath: 'assets/images/facebook.png',
                        title: 'Facebook',
                        iconSize: 22,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 45),

                // ============================================================
                // REGISTER
                // ============================================================
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
                      onPressed: () {
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

                const SizedBox(height: 10),
              ],
            ),
          ),
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
      height: 54,

      child: OutlinedButton.icon(
        onPressed: onPressed,

        icon: Image.asset(assetPath, width: iconSize, height: iconSize),

        label: Text(
          title,

          style: TextStyle(
            color: colorScheme.onSurface,

            fontSize: 14,

            fontWeight: FontWeight.w600,
          ),
        ),

        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.outlineVariant),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
