import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 21,
          ),
        ),

        title: Text(
          'Achievements',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: false,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Text(
                'Your Achievements',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Keep riding and unlock new achievements.',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 25),

              // ================= ACHIEVEMENT STATS =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 22,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    achievementStat(
                      context: context,
                      value: '8',
                      label: 'Unlocked',
                    ),
                    achievementStat(
                      context: context,
                      value: '12',
                      label: 'Total',
                    ),
                    achievementStat(
                      context: context,
                      value: '67%',
                      label: 'Progress',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ================= ACHIEVEMENTS TITLE =================
              Text(
                'Achievements',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // ================= ACHIEVEMENT CARDS =================
              achievementCard(
                context: context,
                icon: Icons.directions_walk,
                title: 'First Ride',
                subtitle: 'Complete your first riding session',
                progress: 1.0,
                progressText: 'Completed',
                unlocked: true,
              ),

              const SizedBox(height: 12),

              achievementCard(
                context: context,
                icon: Icons.local_fire_department,
                title: 'Ride Streak',
                subtitle: 'Ride for 7 days in a row',
                progress: 1.0,
                progressText: '7 / 7 Days',
                unlocked: true,
              ),

              const SizedBox(height: 12),

              achievementCard(
                context: context,
                icon: Icons.school_outlined,
                title: 'Quick Learner',
                subtitle: 'Complete 5 riding lessons',
                progress: 0.8,
                progressText: '4 / 5 Lessons',
                unlocked: false,
              ),

              const SizedBox(height: 12),

              achievementCard(
                context: context,
                icon: Icons.emoji_events_outlined,
                title: 'Perfect Score',
                subtitle: 'Achieve a riding score above 90%',
                progress: 0.85,
                progressText: '85 / 90%',
                unlocked: false,
              ),

              const SizedBox(height: 12),

              achievementCard(
                context: context,
                icon: Icons.auto_awesome,
                title: 'Riding Master',
                subtitle: 'Complete 25 riding sessions',
                progress: 0.48,
                progressText: '12 / 25 Rides',
                unlocked: false,
              ),

              const SizedBox(height: 12),

              achievementCard(
                context: context,
                icon: Icons.workspace_premium_outlined,
                title: 'Elite Rider',
                subtitle: 'Reach advanced riding level',
                progress: 0.35,
                progressText: '35%',
                unlocked: false,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ================= ACHIEVEMENT STAT =================

  static Widget achievementStat({
    required BuildContext context,
    required String value,
    required String label,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        const SizedBox(height: 2),

        Text(
          value,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 22,
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

  // ================= ACHIEVEMENT CARD =================

  static Widget achievementCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required double progress,
    required String progressText,
    required bool unlocked,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: unlocked
              ? Colors.blue.withValues(alpha: 0.35)
              : colorScheme.outlineVariant,
        ),
      ),

      child: Row(
        children: [
          // ================= ICON =================
          Container(
            width: 55,
            height: 55,

            decoration: BoxDecoration(
              color: unlocked
                  ? Colors.blue.withValues(alpha: 0.15)
                  : colorScheme.onSurface.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Icon(
              icon,
              color: unlocked ? Colors.blue : colorScheme.onSurfaceVariant,
              size: 28,
            ),
          ),

          const SizedBox(width: 15),

          // ================= CONTENT =================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    if (unlocked)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                  ],
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 12),

                // ================= PROGRESS =================
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),

                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,

                          backgroundColor: colorScheme.onSurface.withValues(
                            alpha: 0.08,
                          ),

                          color: unlocked ? Colors.green : Colors.blue,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Text(
                      progressText,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
