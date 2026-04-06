import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class QuickActions extends StatelessWidget {
  final Function(String) onActionTap;

  const QuickActions({super.key, required this.onActionTap});

  static const List<Map<String, dynamic>> actions = [
    {'icon': Icons.local_hospital, 'label': 'Symptoms', 'query': 'What symptoms should I watch for?'},
    {'icon': Icons.restaurant, 'label': 'Nutrition', 'query': 'What foods are good for my child\'s age?'},
    {'icon': Icons.bedtime, 'label': 'Sleep', 'query': 'How much sleep does my child need?'},
    {'icon': Icons.vaccines, 'label': 'Vaccines', 'query': 'What vaccinations are recommended?'},
    {'icon': Icons.fitness_center, 'label': 'Growth', 'query': 'What are typical growth milestones?'},
    {'icon': Icons.emoji_emotions, 'label': 'Behavior', 'query': 'What behavioral changes are normal?'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () => onActionTap(action['query']),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      action['icon'],
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      action['label'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}