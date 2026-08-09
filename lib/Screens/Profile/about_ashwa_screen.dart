import 'package:flutter/material.dart';

class AboutAshwaScreen extends StatelessWidget {
  const AboutAshwaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: const Text(
          'About ASHWA',
          style: TextStyle(
            color: Colors.white,
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

              // ASHWA Logo
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1F2A),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.all(18),
                child: Image.asset(
                  'assets/images/ashwa.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              // App Name
              const Text(
                'ASHWA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Your Intelligent Horse Riding Trainer',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),

              const SizedBox(height: 30),

              // About Card
              _infoCard(
                icon: Icons.info_outline,
                title: 'About ASHWA',
                description:
                    'ASHWA is an intelligent horse riding training platform designed to help riders learn, practice, and improve their riding skills.',
              ),

              const SizedBox(height: 18),

              // Features
              _infoCard(
                icon: Icons.auto_awesome,
                title: 'Features',
                description:
                    'Riding Training\n'
                    'Progress Tracking\n'
                    'AI-Assisted Training\n'
                    'Learning & Horse Care',
              ),

              const SizedBox(height: 18),

              // Mission
              _infoCard(
                icon: Icons.flag_outlined,
                title: 'Our Goal',
                description:
                    'ASHWA aims to make horse riding training more structured, accessible, and engaging for riders.',
              ),

              const SizedBox(height: 18),

              // Version
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1F2A),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.phone_android, color: Colors.blue, size: 28),

                    SizedBox(width: 15),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Version',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          '1.0.0',
                          style: TextStyle(color: Colors.white60, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                'Made with ❤️ for Horse Riders',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _infoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1F2A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white60,
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
