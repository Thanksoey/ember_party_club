import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../domain/signal_card.dart';

class SignalCardTile extends StatelessWidget {
  const SignalCardTile({
    super.key,
    required this.card,
    required this.enabled,
    required this.onPlay,
  });

  final SignalCard card;
  final bool enabled;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.signalCardTitle(card.id), style: theme.textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(l10n.signalCardMeta(card), style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text(l10n.signalCardNote(card.id), style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: enabled ? onPlay : null,
            child: Text(l10n.play),
          ),
        ],
      ),
    );
  }
}
