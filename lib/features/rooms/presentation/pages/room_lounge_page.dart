import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../application/room_lounge_controller.dart';
import '../widgets/create_room_sheet.dart';
import '../widgets/presence_strip.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/room_summary_card.dart';
import 'room_detail_page.dart';

class RoomLoungePage extends StatelessWidget {
  const RoomLoungePage({
    super.key,
    required this.controller,
  });

  final RoomLoungeController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final theme = Theme.of(context);
        final l10n = context.l10n;
        final hottestRoom = controller.hottestRoom;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.tertiary.withValues(alpha: 0.94),
                                  theme.colorScheme.primary.withValues(alpha: 0.9),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.14),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    l10n.roomLoungeTitle,
                                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  l10n.roomLoungeHero,
                                  style: theme.textTheme.displaySmall?.copyWith(color: Colors.white),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l10n.roomLoungeBody,
                                  style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        PresenceStrip(
                          roomCount: controller.liveRoomCount,
                          playerCount: controller.liveSeatCount,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: QuickActionCard(
                                key: const ValueKey('open-quick-match'),
                                title: l10n.quickMatch,
                                subtitle: l10n.quickMatchBody,
                                icon: Icons.flash_on,
                                onTap: () => _openQuickMatch(context),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: QuickActionCard(
                                key: const ValueKey('open-create-room'),
                                title: l10n.createRoom,
                                subtitle: l10n.createRoomBody,
                                icon: Icons.add_home_work_outlined,
                                onTap: () => _showCreateRoomSheet(context),
                              ),
                            ),
                          ],
                        ),
                        if (hottestRoom != null) ...[
                          const SizedBox(height: 28),
                          Text(l10n.hottestRoom, style: theme.textTheme.headlineSmall),
                          const SizedBox(height: 12),
                          RoomSummaryCard(
                            room: hottestRoom,
                            module: controller.moduleFor(hottestRoom),
                            isHighlighted: true,
                            onTap: () => _openRoom(context, hottestRoom.id),
                          ),
                        ],
                        const SizedBox(height: 28),
                        Text(l10n.activeRoomList, style: theme.textTheme.headlineSmall),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: SliverList.separated(
                    itemCount: controller.rooms.length,
                    itemBuilder: (context, index) {
                      final room = controller.rooms[index];
                      return RoomSummaryCard(
                        room: room,
                        module: controller.moduleFor(room),
                        onTap: () => _openRoom(context, room.id),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 14),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showCreateRoomSheet(BuildContext context) async {
    final roomId = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => CreateRoomSheet(controller: controller),
    );
    if (context.mounted && roomId != null) {
      _openRoom(context, roomId);
    }
  }

  void _openQuickMatch(BuildContext context) {
    final target = controller.quickMatchTarget();
    if (target == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.quickMatchEmpty)),
      );
      return;
    }
    _openRoom(context, target.id);
  }

  void _openRoom(BuildContext context, String roomId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RoomDetailPage(
          controller: controller,
          roomId: roomId,
        ),
      ),
    );
  }
}
