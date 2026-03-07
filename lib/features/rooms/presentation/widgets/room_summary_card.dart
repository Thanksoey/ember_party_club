import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../core/models/game_module.dart';
import '../../domain/room_summary.dart';

class RoomSummaryCard extends StatelessWidget {
  const RoomSummaryCard({
    super.key,
    required this.room,
    required this.module,
    this.isHighlighted = false,
    this.onTap,
  });

  final RoomSummary room;
  final GameModule? module;
  final bool isHighlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final accentColor = isHighlighted ? theme.colorScheme.secondary : theme.colorScheme.primary;

    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: accentColor.withValues(alpha: isHighlighted ? 0.3 : 0.08),
              width: isHighlighted ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.roomTitle(room), style: theme.textTheme.titleLarge),
                        const SizedBox(height: 6),
                        Text(
                          module == null ? room.gameModuleId : l10n.moduleName(module!),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.roomStatusLabel(room.status),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _RoomMetaPill(label: l10n.hostLabel(room.host.nickname)),
                  _RoomMetaPill(label: l10n.playersLabel(room.currentPlayers, room.capacity)),
                  if (room.isVoiceEnabled) _RoomMetaPill(label: l10n.voiceOn),
                  _RoomMetaPill(label: room.isRanked ? l10n.ranked : l10n.casual),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${(room.fillRatio * 100).round()}%',
                      style: theme.textTheme.headlineSmall?.copyWith(color: accentColor),
                    ),
                  ),
                  Text(l10n.roomCodeLabel, style: theme.textTheme.bodyMedium),
                  const SizedBox(width: 6),
                  Text(room.id.toUpperCase(), style: theme.textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: room.fillRatio,
                  minHeight: 8,
                  backgroundColor: accentColor.withValues(alpha: 0.08),
                  color: accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoomMetaPill extends StatelessWidget {
  const _RoomMetaPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
