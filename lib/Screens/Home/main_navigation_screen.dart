import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'ride_screen.dart';
import 'progress_screen.dart';
import 'learn_screen.dart';
import 'profile_screen.dart';

class NavigationScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const NavigationScreen({super.key, required this.onThemeChanged});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int selectedIndex = 0;

  // ================= CHANGE TAB =================

  void changeTab(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // ================= NAVIGATION ITEM =================

  Widget navItem(BuildContext context, IconData icon, String label, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    final bool selected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: selected ? Colors.blue : colorScheme.onSurfaceVariant,
          ),

          const SizedBox(height: 4),

          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.blue : colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // ================= SCREENS =================

  List<Widget> get screens {
    return [
      HomeScreen(
        onRideTap: () {
          changeTab(1);
        },
        onLearnTap: () {
          changeTab(3);
        },
        onProgressTap: () {
          changeTab(2);
        },
      ),

      const RideScreen(),

      const ProgressScreen(),

      const LearnScreen(),

      ProfileScreen(onThemeChanged: widget.onThemeChanged),
    ];
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // ================= CURRENT SCREEN =================
      body: screens[selectedIndex],

      // ================= BOTTOM NAVIGATION =================
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navItem(context, Icons.home, 'Home', 0),

            navItem(context, Icons.videocam_outlined, 'AI Ride', 1),

            navItem(context, Icons.bar_chart, 'Progress', 2),

            navItem(context, Icons.menu_book_outlined, 'Learn', 3),

            navItem(context, Icons.person_outline, 'Profile', 4),
          ],
        ),
      ),
    );
  }
}
