import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Profile/settings_screen.dart';
import '../Profile/edit_profile_screen.dart';
import '../Profile/achievement_screen.dart';
import '../Profile/about_ashwa_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const ProfileScreen({super.key, required this.onThemeChanged});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ================= PROFILE DATA =================

  String name = 'Rider';
  String email = 'rider@example.com';
  String age = '20';
  String horseName = '';
  String ridingLevel = 'Beginner';

  // ================= PROFILE IMAGE =================

  String? profileImagePath;

  // ================= INIT =================

  @override
  void initState() {
    super.initState();

    loadProfile();
  }

  // ================= LOAD PROFILE =================

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      name = prefs.getString('profile_name') ?? 'Rider';

      email = prefs.getString('profile_email') ?? 'rider@example.com';

      age = prefs.getString('profile_age') ?? '20';

      horseName = prefs.getString('profile_horse_name') ?? '';

      ridingLevel = prefs.getString('profile_riding_level') ?? 'Beginner';

      profileImagePath = prefs.getString('profile_image_path');
    });
  }

  // ================= SAVE PROFILE =================

  Future<void> saveProfile(Map result) async {
    final prefs = await SharedPreferences.getInstance();

    final newName = result['name'] ?? name;
    final newEmail = result['email'] ?? email;
    final newAge = result['age'] ?? age;
    final newHorseName = result['horseName'] ?? horseName;
    final newRidingLevel = result['ridingLevel'] ?? ridingLevel;

    final newProfileImagePath = result['profileImagePath'] ?? profileImagePath;

    await prefs.setString('profile_name', newName);

    await prefs.setString('profile_email', newEmail);

    await prefs.setString('profile_age', newAge);

    await prefs.setString('profile_horse_name', newHorseName);

    await prefs.setString('profile_riding_level', newRidingLevel);

    if (newProfileImagePath != null) {
      await prefs.setString('profile_image_path', newProfileImagePath);
    }

    if (!mounted) return;

    setState(() {
      name = newName;
      email = newEmail;
      age = newAge;
      horseName = newHorseName;
      ridingLevel = newRidingLevel;
      profileImagePath = newProfileImagePath;
    });
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              // ================= PROFILE =================
              CircleAvatar(
                radius: 48,

                backgroundColor: colorScheme.surfaceContainer,

                backgroundImage:
                    profileImagePath != null &&
                        File(profileImagePath!).existsSync()
                    ? FileImage(File(profileImagePath!))
                    : null,

                child:
                    profileImagePath == null ||
                        !File(profileImagePath!).existsSync()
                    ? Icon(Icons.person, color: colorScheme.onSurface, size: 50)
                    : null,
              ),

              const SizedBox(height: 15),

              Text(
                name,

                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                '$ridingLevel Rider',

                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 25),

              // ================= STATS =================
              Container(
                width: double.infinity,

                padding: const EdgeInsets.symmetric(vertical: 20),

                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,

                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    profileStat(context, '12', 'Rides'),

                    profileStat(context, '8', 'Lessons'),

                    profileStat(context, '85%', 'Best Score'),

                    profileStat(context, '7 Days', 'Streaks'),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ================= EDIT PROFILE =================
              profileOption(
                context: context,

                icon: Icons.edit_outlined,

                title: 'Edit Profile',

                subtitle: 'Update your rider information',

                onTap: () async {
                  final result = await Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        name: name,
                        email: email,
                        age: age,
                        horseName: horseName,
                        ridingLevel: ridingLevel,
                      ),
                    ),
                  );

                  if (result != null && result is Map) {
                    await saveProfile(result);
                  }
                },
              ),

              const SizedBox(height: 12),

              // ================= ACHIEVEMENTS =================
              profileOption(
                context: context,

                icon: Icons.emoji_events_outlined,

                title: 'Achievements',

                subtitle: 'View your riding achievements',

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

              // ================= SETTINGS =================
              profileOption(
                context: context,

                icon: Icons.settings_outlined,

                title: 'Settings',

                subtitle: 'Manage your app preferences',

                onTap: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(
                        onThemeChanged: (mode) {
                          widget.onThemeChanged(mode);
                        },
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // ================= ABOUT =================
              profileOption(
                context: context,

                icon: Icons.info_outline,

                title: 'About ASHWA',

                subtitle: 'Learn more about ASHWA',

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

  // ================= PROFILE STAT =================

  Widget profileStat(BuildContext context, String value, String label) {
    final colorScheme = Theme.of(context).colorScheme;

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

          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
        ),
      ],
    );
  }

  // ================= PROFILE OPTION =================

  Widget profileOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(17),

        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(color: colorScheme.outlineVariant),
        ),

        child: Row(
          children: [
            // ================= ICON =================
            Container(
              width: 48,
              height: 48,

              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.15),

                borderRadius: BorderRadius.circular(14),
              ),

              child: Icon(icon, color: Colors.blue, size: 24),
            ),

            const SizedBox(width: 15),

            // ================= TEXT =================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,

                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // ================= ARROW =================
            Icon(
              Icons.arrow_forward_ios,
              color: colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
