import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../application/game_room_session_controller.dart';
import '../../domain/game_room_session.dart';

class GameRoomSessionPanel extends StatelessWidget {
  const GameRoomSessionPanel({
    super.key,
    required this.controller,
  });

  final GameRoomSessionController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final theme = Theme.of(context);
        final l10n = context.l10n;
        final session = controller.session;

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
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
                        Text(l10n.gameSessionRoomLabel, style: theme.textTheme.titleLarge),
                        const SizedBox(height: 6),
                        Text(
                          l10n.roomSessionTitle(session.roomTitle, session.moduleName),
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.gameSessionPhaseLabel(session.phase),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
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
                  _SessionPill(label: l10n.roomCodeLabel, value: session.roomId),
                  _SessionPill(
                    label: l10n.gameSessionSyncLabel,
                    value: l10n.gameSessionSyncStateLabel(session.syncState),
                  ),
                  _SessionPill(
                    label: l10n.roomCapacityFieldLabel,
                    value: l10n.playersLabel(session.occupiedSeats, session.capacity),
                  ),
                  _SessionPill(
                    label: l10n.roomVoiceToggle,
                    value: session.voiceEnabled ? l10n.voiceOn : l10n.roomVoiceOff,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(l10n.gameSessionParticipantsLabel, style: theme.textTheme.titleMedium),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: session.participants
                    .map(
                      (participant) => _ParticipantChip(
                        participant: participant,
                        isHighlighted: participant.id == session.highlightParticipantId,
                      ),
                    )
                    .toList(growable: false),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SessionPill extends StatelessWidget {
  const _SessionPill({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label: $value',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ParticipantChip extends StatelessWidget {
  const _ParticipantChip({
    required this.participant,
    required this.isHighlighted,
  });

  final GameSessionParticipant participant;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final color = isHighlighted ? theme.colorScheme.secondary : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isHighlighted ? 0.12 : 0.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.gameSessionParticipantLabel(
              participant.seat,
              l10n.gameSessionParticipantName(participant),
            ),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (participant.isHost || participant.isLocal) ...[
            const SizedBox(height: 4),
            Text(
              participant.isHost ? l10n.gameSessionHostTag : l10n.gameSessionLocalTag,
              style: theme.textTheme.bodySmall?.copyWith(color: color),
            ),
          ],
        ],
      ),
    );
  }
}
