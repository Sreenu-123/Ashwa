import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Learn Riding",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Master horse riding step by step",
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),

              const SizedBox(height: 25),

              // Beginner
              lessonCard(
                icon: Icons.pets,
                title: "Beginner Basics",
                subtitle: "Start your riding journey",
                lessons: "3 Lessons",
              ),

              const SizedBox(height: 14),

              // Fundamentals
              lessonCard(
                icon: Icons.sports_handball,
                title: "Riding Fundamentals",
                subtitle: "Build your core riding skills",
                lessons: "3 Lessons",
              ),

              const SizedBox(height: 14),

              // Intermediate
              lessonCard(
                icon: Icons.track_changes,
                title: "Intermediate Riding",
                subtitle: "Improve your riding technique",
                lessons: "3 Lessons",
              ),

              const SizedBox(height: 14),

              // Advanced
              lessonCard(
                icon: Icons.emoji_events_outlined,
                title: "Advanced Riding",
                subtitle: "Take your skills to the next level",
                lessons: "3 Lessons",
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget lessonCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String lessons,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1F2A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.blue, size: 28),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),

                const SizedBox(height: 8),

                Text(
                  lessons,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 18),
        ],
      ),
    );
  }
}
