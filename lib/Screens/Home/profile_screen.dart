import 'package:flutter/material.dart';

import '../../services/api_services.dart';
import '../Profile/settings_screen.dart';
import '../Profile/edit_profile_screen.dart';
import '../Profile/achievement_screen.dart';
import '../Profile/about_ashwa_screen.dart';
import '../Profile/horse_screen.dart';
import '../Profile/ride_history_screen.dart';

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

  Map<String, dynamic>? userData;

  bool isLoading = true;
  String? errorMessage;

  // ============================================================
  // PROFILE IMAGE CACHE VERSION
  // ============================================================

  /*
   * Backend replaces the same image filename.
   *
   * Example:
   * /uploads/profile_images/user_2.jpg
   *
   * Flutter may keep the old image in cache.
   *
   * Adding ?v=timestamp forces Flutter to request
   * the latest image from the backend.
   */
  int _profileImageVersion = DateTime.now().millisecondsSinceEpoch;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  // ============================================================
  // LOAD PROFILE
  // ============================================================

  Future<void> loadProfile() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final data = await ApiService.getCurrentUser();

      debugPrint('Profile data: $data');

      if (!mounted) return;

      setState(() {
        userData = Map<String, dynamic>.from(data);

        // Generate a new cache version every time
        // fresh profile data is loaded.
        _profileImageVersion = DateTime.now().millisecondsSinceEpoch;

        isLoading = false;
      });
    } catch (e) {
      debugPrint('Profile loading failed: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  // ============================================================
  // USER DATA HELPERS
  // ============================================================

  String get name {
    final value = userData?['full_name']?.toString().trim();

    if (value == null || value.isEmpty) {
      return 'Rider';
    }

    return value;
  }

  String get ridingLevel {
    final value = userData?['riding_level']?.toString().trim();

    if (value == null || value.isEmpty) {
      return '';
    }

    return value;
  }

  String get horseName {
    final value = userData?['horse_name']?.toString().trim();

    if (value == null || value.isEmpty) {
      return '';
    }

    return value;
  }

  // ============================================================
  // PROFILE IMAGE URL
  // ============================================================

  String? get profileImageUrl {
    final image = userData?['profile_image']?.toString().trim();

    if (image == null || image.isEmpty) {
      return null;
    }

    String baseUrl;

    if (image.startsWith('http://') || image.startsWith('https://')) {
      baseUrl = image;
    } else {
      baseUrl = '${ApiService.baseUrl}$image';
    }

    // Cache busting
    return '$baseUrl?v=$_profileImageVersion';
  }

  // ============================================================
  // OPEN EDIT PROFILE
  // ============================================================

  Future<void> openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );

    /*
     * EditProfileScreen returns true after successful save.
     *
     * Reload backend data so:
     * - name updates
     * - riding level updates
     * - horse name updates
     * - profile image updates
     */

    if (result == true) {
      await loadProfile();
    }
  }

  // ============================================================
  // OPEN HORSE
  // ============================================================

  Future<void> openHorseScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HorseScreen(horseName: horseName),
      ),
    );
  }

  // ============================================================
  // OPEN RIDE HISTORY
  // ============================================================

  Future<void> openRideHistory() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RideHistoryScreen()),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.all(20),
            child: isLoading
                ? const SizedBox(
                    height: 600,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    ),
                  )
                : errorMessage != null
                ? _buildErrorState()
                : _buildProfileContent(),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState() {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 600,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 55,
              color: colorScheme.onSurfaceVariant,
            ),

            const SizedBox(height: 16),

            Text(
              'Unable to load profile',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              errorMessage ?? 'Something went wrong.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loadProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE CONTENT
  // ============================================================

  Widget _buildProfileContent() {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // ========================================================
        // PROFILE IMAGE
        // ========================================================

        CircleAvatar(
          radius: 50,
          backgroundColor: colorScheme.surfaceContainer,
          backgroundImage: profileImageUrl != null
              ? NetworkImage(profileImageUrl!)
              : null,
          child: profileImageUrl == null
              ? Icon(Icons.person, color: colorScheme.onSurface, size: 52)
              : null,
        ),

        const SizedBox(height: 15),

        // ========================================================
        // USER NAME
        // ========================================================
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          ridingLevel.isEmpty ? 'Rider' : '$ridingLevel Rider',
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 15),
        ),

        const SizedBox(height: 25),

        // ========================================================
        // STATS
        // ========================================================
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
              profileStat('12', 'Rides'),
              profileStat('8', 'Lessons'),
              profileStat('85%', 'Best Score'),
              profileStat('7 Days', 'Streaks'),
            ],
          ),
        ),

        const SizedBox(height: 25),

        // ========================================================
        // EDIT PROFILE
        // ========================================================
        profileOption(
          icon: Icons.edit_outlined,
          title: 'Edit Profile',
          subtitle: 'Update your rider information',
          onTap: openEditProfile,
        ),

        const SizedBox(height: 12),

        // ========================================================
        // MY HORSE
        // ========================================================
        profileOption(
          icon: Icons.pets_outlined,
          title: 'My Horse',
          subtitle: horseName.isEmpty
              ? 'Add your horse information'
              : 'View $horseName',
          onTap: openHorseScreen,
        ),

        const SizedBox(height: 12),

        // ========================================================
        // RIDE HISTORY
        // ========================================================
        profileOption(
          icon: Icons.history_rounded,
          title: 'Ride History',
          subtitle: 'View your completed rides',
          onTap: openRideHistory,
        ),

        const SizedBox(height: 12),

        // ========================================================
        // ACHIEVEMENTS
        // ========================================================
        profileOption(
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

        // ========================================================
        // SETTINGS
        // ========================================================
        profileOption(
          icon: Icons.settings_outlined,
          title: 'Settings',
          subtitle: 'Manage your app preferences',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SettingsScreen(onThemeChanged: widget.onThemeChanged),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        // ========================================================
        // ABOUT ASHWA
        // ========================================================
        profileOption(
          icon: Icons.info_outline,
          title: 'About ASHWA',
          subtitle: 'Learn more about ASHWA',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutAshwaScreen()),
            );
          },
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  // ============================================================
  // PROFILE STAT
  // ============================================================

  Widget profileStat(String value, String label) {
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

  // ============================================================
  // PROFILE OPTION
  // ============================================================

  Widget profileOption({
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

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
