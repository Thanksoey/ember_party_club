import 'package:flutter/material.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                foregroundColor: theme.colorScheme.primary,
                child: Icon(icon),
              ),
              const SizedBox(height: 14),
              Text(title, style: theme.textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(subtitle, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'GO',
                    style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.secondary),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_rounded, color: theme.colorScheme.secondary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
