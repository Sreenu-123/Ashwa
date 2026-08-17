import 'package:flutter/material.dart';

class AboutAshwaScreen extends StatelessWidget {
  const AboutAshwaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
        ),

        title: Text(
          'About ASHWA',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: false,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ================= ASHWA LOGO =================
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.all(18),
                child: Image.asset(
                  'assets/images/ashwa.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              // ================= APP NAME =================
              Text(
                'ASHWA',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Your Intelligent Horse Riding Trainer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 30),

              // ================= ABOUT =================
              _infoCard(
                context: context,
                icon: Icons.info_outline,
                title: 'About ASHWA',
                description:
                    'ASHWA is an intelligent horse riding training platform designed to help riders learn, practice, and improve their riding skills.',
              ),

              const SizedBox(height: 18),

              // ================= FEATURES =================
              _infoCard(
                context: context,
                icon: Icons.auto_awesome,
                title: 'Features',
                description:
                    'Riding Training\n'
                    'Progress Tracking\n'
                    'AI-Assisted Training\n'
                    'Learning & Horse Care',
              ),

              const SizedBox(height: 18),

              // ================= GOAL =================
              _infoCard(
                context: context,
                icon: Icons.flag_outlined,
                title: 'Our Goal',
                description:
                    'ASHWA aims to make horse riding training more structured, accessible, and engaging for riders.',
              ),

              const SizedBox(height: 18),

              // ================= VERSION =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.phone_android,
                      color: Colors.blue,
                      size: 28,
                    ),

                    const SizedBox(width: 15),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Version',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          '1.0.0',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              Text(
                'Made with ❤️ for Horse Riders',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.38),
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ================= INFO CARD =================

  static Widget _infoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= ICON =================
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.blue, size: 25),
          ),

          const SizedBox(width: 15),

          // ================= CONTENT =================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  description,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    height: 1.5,
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
