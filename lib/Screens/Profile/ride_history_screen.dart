import 'package:flutter/material.dart';

import '../../services/api_services.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  // ============================================================
  // STATE
  // ============================================================

  bool isLoading = true;
  String? errorMessage;

  List<Map<String, dynamic>> rides = [];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    loadRideHistory();
  }

  // ============================================================
  // LOAD RIDE HISTORY
  // ============================================================

  Future<void> loadRideHistory() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await ApiService.getRideHistory();

      if (!mounted) return;

      setState(() {
        rides = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  // ============================================================
  // FORMAT DURATION
  // ============================================================

  String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }

    if (minutes > 0) {
      return '${minutes}m ${remainingSeconds}s';
    }

    return '${remainingSeconds}s';
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Unknown date';
    }

    try {
      final date = DateTime.parse(dateString).toLocal();

      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year.toString();

      return '$day/$month/$year';
    } catch (_) {
      return 'Unknown date';
    }
  }

  // ============================================================
  // FORMAT TIME
  // ============================================================

  String formatTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return '';
    }

    try {
      final date = DateTime.parse(dateString).toLocal();

      final hour = date.hour > 12
          ? date.hour - 12
          : date.hour == 0
          ? 12
          : date.hour;

      final minute = date.minute.toString().padLeft(2, '0');

      final period = date.hour >= 12 ? 'PM' : 'AM';

      return '$hour:$minute $period';
    } catch (_) {
      return '';
    }
  }

  // ============================================================
  // DISCIPLINE ICON
  // ============================================================

  IconData disciplineIcon(String discipline) {
    switch (discipline.toLowerCase()) {
      case 'dressage':
        return Icons.sports_score;

      case 'show jumping':
        return Icons.height;

      case 'eventing':
        return Icons.emoji_events_outlined;

      case 'endurance':
        return Icons.directions_run;

      default:
        return Icons.sports;
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Ride History',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
        ),

        centerTitle: false,

        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: isLoading ? null : loadRideHistory,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),

      body: _buildBody(theme),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody(ThemeData theme) {
    // ----------------------------------------------------------
    // LOADING
    // ----------------------------------------------------------

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // ----------------------------------------------------------
    // ERROR
    // ----------------------------------------------------------

    if (errorMessage != null) {
      return _buildErrorState(theme);
    }

    // ----------------------------------------------------------
    // EMPTY
    // ----------------------------------------------------------

    if (rides.isEmpty) {
      return _buildEmptyState(theme);
    }

    // ----------------------------------------------------------
    // RIDE LIST
    // ----------------------------------------------------------

    return RefreshIndicator(
      onRefresh: loadRideHistory,

      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),

        itemCount: rides.length,

        itemBuilder: (context, index) {
          final ride = rides[index];

          return _buildRideCard(theme, ride);
        },
      ),
    );
  }

  // ============================================================
  // RIDE CARD
  // ============================================================

  Widget _buildRideCard(ThemeData theme, Map<String, dynamic> ride) {
    final horseName = ride['horse_name']?.toString() ?? 'Unknown Horse';

    final discipline = ride['discipline']?.toString() ?? 'Unknown';

    final durationSeconds =
        int.tryParse(ride['duration_seconds']?.toString() ?? '') ?? 0;

    final startedAt = ride['started_at']?.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: theme.cardColor,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ====================================================
          // TOP ROW
          // ====================================================

          Row(
            children: [
              // Horse Icon
              Container(
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.pets_rounded,
                  color: Colors.blue,
                  size: 25,
                ),
              ),

              const SizedBox(width: 14),

              // Horse Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      horseName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      discipline,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.textTheme.bodyMedium?.color?.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Discipline Icon
              Icon(disciplineIcon(discipline), size: 22, color: Colors.blue),
            ],
          ),

          const SizedBox(height: 18),

          // ====================================================
          // DIVIDER
          // ====================================================
          Divider(height: 1, color: theme.dividerColor.withValues(alpha: 0.15)),

          const SizedBox(height: 16),

          // ====================================================
          // RIDE DETAILS
          // ====================================================
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  theme,
                  Icons.timer_outlined,
                  'Duration',
                  formatDuration(durationSeconds),
                ),
              ),

              Expanded(
                child: _buildInfoItem(
                  theme,
                  Icons.calendar_today_outlined,
                  'Date',
                  formatDate(startedAt),
                ),
              ),

              Expanded(
                child: _buildInfoItem(
                  theme,
                  Icons.access_time_rounded,
                  'Time',
                  formatTime(startedAt),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO ITEM
  // ============================================================

  Widget _buildInfoItem(
    ThemeData theme,
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Icon(icon, size: 18, color: Colors.blue),

        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState(ThemeData theme) {
    return RefreshIndicator(
      onRefresh: loadRideHistory,

      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),

        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.22),

          Center(
            child: Container(
              width: 90,
              height: 90,

              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.history_rounded,
                size: 44,
                color: Colors.blue,
              ),
            ),
          ),

          const SizedBox(height: 22),

          const Center(
            child: Text(
              'No rides yet',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
            ),
          ),

          const SizedBox(height: 8),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),

              child: Text(
                'Complete your first AI ride and your ride history will appear here.',
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.55,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 80,
              height: 80,

              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.error_outline_rounded,
                size: 42,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Unable to load rides',
              textAlign: TextAlign.center,

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 8),

            Text(
              errorMessage ?? 'Something went wrong.',
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.55,
                ),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: loadRideHistory,

              icon: const Icon(Icons.refresh_rounded),

              label: const Text('Try Again'),

              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
