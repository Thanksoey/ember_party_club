import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../game_session/application/game_room_session_controller.dart';
import '../../../modules/signal_deck/application/signal_deck_controller.dart';
import '../../../modules/signal_deck/presentation/pages/signal_deck_page.dart';
import '../../application/room_lounge_controller.dart';
import '../widgets/room_summary_card.dart';

class RoomDetailPage extends StatelessWidget {
  const RoomDetailPage({
    super.key,
    required this.controller,
    required this.roomId,
  });

  final RoomLoungeController controller;
  final String roomId;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final theme = Theme.of(context);
        final l10n = context.l10n;
        final room = controller.findRoomById(roomId);

        if (room == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.roomDetailTitle)),
            body: Center(child: Text(l10n.roomNotFound)),
          );
        }

        final module = controller.moduleFor(room);
        final isSignalDeck = room.gameModuleId == 'signal-deck';

        return Scaffold(
          appBar: AppBar(title: Text(l10n.roomDetailTitle)),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(l10n.roomTitle(room), style: theme.textTheme.displaySmall),
                const SizedBox(height: 10),
                Text(l10n.roomDetailBody, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 20),
                RoomSummaryCard(
                  room: room,
                  module: module,
                  isHighlighted: true,
                ),
                const SizedBox(height: 20),
                _InfoSection(
                  title: l10n.roomInfoSection,
                  children: [
                    _InfoRow(label: l10n.roomCodeLabel, value: room.id),
                    _InfoRow(label: l10n.roomModuleLabel, value: module == null ? room.gameModuleId : l10n.moduleName(module)),
                    _InfoRow(label: l10n.roomHostNameLabel, value: room.host.nickname),
                  ],
                ),
                const SizedBox(height: 16),
                _InfoSection(
                  title: l10n.roomSettingsSection,
                  children: [
                    _InfoRow(label: l10n.roomCapacityFieldLabel, value: l10n.playersLabel(room.currentPlayers, room.capacity)),
                    _InfoRow(label: l10n.roomVoiceToggle, value: room.isVoiceEnabled ? l10n.voiceOn : l10n.roomVoiceOff),
                    _InfoRow(label: l10n.roomRankedToggle, value: room.isRanked ? l10n.ranked : l10n.casual),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  isSignalDeck ? l10n.roomStartGameBody : l10n.roomUnsupportedBody,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const ValueKey('start-room-game'),
                    onPressed: isSignalDeck
                        ? () {
                            final activeRoom = controller.markRoomInGame(room.id) ?? room;
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => SignalDeckPage(
                                  controller: SignalDeckController(),
                                  roomSessionController: GameRoomSessionController.fromRoom(
                                    room: activeRoom,
                                    moduleName: module == null ? activeRoom.gameModuleId : l10n.moduleName(module),
                                  ),
                                ),
                              ),
                            );
                          }
                        : null,
                    child: Text(l10n.roomStartGame),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(label, style: theme.textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(value, style: theme.textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
