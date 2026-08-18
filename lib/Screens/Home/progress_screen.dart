import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // ============================================================
  // SELECTED PERIOD
  // ============================================================

  String selectedPeriod = 'Month';

  // ============================================================
  // PERIOD CHANGE
  // ============================================================

  void changePeriod(String period) {
    setState(() {
      selectedPeriod = period;
    });
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
              // ============================================================
              // HEADER
              // ============================================================
              Row(
                children: [
                  Text(
                    'Progress',

                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {},

                    icon: Icon(
                      Icons.calendar_month_outlined,
                      color: colorScheme.onSurface,
                      size: 27,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ============================================================
              // TIME PERIOD
              // ============================================================
              periodSelector(context),

              const SizedBox(height: 20),

              // ============================================================
              // OVERALL IMPROVEMENT
              // ============================================================
              overallImprovementCard(context),

              const SizedBox(height: 20),

              // ============================================================
              // SCORE TREND
              // ============================================================
              scoreTrendCard(context),

              const SizedBox(height: 24),

              // ============================================================
              // RECENT RIDES HEADER
              // ============================================================
              Row(
                children: [
                  Text(
                    'Recent Rides',

                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: () {},

                    child: const Text(
                      'View All',

                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ============================================================
              // RECENT RIDE
              // ============================================================
              recentRideCard(context),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PERIOD SELECTOR
  // ============================================================

  Widget periodSelector(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: 48,

      padding: const EdgeInsets.all(4),

      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),

      child: Row(
        children: [
          periodItem(context, 'Week'),
          periodItem(context, 'Month'),
          periodItem(context, 'Year'),
        ],
      ),
    );
  }

  // ============================================================
  // PERIOD ITEM
  // ============================================================

  Widget periodItem(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;

    final bool selected = selectedPeriod == text;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          changePeriod(text);
        },

        child: Container(
          height: double.infinity,

          alignment: Alignment.center,

          decoration: BoxDecoration(
            color: selected ? Colors.blue : Colors.transparent,

            borderRadius: BorderRadius.circular(20),
          ),

          child: Text(
            text,

            style: TextStyle(
              color: selected ? Colors.white : colorScheme.onSurfaceVariant,

              fontSize: 14,

              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // OVERALL IMPROVEMENT CARD
  // ============================================================

  Widget overallImprovementCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final String improvement;

    final String comparison;

    if (selectedPeriod == 'Week') {
      improvement = '+8%';
      comparison = 'vs Last Week';
    } else if (selectedPeriod == 'Year') {
      improvement = '+32%';
      comparison = 'vs Last Year';
    } else {
      improvement = '+15%';
      comparison = 'vs Last Month';
    }

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
          Text(
            'Overall Improvement',

            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            improvement,

            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            comparison,

            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 150,
            width: double.infinity,

            child: CustomPaint(
              painter: ProgressChartPainter(
                lineColor: Colors.lightBlue,
                gridColor: colorScheme.outlineVariant,
                period: selectedPeriod,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SCORE TREND CARD
  // ============================================================

  Widget scoreTrendCard(BuildContext context) {
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
          Text(
            'Score Trend',

            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          scoreRow(context, 'Posture', '85%', '+10%'),

          Divider(color: colorScheme.outlineVariant),

          scoreRow(context, 'Balance', '78%', '+8%'),

          Divider(color: colorScheme.outlineVariant),

          scoreRow(context, 'Leg Position', '82%', '+12%'),
        ],
      ),
    );
  }

  // ============================================================
  // SCORE ROW
  // ============================================================

  Widget scoreRow(
    BuildContext context,
    String title,
    String score,
    String improvement,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,

            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        SizedBox(
          width: 65,

          child: Text(
            score,

            textAlign: TextAlign.center,

            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SizedBox(
          width: 65,

          child: Text(
            improvement,

            textAlign: TextAlign.right,

            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // RECENT RIDE CARD
  // ============================================================

  Widget recentRideCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: colorScheme.outlineVariant),
      ),

      child: Row(
        children: [
          // ICON
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.15),

              borderRadius: BorderRadius.circular(14),
            ),

            child: const Icon(Icons.directions_run, color: Colors.blue),
          ),

          const SizedBox(width: 14),

          // RIDE DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Ride Session',

                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Today • 35 min',

                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // SCORE
          const Text(
            '85%',

            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 8),

          Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

// ============================================================================
// PROGRESS CHART PAINTER
// ============================================================================

class ProgressChartPainter extends CustomPainter {
  final Color lineColor;
  final Color gridColor;
  final String period;

  ProgressChartPainter({
    required this.lineColor,
    required this.gridColor,
    required this.period,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ============================================================
    // PAINTS
    // ============================================================

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    // ============================================================
    // GRID
    // ============================================================

    for (int i = 1; i <= 3; i++) {
      final double y = size.height * i / 4;

      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // ============================================================
    // GRAPH DATA
    // ============================================================

    final List<Offset> points = getChartPoints(size);

    // ============================================================
    // GRAPH LINE
    // ============================================================

    final Path path = Path();

    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, linePaint);

    // ============================================================
    // GRAPH POINTS
    // ============================================================

    for (final point in points) {
      canvas.drawCircle(point, 5, pointPaint);
    }
  }

  // ============================================================
  // CHART POINTS
  // ============================================================

  List<Offset> getChartPoints(Size size) {
    if (period == 'Week') {
      return [
        Offset(size.width * 0.08, size.height * 0.70),
        Offset(size.width * 0.23, size.height * 0.55),
        Offset(size.width * 0.38, size.height * 0.62),
        Offset(size.width * 0.53, size.height * 0.42),
        Offset(size.width * 0.68, size.height * 0.35),
        Offset(size.width * 0.83, size.height * 0.25),
        Offset(size.width * 0.98, size.height * 0.15),
      ];
    }

    if (period == 'Year') {
      return [
        Offset(size.width * 0.08, size.height * 0.82),
        Offset(size.width * 0.17, size.height * 0.72),
        Offset(size.width * 0.26, size.height * 0.65),
        Offset(size.width * 0.35, size.height * 0.55),
        Offset(size.width * 0.44, size.height * 0.60),
        Offset(size.width * 0.53, size.height * 0.45),
        Offset(size.width * 0.62, size.height * 0.38),
        Offset(size.width * 0.71, size.height * 0.30),
        Offset(size.width * 0.80, size.height * 0.24),
        Offset(size.width * 0.89, size.height * 0.18),
        Offset(size.width * 0.98, size.height * 0.08),
      ];
    }

    // MONTH

    return [
      Offset(size.width * 0.08, size.height * 0.78),
      Offset(size.width * 0.27, size.height * 0.57),
      Offset(size.width * 0.46, size.height * 0.38),
      Offset(size.width * 0.60, size.height * 0.52),
      Offset(size.width * 0.73, size.height * 0.22),
      Offset(size.width * 0.85, size.height * 0.38),
      Offset(size.width * 0.98, size.height * 0.05),
    ];
  }

  @override
  bool shouldRepaint(covariant ProgressChartPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.period != period;
  }
}
