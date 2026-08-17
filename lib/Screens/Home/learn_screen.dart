import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

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
              Text(
                'Learn Riding',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Master horse riding step by step',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 25),

              // ================= BEGINNER =================
              lessonCard(
                context: context,
                icon: Icons.pets,
                title: 'Beginner Basics',
                subtitle: 'Start your riding journey',
                lessons: '3 Lessons',
              ),

              const SizedBox(height: 14),

              // ================= FUNDAMENTALS =================
              lessonCard(
                context: context,
                icon: Icons.sports_handball,
                title: 'Riding Fundamentals',
                subtitle: 'Build your core riding skills',
                lessons: '3 Lessons',
              ),

              const SizedBox(height: 14),

              // ================= INTERMEDIATE =================
              lessonCard(
                context: context,
                icon: Icons.track_changes,
                title: 'Intermediate Riding',
                subtitle: 'Improve your riding technique',
                lessons: '3 Lessons',
              ),

              const SizedBox(height: 14),

              // ================= ADVANCED =================
              lessonCard(
                context: context,
                icon: Icons.emoji_events_outlined,
                title: 'Advanced Riding',
                subtitle: 'Take your skills to the next level',
                lessons: '3 Lessons',
              ),

              const SizedBox(height: 14),

              // ================= HORSE CARE =================
              lessonCard(
                context: context,
                icon: Icons.pets_outlined,
                title: 'Horse Care',
                subtitle: 'Learn how to care for your horse',
                lessons: '3 Lessons',
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ================= LESSON CARD =================

  Widget lessonCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String lessons,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          // ================= ICON =================
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.blue, size: 28),
          ),

          const SizedBox(width: 15),

          // ================= CONTENT =================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
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

          // ================= ARROW =================
          Icon(
            Icons.arrow_forward_ios,
            color: colorScheme.onSurfaceVariant,
            size: 18,
          ),
        ],
      ),
    );
  }
}
