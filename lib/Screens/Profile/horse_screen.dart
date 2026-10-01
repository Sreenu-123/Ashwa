import 'package:flutter/material.dart';

class HorseScreen extends StatelessWidget {
  final String horseName;

  const HorseScreen({super.key, required this.horseName});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Horse'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // HORSE IMAGE
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.35),
                  width: 2,
                ),
              ),
              child: Icon(Icons.pets, size: 75, color: Colors.blue),
            ),

            const SizedBox(height: 24),

            // HORSE NAME
            Text(
              horseName.isEmpty ? 'My Horse' : horseName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Your riding companion',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 30),

            // HORSE INFORMATION
            horseInfoCard(
              context,
              icon: Icons.pets_outlined,
              title: 'Horse Name',
              value: horseName.isEmpty ? 'Not added' : horseName,
            ),

            const SizedBox(height: 12),

            horseInfoCard(
              context,
              icon: Icons.cake_outlined,
              title: 'Age',
              value: 'Not added yet',
            ),

            const SizedBox(height: 12),

            horseInfoCard(
              context,
              icon: Icons.category_outlined,
              title: 'Breed',
              value: 'Not added yet',
            ),

            const SizedBox(height: 12),

            horseInfoCard(
              context,
              icon: Icons.male_outlined,
              title: 'Gender',
              value: 'Not added yet',
            ),

            const SizedBox(height: 30),

            // FUTURE FEATURE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'More horse details and health information '
                      'will be available in a future update.',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget horseInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
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
            child: Icon(icon, color: Colors.blue, size: 24),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
