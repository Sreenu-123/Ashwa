import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/api_services.dart';

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
  // ============================================================
  // PROFILE DATA
  // ============================================================

  String name = 'Rider';
  String email = 'rider@example.com';
  String age = '20';
  String horseName = '';
  String ridingLevel = 'Beginner';

  String? profileImagePath;

  bool isLoading = true;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    loadProfileData();
  }

  // ============================================================
  // LOAD PROFILE DATA
  // ============================================================

  Future<void> loadProfileData() async {
    // First load local data.
    // This keeps horse name and profile image available.
    await loadLocalProfileData();

    // Then try loading authenticated user from backend.
    await loadBackendProfileData();

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  // ============================================================
  // LOAD LOCAL PROFILE DATA
  // ============================================================

  Future<void> loadLocalProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    final savedName = prefs.getString('profile_name');
    final savedEmail = prefs.getString('profile_email');
    final savedAge = prefs.getString('profile_age');
    final savedHorseName = prefs.getString('profile_horse_name');
    final savedRidingLevel = prefs.getString('profile_riding_level');

    // We store ONLY the filename in SharedPreferences.
    final savedImageName = prefs.getString('profile_image_name');

    String? imagePath;

    if (savedImageName != null && savedImageName.isNotEmpty) {
      final directory = await getApplicationSupportDirectory();

      final file = File('${directory.path}/$savedImageName');

      if (await file.exists()) {
        imagePath = file.path;
      }
    }

    if (!mounted) return;

    setState(() {
      // Local data is only used as fallback.
      if (savedName != null && savedName.isNotEmpty) {
        name = savedName;
      }

      if (savedEmail != null && savedEmail.isNotEmpty) {
        email = savedEmail;
      }

      if (savedAge != null && savedAge.isNotEmpty) {
        age = savedAge;
      }

      if (savedHorseName != null) {
        horseName = savedHorseName;
      }

      if (savedRidingLevel != null && savedRidingLevel.isNotEmpty) {
        ridingLevel = savedRidingLevel;
      }

      profileImagePath = imagePath;
    });

    debugPrint('Loaded local profile image: $imagePath');
  }

  // ============================================================
  // LOAD BACKEND PROFILE DATA
  // ============================================================

  Future<void> loadBackendProfileData() async {
    try {
      final currentUser = await ApiService.getCurrentUser();

      if (!mounted) return;

      setState(() {
        // Backend is now the source of truth
        // for authenticated user information.

        name = currentUser['full_name']?.toString() ?? name;

        email = currentUser['email']?.toString() ?? email;

        final backendAge = currentUser['age'];

        if (backendAge != null) {
          age = backendAge.toString();
        }

        ridingLevel = currentUser['riding_level']?.toString() ?? ridingLevel;
      });

      // Keep backend data locally as a fallback
      // for the profile screen.
      await saveProfileData();

      debugPrint('Backend profile loaded successfully.');
    } catch (e) {
      // Backend failure should NOT break the profile UI.
      // Existing local data will remain visible.

      debugPrint('Failed to load backend profile: $e');
    }
  }

  // ============================================================
  // SAVE PROFILE DATA LOCALLY
  // ============================================================

  Future<void> saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('profile_name', name);

    await prefs.setString('profile_email', email);

    await prefs.setString('profile_age', age);

    await prefs.setString('profile_horse_name', horseName);

    await prefs.setString('profile_riding_level', ridingLevel);
  }

  // ============================================================
  // SAVE PROFILE IMAGE PERMANENTLY
  // ============================================================

  Future<String?> saveProfileImage(String imagePath) async {
    try {
      final sourceFile = File(imagePath);

      if (!await sourceFile.exists()) {
        debugPrint('Source image does not exist.');

        return null;
      }

      final directory = await getApplicationSupportDirectory();

      const fileName = 'ashwa_profile_image.jpg';

      final permanentFile = File('${directory.path}/$fileName');

      // Read original image bytes.
      final imageBytes = await sourceFile.readAsBytes();

      // Write image bytes into permanent app storage.
      await permanentFile.writeAsBytes(imageBytes, flush: true);

      // Save ONLY filename.
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('profile_image_name', fileName);

      debugPrint(
        'Profile image permanently saved: '
        '${permanentFile.path}',
      );

      return permanentFile.path;
    } catch (e) {
      debugPrint('PROFILE IMAGE SAVE ERROR: $e');

      return null;
    }
  }

  // ============================================================
  // OPEN EDIT PROFILE
  // ============================================================

  Future<void> openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          name: name,
          email: email,
          age: age,
          horseName: horseName,
          ridingLevel: ridingLevel,
          currentProfileImagePath: profileImagePath,
        ),
      ),
    );

    if (result == null || result is! Map) {
      return;
    }

    // ----------------------------------------------------------
    // PROFILE DATA
    // ----------------------------------------------------------

    setState(() {
      name = result['name'] ?? name;
      email = result['email'] ?? email;
      age = result['age'] ?? age;
      horseName = result['horseName'] ?? horseName;
      ridingLevel = result['ridingLevel'] ?? ridingLevel;
    });

    // ----------------------------------------------------------
    // PROFILE IMAGE
    // ----------------------------------------------------------

    final returnedImagePath = result['profileImagePath'];

    if (returnedImagePath != null && returnedImagePath.toString().isNotEmpty) {
      final savedPath = await saveProfileImage(returnedImagePath.toString());

      if (savedPath != null && mounted) {
        setState(() {
          profileImagePath = savedPath;
        });
      }
    }

    // ----------------------------------------------------------
    // SAVE OTHER DATA
    // ----------------------------------------------------------

    await saveProfileData();
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

          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              // ==================================================
              // PROFILE IMAGE
              // ==================================================

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

              // ==================================================
              // NAME
              // ==================================================
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

              // ==================================================
              // STATS
              // ==================================================
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

              // ==================================================
              // EDIT PROFILE
              // ==================================================
              profileOption(
                context: context,
                icon: Icons.edit_outlined,
                title: 'Edit Profile',
                subtitle: 'Update your rider information',
                onTap: openEditProfile,
              ),

              const SizedBox(height: 12),

              // ==================================================
              // ACHIEVEMENTS
              // ==================================================
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

              // ==================================================
              // SETTINGS
              // ==================================================
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

              // ==================================================
              // ABOUT
              // ==================================================
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

  // ============================================================
  // PROFILE STAT
  // ============================================================

  Widget profileStat(BuildContext context, String value, String label) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        const SizedBox(height: 0),

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

  // ============================================================
  // PROFILE OPTION
  // ============================================================

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
