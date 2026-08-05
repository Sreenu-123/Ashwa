import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'ride_screen.dart';
import 'progress_screen.dart';
import 'learn_screen.dart';
import 'profile_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  Widget navItem(IconData icon, String label, int index) {
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
          Icon(icon, color: selected ? Colors.blue : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.blue : Colors.grey,
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  int selectedIndex = 0;
  void changeTab(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> get screens {
    return [
      HomeScreen(
        onRideTap: () {
          changeTab(1);
        },
      ),
      const RideScreen(),
      const ProgressScreen(),
      const LearnScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: screens[selectedIndex],

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navItem(Icons.home, "Home", 0),
            navItem(Icons.videocam_outlined, "AI Ride", 1),
            navItem(Icons.bar_chart, "Progress", 2),
            navItem(Icons.menu_book_outlined, "Learn", 3),
            navItem(Icons.person_outline, "Profile", 4),
          ],
        ),
      ),
    );
  }
}
