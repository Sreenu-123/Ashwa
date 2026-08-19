import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  // ============================================================
  // CONTROLLER
  // ============================================================

  final TextEditingController emailController = TextEditingController();

  // ============================================================
  // FORM KEY
  // ============================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  // ============================================================
  // SEND RESET LINK
  // ============================================================

  void sendResetLink() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showResetSuccessDialog();
  }

  // ============================================================
  // RESET SUCCESS DIALOG
  // ============================================================

  void showResetSuccessDialog() {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          contentPadding: const EdgeInsets.all(24),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              // ============================================================
              // SUCCESS ICON
              // ============================================================
              Container(
                width: 64,
                height: 64,

                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),

                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.mark_email_read_outlined,

                  color: Colors.greenAccent,

                  size: 32,
                ),
              ),

              const SizedBox(height: 18),

              // ============================================================
              // TITLE
              // ============================================================
              Text(
                'Check Your Email',

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: colorScheme.onSurface,

                  fontSize: 20,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // ============================================================
              // MESSAGE
              // ============================================================
              Text(
                'If an account exists with this email, a password reset link will be sent to you.',

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,

                  fontSize: 14,

                  height: 1.4,
                ),
              ),

              const SizedBox(height: 22),

              // ============================================================
              // OK BUTTON
              // ============================================================
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,

                    foregroundColor: Colors.white,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    'Back to Login',

                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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

          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ============================================================
                // BACK BUTTON
                // ============================================================
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  padding: EdgeInsets.zero,

                  alignment: Alignment.centerLeft,

                  icon: Icon(
                    Icons.arrow_back_ios_new,

                    color: colorScheme.onSurface,

                    size: 21,
                  ),
                ),

                const SizedBox(height: 28),

                // ============================================================
                // ICON
                // ============================================================
                Center(
                  child: Container(
                    width: 82,
                    height: 82,

                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.12),

                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.lock_reset_outlined,

                      color: Colors.blue,

                      size: 42,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ============================================================
                // TITLE
                // ============================================================
                Center(
                  child: Text(
                    'Forgot Password?',

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: colorScheme.onSurface,

                      fontSize: 28,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ============================================================
                // DESCRIPTION
                // ============================================================
                Center(
                  child: Text(
                    'Enter your email address and we’ll help you reset your password.',

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,

                      fontSize: 15,

                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // ============================================================
                // EMAIL LABEL
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

                // ============================================================
                // EMAIL FIELD
                // ============================================================
                TextFormField(
                  controller: emailController,

                  keyboardType: TextInputType.emailAddress,

                  style: TextStyle(color: colorScheme.onSurface, fontSize: 16),

                  decoration: InputDecoration(
                    hintText: 'Enter your email',

                    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),

                    prefixIcon: Icon(
                      Icons.email_outlined,

                      color: colorScheme.onSurfaceVariant,
                    ),

                    filled: true,

                    fillColor: colorScheme.surfaceContainer,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 17,
                    ),

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

                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),

                      borderSide: const BorderSide(color: Colors.redAccent),
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),

                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                        width: 1.5,
                      ),
                    ),
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

                const SizedBox(height: 28),

                // ============================================================
                // RESET BUTTON
                // ============================================================
                SizedBox(
                  width: double.infinity,
                  height: 56,

                  child: ElevatedButton(
                    onPressed: sendResetLink,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,

                      foregroundColor: Colors.white,

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    child: const Text(
                      'Send Reset Link',

                      style: TextStyle(
                        fontSize: 17,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ============================================================
                // INFO
                // ============================================================
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.08),

                    borderRadius: BorderRadius.circular(16),

                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.15),
                    ),
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Icon(
                        Icons.info_outline,

                        color: Colors.blue,

                        size: 22,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          'Make sure you enter the email address associated with your ASHWA account.',

                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,

                            fontSize: 13,

                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // ============================================================
                // BACK TO LOGIN
                // ============================================================
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text(
                      'Back to Login',

                      style: TextStyle(
                        color: Colors.blue,

                        fontSize: 14,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
