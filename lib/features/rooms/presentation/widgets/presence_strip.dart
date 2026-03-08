import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/widgets/app_panel.dart';

class PresenceStrip extends StatelessWidget {
  const PresenceStrip({
    super.key,
    required this.roomCount,
    required this.playerCount,
  });

  final int roomCount;
  final int playerCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return AppPanel(
      child: Row(
        children: [
          Expanded(
            child: _MetricCell(
              label: l10n.activeRoomsMetric,
              value: '$roomCount',
              color: theme.colorScheme.primary,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.outline.withValues(alpha: 0.4),
          ),
          Expanded(
            child: _MetricCell(
              label: l10n.onlinePlayersMetric,
              value: '$playerCount',
              color: theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(color: color),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
