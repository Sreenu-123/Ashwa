import 'dart:async';

import 'package:flutter/material.dart';

class RideScreen extends StatefulWidget {
  const RideScreen({super.key});

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  // ================= RIDE STATE =================

  bool isRideActive = false;

  Timer? rideTimer;
  int rideSeconds = 0;

  // ================= START RIDE =================

  void startRide() {
    setState(() {
      isRideActive = true;
      rideSeconds = 0;
    });

    rideTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        rideSeconds++;
      });
    });
  }

  // ================= STOP RIDE =================

  void stopRide() {
    rideTimer?.cancel();

    setState(() {
      isRideActive = false;
    });
  }

  // ================= FORMAT TIME =================

  String get formattedTime {
    final hours = rideSeconds ~/ 3600;
    final minutes = (rideSeconds % 3600) ~/ 60;
    final seconds = rideSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    rideTimer?.cancel();
    super.dispose();
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ================= TOP BAR =================
                Row(
                  children: [
                    const SizedBox(width: 4),

                    Text(
                      'AI Ride',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    if (isRideActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: const Row(
                          children: [
                            Icon(Icons.circle, color: Colors.red, size: 8),

                            SizedBox(width: 6),

                            Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                    IconButton(
                      onPressed: () {},

                      icon: Icon(
                        Icons.settings_outlined,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ================= CAMERA AREA =================
                Container(
                  width: double.infinity,
                  height: 420,

                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isRideActive
                          ? Colors.blue.withValues(alpha: 0.5)
                          : colorScheme.outlineVariant,
                    ),
                  ),

                  child: isRideActive
                      ? _activeRideView(context)
                      : _cameraReadyView(context),
                ),

                const SizedBox(height: 20),

                // ================= TIMER =================
                if (isRideActive) ...[
                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.symmetric(vertical: 16),

                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),

                    child: Column(
                      children: [
                        Text(
                          'Ride Duration',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          formattedTime,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ================= LIVE SCORES =================
                  Text(
                    'Live Analysis',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _scoreCard(
                          context,
                          'Posture',
                          '84%',
                          Icons.accessibility_new,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _scoreCard(
                          context,
                          'Balance',
                          '79%',
                          Icons.balance,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: _scoreCard(
                          context,
                          'Leg Position',
                          '82%',
                          Icons.directions_walk,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _scoreCard(
                          context,
                          'Overall',
                          '82%',
                          Icons.auto_awesome,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],

                // ================= START / STOP BUTTON =================
                SizedBox(
                  width: double.infinity,
                  height: 60,

                  child: ElevatedButton(
                    onPressed: isRideActive ? stopRide : startRide,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRideActive ? Colors.red : Colors.blue,

                      foregroundColor: Colors.white,

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(
                          isRideActive
                              ? Icons.stop_rounded
                              : Icons.play_arrow_rounded,
                        ),

                        const SizedBox(width: 8),

                        Text(
                          isRideActive ? 'Stop Ride' : 'Start AI Ride',

                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ================= AI COACHING CARD =================
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
                          color: Colors.blue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.blue,
                          size: 26,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              isRideActive
                                  ? 'AI Coaching Active'
                                  : 'AI Coaching',

                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              isRideActive
                                  ? 'Analysing riding posture and balance in real time.'
                                  : 'Get real-time riding feedback and posture analysis.',

                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= CAMERA READY VIEW =================

  Widget _cameraReadyView(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Container(
          width: 80,
          height: 80,

          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),

          child: const Icon(
            Icons.videocam_outlined,
            color: Colors.blue,
            size: 40,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'Camera Ready',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Position the rider and horse\ninside the frame',
          textAlign: TextAlign.center,

          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
        ),
      ],
    );
  }

  // ================= ACTIVE RIDE VIEW =================

  Widget _activeRideView(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                width: 85,
                height: 85,

                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),

                child: const Icon(Icons.videocam, color: Colors.blue, size: 42),
              ),

              const SizedBox(height: 20),

              Text(
                'AI Ride Active',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'AI is analysing your riding...',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        Positioned(
          top: 16,
          left: 16,

          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),

            child: const Row(
              children: [
                Icon(Icons.circle, color: Colors.red, size: 8),

                SizedBox(width: 6),

                Text(
                  'RECORDING',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ================= SCORE CARD =================

  Widget _scoreCard(
    BuildContext context,
    String title,
    String score,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),

      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  score,

                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
