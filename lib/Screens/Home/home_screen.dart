import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onRideTap;
  final VoidCallback onLearnTap;
  final VoidCallback onProgressTap;

  const HomeScreen({
    super.key,
    required this.onRideTap,
    required this.onLearnTap,
    required this.onProgressTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================================
              // HEADER
              // ============================================================
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, Rider 👋',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'Ready for your next ride?',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Notification
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_none,
                        color: colorScheme.onSurface,
                        size: 23,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // ============================================================
              // START A RIDE
              // ============================================================
              GestureDetector(
                onTap: widget.onRideTap,

                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),

                    // Blue accent
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.45),
                      width: 1.2,
                    ),
                  ),

                  child: Row(
                    children: [
                      // Icon
                      Container(
                        width: 50,
                        height: 50,

                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.blue,
                          size: 27,
                        ),
                      ),

                      const SizedBox(width: 15),

                      // Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start a Ride',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              'Get real-time AI riding coaching',
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
                        size: 17,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ============================================================
              // LEARN RIDING
              // ============================================================
              GestureDetector(
                onTap: widget.onLearnTap,

                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),

                  child: Row(
                    children: [
                      // Icon
                      Container(
                        width: 50,
                        height: 50,

                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: const Icon(
                          Icons.menu_book_outlined,
                          color: Colors.blue,
                          size: 27,
                        ),
                      ),

                      const SizedBox(width: 15),

                      // Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Learn Riding',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              'Improve your riding skills step by step',
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
                        size: 17,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ============================================================
              // TODAY'S SCORE
              // ============================================================
              Row(
                children: [
                  Text(
                    "Today's Score",
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  GestureDetector(
                    onTap: widget.onProgressTap,

                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Score Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),

                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    scoreItem(
                      context: context,
                      icon: Icons.accessibility_new,
                      value: '85%',
                      label: 'Posture',
                    ),

                    scoreItem(
                      context: context,
                      icon: Icons.balance,
                      value: '78%',
                      label: 'Balance',
                    ),

                    scoreItem(
                      context: context,
                      icon: Icons.directions_walk,
                      value: '82%',
                      label: 'Leg Position',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ============================================================
              // STREAK CARD
              // ============================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),

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
                        color: Colors.orange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 27,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '7 Day Riding Streak',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            'Keep the momentum going!',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ============================================================
              // QUICK PROGRESS
              // ============================================================
              GestureDetector(
                onTap: widget.onProgressTap,

                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),

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

                        child: const Icon(
                          Icons.trending_up,
                          color: Colors.blue,
                          size: 27,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Track Your Progress',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              'View your riding performance and improvement.',
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  Widget scoreItem({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),

          child: Icon(icon, color: Colors.blue, size: 21),
        ),

        const SizedBox(height: 8),

        Text(
          value,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 11),
        ),
      ],
    );
  }
}
