import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Authentication/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const RegisterScreen({super.key, required this.onThemeChanged});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // ============================================================
  // FORM
  // ============================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ============================================================
  // FIREBASE AUTH
  // ============================================================

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ============================================================
  // VARIABLES
  // ============================================================

  bool isChecked = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  // ============================================================
  // REGISTER
  // ============================================================

  Future<void> register() async {
    FocusScope.of(context).unfocus();

    // ------------------------------------------------------------
    // VALIDATE FORM
    // ------------------------------------------------------------

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // ------------------------------------------------------------
    // CHECK TERMS
    // ------------------------------------------------------------

    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please agree to the Terms & Conditions and Privacy Policy',
          ),
        ),
      );

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
      // CREATE FIREBASE ACCOUNT
      // ==========================================================

      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text,
          );

      // ==========================================================
      // SAVE USER NAME
      // ==========================================================

      await userCredential.user?.updateDisplayName(nameController.text.trim());

      // Refresh Firebase user
      await userCredential.user?.reload();

      if (!mounted) return;

      // ==========================================================
      // ACCOUNT CREATED SUCCESSFULLY
      // ==========================================================

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );

      // ==========================================================
      // IMPORTANT
      //
      // Firebase automatically signs the user in after
      // createUserWithEmailAndPassword().
      //
      // Since we want the user to go to Login Screen and
      // manually login, sign the user out first.
      // ==========================================================

      await _auth.signOut();

      if (!mounted) return;

      // ==========================================================
      // GO TO LOGIN SCREEN
      // ==========================================================

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LoginScreen(onThemeChanged: widget.onThemeChanged),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = 'An account already exists with this email.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'weak-password':
          message = 'Password is too weak. Use a stronger password.';
          break;

        case 'operation-not-allowed':
          message = 'Email/Password authentication is not enabled.';
          break;

        case 'network-request-failed':
          message = 'Network error. Please check your internet connection.';
          break;

        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;

        default:
          message = e.message ?? 'Account creation failed.';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
                  'Create Account',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Sign up to start your riding journey',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 32),

                // ========================================================
                // FULL NAME
                // ========================================================
                fieldLabel(context, 'Full Name'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: nameController,

                  textCapitalization: TextCapitalization.words,

                  style: TextStyle(color: colorScheme.onSurface, fontSize: 16),

                  decoration: inputDecoration(
                    context,
                    hintText: 'Enter your full name',
                    icon: Icons.person_outline,
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }

                    if (value.trim().length < 2) {
                      return 'Please enter a valid name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ========================================================
                // EMAIL
                // ========================================================
                fieldLabel(context, 'Email'),

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

                // ========================================================
                // PASSWORD
                // ========================================================
                fieldLabel(context, 'Password'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: passwordController,

                  obscureText: obscurePassword,

                  style: TextStyle(color: colorScheme.onSurface, fontSize: 16),

                  decoration:
                      inputDecoration(
                        context,
                        hintText: 'Create a password',
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
                      return 'Please enter a password';
                    }

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ========================================================
                // CONFIRM PASSWORD
                // ========================================================
                fieldLabel(context, 'Confirm Password'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: confirmPasswordController,

                  obscureText: obscureConfirmPassword,

                  style: TextStyle(color: colorScheme.onSurface, fontSize: 16),

                  decoration:
                      inputDecoration(
                        context,
                        hintText: 'Confirm your password',
                        icon: Icons.lock_outline,
                      ).copyWith(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },

                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,

                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }

                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // ========================================================
                // TERMS & CONDITIONS
                // ========================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Checkbox(
                      value: isChecked,

                      activeColor: Colors.blue,

                      checkColor: Colors.white,

                      onChanged: (value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),

                        child: Text(
                          'I agree to the Terms & Conditions and Privacy Policy',

                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,

                            fontSize: 13,

                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ========================================================
                // CREATE ACCOUNT BUTTON
                // ========================================================
                SizedBox(
                  width: double.infinity,
                  height: 56,

                  child: ElevatedButton(
                    onPressed: isLoading ? null : register,

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
                            'Create Account',

                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 18),

                // ========================================================
                // OR DIVIDER
                // ========================================================
                Row(
                  children: [
                    Expanded(child: Divider(color: colorScheme.outlineVariant)),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),

                      child: Text(
                        'or',

                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,

                          fontSize: 13,
                        ),
                      ),
                    ),

                    Expanded(child: Divider(color: colorScheme.outlineVariant)),
                  ],
                ),

                const SizedBox(height: 14),

                // ========================================================
                // BACK TO LOGIN
                // ========================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      'Already have an account?',

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
                                  builder: (context) => LoginScreen(
                                    onThemeChanged: widget.onThemeChanged,
                                  ),
                                ),
                              );
                            },

                      child: const Text(
                        'Login',

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
  // FIELD LABEL
  // ============================================================

  Widget fieldLabel(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      label,

      style: TextStyle(
        color: colorScheme.onSurface,

        fontSize: 14,

        fontWeight: FontWeight.w600,
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
