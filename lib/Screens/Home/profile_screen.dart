import 'package:flutter/material.dart';
import '../Profile/settings_screen.dart';
import '../Profile/edit_profile_screen.dart';
import '../Profile/achievement_screen.dart';
import '../Profile/about_ashwa_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;
  const ProfileScreen({super.key, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile
              const CircleAvatar(
                radius: 48,
                backgroundColor: Color(0xFF1B1F2A),
                child: Icon(Icons.person, color: Colors.white, size: 50),
              ),

              const SizedBox(height: 15),

              const Text(
                "Rider",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Beginner Rider",
                style: TextStyle(color: Colors.white60, fontSize: 15),
              ),

              const SizedBox(height: 25),

              // Stats
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1F2A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    profileStat("12", "Rides"),
                    profileStat("8", "Lessons"),
                    profileStat("85%", "Best Score"),
                    profileStat("7 Days", "Streaks"),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Edit Profile
              profileOption(
                icon: Icons.edit_outlined,
                title: "Edit Profile",
                subtitle: "Update your rider information",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // Achievements
              profileOption(
                icon: Icons.emoji_events_outlined,
                title: "Achievements",
                subtitle: "View your riding achievements",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AchievementsScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // Settings
              profileOption(
                icon: Icons.settings_outlined,
                title: "Settings",
                subtitle: "Manage your app preferences",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(
                        onThemeChanged: (mode) {
                          onThemeChanged(mode);
                          // Handle theme change if needed
                        },
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // About
              profileOption(
                icon: Icons.info_outline,
                title: "About ASHWA",
                subtitle: "Learn more about ASHWA",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutAshwaScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 13),
        ),
      ],
    );
  }

  Widget profileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1F2A),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.blue, size: 24),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
