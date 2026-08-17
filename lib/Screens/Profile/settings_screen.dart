import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const SettingsScreen({super.key, required this.onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool voiceCoaching = true;
  bool notifications = true;

  String units = 'Metric';
  String language = 'English';
  String appearance = 'Dark';
  String voiceLanguage = 'English';
  String coachingLevel = 'Intermediate';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: colorScheme.onSurface,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 4),

                  Text(
                    'Settings',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ================= GENERAL =================
              sectionTitle('General'),

              settingsCard(
                children: [
                  settingsTile(
                    icon: Icons.person_outline,
                    title: 'Profile Information',
                    trailing: Icon(
                      Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {},
                  ),

                  divider(),

                  settingsTile(
                    icon: Icons.straighten,
                    title: 'Units',
                    trailingText: units,
                    onTap: () {
                      showSelectionDialog(
                        title: 'Units',
                        options: ['Metric', 'Imperial'],
                        selectedValue: units,
                        onSelected: (value) {
                          setState(() {
                            units = value;
                          });
                        },
                      );
                    },
                  ),

                  divider(),

                  settingsTile(
                    icon: Icons.language,
                    title: 'Language',
                    trailingText: language,
                    onTap: () {
                      showSelectionDialog(
                        title: 'Language',
                        options: ['English', 'Malayalam'],
                        selectedValue: language,
                        onSelected: (value) {
                          setState(() {
                            language = value;
                          });
                        },
                      );
                    },
                  ),

                  divider(),

                  settingsTile(
                    icon: Icons.brightness_6_outlined,
                    title: 'Appearance',
                    trailingText: appearance,
                    onTap: () {
                      showSelectionDialog(
                        title: 'Appearance',
                        options: ['Dark', 'Light', 'System'],
                        selectedValue: appearance,
                        onSelected: (value) {
                          setState(() {
                            appearance = value;
                          });

                          if (value == 'Dark') {
                            widget.onThemeChanged(ThemeMode.dark);
                          } else if (value == 'Light') {
                            widget.onThemeChanged(ThemeMode.light);
                          } else {
                            widget.onThemeChanged(ThemeMode.system);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ================= AI COACHING =================
              sectionTitle('AI Coaching'),

              settingsCard(
                children: [
                  settingsTile(
                    icon: Icons.mic_none,
                    title: 'Voice Coaching',
                    trailing: Switch(
                      value: voiceCoaching,
                      onChanged: (value) {
                        setState(() {
                          voiceCoaching = value;
                        });
                      },
                    ),
                  ),

                  divider(),

                  settingsTile(
                    icon: Icons.record_voice_over_outlined,
                    title: 'Voice Language',
                    trailingText: voiceLanguage,
                    onTap: () {
                      showSelectionDialog(
                        title: 'Voice Language',
                        options: ['English', 'Malayalam'],
                        selectedValue: voiceLanguage,
                        onSelected: (value) {
                          setState(() {
                            voiceLanguage = value;
                          });
                        },
                      );
                    },
                  ),

                  divider(),

                  settingsTile(
                    icon: Icons.psychology_outlined,
                    title: 'Coaching Level',
                    trailingText: coachingLevel,
                    onTap: () {
                      showSelectionDialog(
                        title: 'Coaching Level',
                        options: ['Beginner', 'Intermediate', 'Advanced'],
                        selectedValue: coachingLevel,
                        onSelected: (value) {
                          setState(() {
                            coachingLevel = value;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ================= OTHER =================
              sectionTitle('Other'),

              settingsCard(
                children: [
                  settingsTile(
                    icon: Icons.notifications_none,
                    title: 'Notifications',
                    trailing: Switch(
                      value: notifications,
                      onChanged: (value) {
                        setState(() {
                          notifications = value;
                        });
                      },
                    ),
                  ),

                  divider(),

                  settingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    trailing: Icon(
                      Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {},
                  ),

                  divider(),

                  settingsTile(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    trailing: Icon(
                      Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {},
                  ),

                  divider(),

                  settingsTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    trailing: Icon(
                      Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ================= ABOUT =================
              sectionTitle('About'),

              settingsCard(
                children: [
                  settingsTile(
                    icon: Icons.info_outline,
                    title: 'About ASHWA',
                    trailing: Icon(
                      Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {},
                  ),

                  divider(),

                  settingsTile(
                    icon: Icons.system_update_outlined,
                    title: 'App Version',
                    trailingText: '1.0.0',
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ================= ACCOUNT =================
              sectionTitle('Account'),

              GestureDetector(
                onTap: () {
                  showLogoutDialog();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 17,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.red.withOpacity(0.25)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.logout, color: Colors.redAccent),
                      SizedBox(width: 15),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ================= APP NAME =================
              Center(
                child: Text(
                  'ASHWA AI',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.35),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ================= SECTION TITLE =================

  Widget sectionTitle(String title) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ================= SETTINGS CARD =================

  Widget settingsCard({required List<Widget> children}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(children: children),
    );
  }

  // ================= SETTINGS TILE =================

  Widget settingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    String? trailingText,
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.blue, size: 21),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            if (trailingText != null)
              Text(
                trailingText,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),

            if (trailing != null) ...[const SizedBox(width: 8), trailing],
          ],
        ),
      ),
    );
  }

  // ================= DIVIDER =================

  Widget divider() {
    final colorScheme = Theme.of(context).colorScheme;

    return Divider(
      height: 1,
      color: colorScheme.outlineVariant,
      indent: 16,
      endIndent: 16,
    );
  }

  // ================= SELECTION DIALOG =================

  void showSelectionDialog({
    required String title,
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,

          title: Text(title, style: TextStyle(color: colorScheme.onSurface)),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return RadioListTile<String>(
                value: option,
                groupValue: selectedValue,
                activeColor: Colors.blue,

                title: Text(
                  option,
                  style: TextStyle(color: colorScheme.onSurface),
                ),

                onChanged: (value) {
                  if (value != null) {
                    onSelected(value);
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // ================= LOGOUT DIALOG =================

  void showLogoutDialog() {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,

          title: Text('Logout', style: TextStyle(color: colorScheme.onSurface)),

          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}
