import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/api_services.dart';

class RideScreen extends StatefulWidget {
  const RideScreen({super.key});

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  // ============================================================
  // RIDE SETUP
  // ============================================================

  String horseName = '';
  String? selectedDiscipline;

  bool isLoadingHorse = true;
  bool isRideActive = false;

  // ============================================================
  // RIDE TIMER
  // ============================================================

  Timer? rideTimer;
  int rideSeconds = 0;

  // ============================================================
  // DISCIPLINES
  // ============================================================

  final List<String> disciplineOptions = [
    'Dressage',
    'Show Jumping',
    'Eventing',
    'Endurance',
    'Western Riding',
    'Leisure Riding',
  ];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    loadHorse();
  }

  // ============================================================
  // LOAD CURRENT HORSE
  // ============================================================

  Future<void> loadHorse() async {
    try {
      final currentUser = await ApiService.getCurrentUser();

      if (!mounted) return;

      setState(() {
        horseName = currentUser['horse_name']?.toString() ?? '';
        isLoadingHorse = false;
      });

      debugPrint('Ride screen horse: $horseName');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingHorse = false;
      });

      debugPrint('Failed to load horse: $e');
    }
  }

  // ============================================================
  // START RIDE
  // ============================================================

  void startRide() {
    if (horseName.isEmpty) {
      showMessage('Please add a horse to your profile first.');
      return;
    }

    if (selectedDiscipline == null) {
      showMessage('Please select a riding discipline.');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isRideActive = true;
      rideSeconds = 0;
    });

    rideTimer?.cancel();

    rideTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        rideSeconds++;
      });
    });
  }

  // ============================================================
  // END RIDE
  // ============================================================

  void endRide() {
    rideTimer?.cancel();

    setState(() {
      isRideActive = false;
    });

    showRideSummary();
  }

  // ============================================================
  // RIDE SUMMARY
  // ============================================================

  void showRideSummary() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return Container(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 30),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // HANDLE
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 24),

                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.blue,
                  size: 55,
                ),

                const SizedBox(height: 15),

                Text(
                  'Ride Completed',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Great work! Here is your ride summary.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 25),

                summaryRow(context, Icons.pets_outlined, 'Horse', horseName),

                const SizedBox(height: 12),

                summaryRow(
                  context,
                  Icons.sports_score_outlined,
                  'Discipline',
                  selectedDiscipline ?? '-',
                ),

                const SizedBox(height: 12),

                summaryRow(
                  context,
                  Icons.timer_outlined,
                  'Duration',
                  formattedTime,
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      setState(() {
                        rideSeconds = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // FORMAT TIME
  // ============================================================

  String get formattedTime {
    final hours = rideSeconds ~/ 3600;

    final minutes = (rideSeconds % 3600) ~/ 60;

    final seconds = rideSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    rideTimer?.cancel();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

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
              // ==================================================
              // HEADER
              // ==================================================

              Row(
                children: [
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
                    onPressed: () {
                      showMessage('Ride settings will be available soon.');
                    },
                    icon: Icon(
                      Icons.settings_outlined,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // ==================================================
              // RIDE SETUP
              // ==================================================
              if (!isRideActive) _rideSetupCard(context),

              if (!isRideActive) const SizedBox(height: 20),

              // ==================================================
              // CAMERA AREA
              // ==================================================
              Container(
                width: double.infinity,
                height: 390,

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

              // ==================================================
              // ACTIVE RIDE DATA
              // ==================================================
              if (isRideActive) ...[
                _rideTimerCard(context),

                const SizedBox(height: 22),

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

                const SizedBox(height: 22),
              ],

              // ==================================================
              // START / END BUTTON
              // ==================================================
              SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton(
                  onPressed: isRideActive ? endRide : startRide,

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
                        isRideActive ? 'End Ride' : 'Start AI Ride',
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

              // ==================================================
              // AI COACHING CARD
              // ==================================================
              _aiCoachingCard(context),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // RIDE SETUP CARD
  // ============================================================

  Widget _rideSetupCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // TITLE
          Row(
            children: [
              Container(
                width: 44,
                height: 44,

                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(13),
                ),

                child: const Icon(
                  Icons.settings_suggest_outlined,
                  color: Colors.blue,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ride Setup',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    'Prepare your riding session',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ==================================================
          // HORSE
          // ==================================================
          Text(
            'Horse',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),

            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colorScheme.outlineVariant),
            ),

            child: Row(
              children: [
                const Icon(Icons.pets_outlined, color: Colors.blue),

                const SizedBox(width: 12),

                Expanded(
                  child: isLoadingHorse
                      ? Text(
                          'Loading horse...',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        )
                      : Text(
                          horseName.isEmpty ? 'No horse added' : horseName,
                          style: TextStyle(
                            color: horseName.isEmpty
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),

                if (!isLoadingHorse && horseName.isNotEmpty)
                  const Icon(Icons.check_circle, color: Colors.blue, size: 20),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ==================================================
          // DISCIPLINE
          // ==================================================
          Text(
            'Discipline',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          DropdownButtonFormField<String>(
            value: selectedDiscipline,

            isExpanded: true,

            decoration: InputDecoration(
              hintText: 'Select riding discipline',

              hintStyle: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),

              prefixIcon: const Icon(
                Icons.sports_score_outlined,
                color: Colors.blue,
              ),

              filled: true,

              fillColor: colorScheme.surface,

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
            ),

            dropdownColor: colorScheme.surface,

            items: disciplineOptions
                .map(
                  (discipline) => DropdownMenuItem(
                    value: discipline,
                    child: Text(
                      discipline,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ),
                )
                .toList(),

            onChanged: (value) {
              setState(() {
                selectedDiscipline = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TIMER CARD
  // ============================================================

  Widget _rideTimerCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 17),

      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),

      child: Column(
        children: [
          Text(
            'Ride Duration',
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
          ),

          const SizedBox(height: 5),

          Text(
            formattedTime,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            '$horseName • ${selectedDiscipline ?? ''}',
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CAMERA READY VIEW
  // ============================================================

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
          'Start a ride to begin AI analysis',
          textAlign: TextAlign.center,
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
        ),
      ],
    );
  }

  // ============================================================
  // ACTIVE RIDE VIEW
  // ============================================================

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

              const SizedBox(height: 12),

              Text(
                '$horseName • ${selectedDiscipline ?? ''}',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
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

  // ============================================================
  // AI COACHING CARD
  // ============================================================

  Widget _aiCoachingCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
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

            child: const Icon(Icons.auto_awesome, color: Colors.blue, size: 26),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  isRideActive ? 'AI Coaching Active' : 'AI Coaching',
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
    );
  }

  // ============================================================
  // SCORE CARD
  // ============================================================

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

  // ============================================================
  // SUMMARY ROW
  // ============================================================

  Widget summaryRow(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 22),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
