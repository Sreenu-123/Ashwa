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
  // ============================================================
  // SELECTED TAB
  // ============================================================

  int selectedIndex = 0;

  // ============================================================
  // CHANGE TAB
  // ============================================================

  void changeTab(int index) {
    if (selectedIndex == index) return;

    setState(() {
      selectedIndex = index;
    });
  }

  // ============================================================
  // NAVIGATION ITEM
  // ============================================================

  Widget navItem(BuildContext context, IconData icon, String label, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => changeTab(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.blue : colorScheme.onSurfaceVariant,
            ),

            const SizedBox(height: 4),

            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected ? Colors.blue : colorScheme.onSurfaceVariant,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SCREENS
  // ============================================================

  List<Widget> get screens {
    return [
      HomeScreen(
        onRideTap: () => changeTab(1),
        onLearnTap: () => changeTab(3),
        onProgressTap: () => changeTab(2),
      ),

      const RideScreen(),

      const ProgressScreen(),

      const LearnScreen(),

      ProfileScreen(onThemeChanged: widget.onThemeChanged),
    ];
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // ========================================================
      // CURRENT SCREEN
      // ========================================================
      body: IndexedStack(index: selectedIndex, children: screens),

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              navItem(context, Icons.home_outlined, 'Home', 0),

              navItem(context, Icons.videocam_outlined, 'AI Ride', 1),

              navItem(context, Icons.bar_chart_outlined, 'Progress', 2),

              navItem(context, Icons.menu_book_outlined, 'Learn', 3),

              navItem(context, Icons.person_outline, 'Profile', 4),
            ],
          ),
        ),
      ),
    );
  }
}
