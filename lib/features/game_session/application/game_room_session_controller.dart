import 'package:flutter/foundation.dart';

import '../../rooms/domain/room_summary.dart';
import '../domain/game_room_session.dart';

class GameRoomSessionController extends ChangeNotifier {
  GameRoomSessionController._(this._session);

  factory GameRoomSessionController.fromRoom({
    required RoomSummary room,
    required String moduleName,
  }) {
    final participants = _buildParticipants(room);
    final highlight = participants.firstWhere(
      (participant) => participant.isLocal,
      orElse: () => participants.first,
    );

    return GameRoomSessionController._(
      GameRoomSession(
        roomId: room.id,
        roomTitle: room.title,
        moduleId: room.gameModuleId,
        moduleName: moduleName,
        capacity: room.capacity,
        voiceEnabled: room.isVoiceEnabled,
        phase: GameSessionPhase.briefing,
        syncState: GameSessionSyncState.roomBound,
        participants: participants,
        highlightParticipantId: highlight.id,
      ),
    );
  }

  GameRoomSession _session;

  GameRoomSession get session => _session;

  void handleMatchState({required bool hasAnyRound, required bool isFinished}) {
    final nextPhase = isFinished
        ? GameSessionPhase.finished
        : hasAnyRound
            ? GameSessionPhase.playing
            : GameSessionPhase.briefing;
    final nextSync = isFinished ? GameSessionSyncState.multiplayerReady : GameSessionSyncState.roomBound;
    _updateSession(phase: nextPhase, syncState: nextSync);
  }

  void resetMatch() {
    _updateSession(
      phase: GameSessionPhase.briefing,
      syncState: GameSessionSyncState.roomBound,
    );
  }

  void _updateSession({
    GameSessionPhase? phase,
    GameSessionSyncState? syncState,
  }) {
    final next = _session.copyWith(
      phase: phase,
      syncState: syncState,
    );
    if (next.phase == _session.phase && next.syncState == _session.syncState) {
      return;
    }
    _session = next;
    notifyListeners();
  }

  static List<GameSessionParticipant> _buildParticipants(RoomSummary room) {
    final participants = <GameSessionParticipant>[
      GameSessionParticipant(
        id: room.host.id,
        nickname: room.host.nickname,
        seat: 1,
        isHost: true,
        isLocal: room.host.id == 'local-host',
      ),
    ];

    final occupiedSeats = room.currentPlayers.clamp(1, room.capacity);
    for (var seat = 2; seat <= occupiedSeats; seat++) {
      participants.add(
        GameSessionParticipant(
          id: seat == 2 ? 'local-seat-$seat' : 'guest-seat-$seat',
          nickname: seat == 2 ? 'You' : 'Seat $seat',
          seat: seat,
          isHost: false,
          isLocal: seat == 2 && room.host.id != 'local-host',
        ),
      );
    }

    return List.unmodifiable(participants);
  }
}
