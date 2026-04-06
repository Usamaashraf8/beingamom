import 'package:flutter/material.dart';
import '../models/child.dart';
import '../theme/app_theme.dart';

class ChildProfileScreen extends StatelessWidget {
  final Child child;

  const ChildProfileScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(child.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile avatar
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.accentColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Center(
                child: Text(
                  child.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Name
            Text(
              child.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Age badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                child.ageDisplay,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildDetailRow(
                      context,
                      icon: Icons.cake,
                      label: 'Birth Date',
                      value: '${child.birthDate.day}/${child.birthDate.month}/${child.birthDate.year}',
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      context,
                      icon: Icons.calendar_today,
                      label: 'Age',
                      value: child.ageDisplay,
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      context,
                      icon: Icons.calendar_view_month,
                      label: 'Age in Months',
                      value: '${child.ageMonths} months',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Health milestones based on age
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.emoji_events, color: AppTheme.accentColor),
                        const SizedBox(width: 8),
                        Text(
                          'Health Milestones',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ..._getMilestones().map((milestone) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              milestone,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  List<String> _getMilestones() {
    final ageMonths = child.ageMonths;
    final milestones = <String>[];

    if (ageMonths < 1) {
      milestones.addAll([
        'Regular pediatrician checkups',
        'Watch for feeding patterns',
        'Ensure proper sleep position',
      ]);
    } else if (ageMonths < 6) {
      milestones.addAll([
        'Continue vaccination schedule',
        'Introduce solid foods around 6 months',
        'Tummy time to strengthen muscles',
      ]);
    } else if (ageMonths < 12) {
      milestones.addAll([
        'Baby-proof your home',
        'First teeth care',
        'Begin weaning off bottle',
      ]);
    } else if (ageMonths < 24) {
      milestones.addAll([
        'Toddler nutrition balance',
        'Potty training readiness',
        'Active play for development',
      ]);
    } else {
      milestones.addAll([
        'Regular dental checkups',
        'Balanced diet with all food groups',
        'Physical activity daily',
      ]);
    }

    return milestones;
  }
}