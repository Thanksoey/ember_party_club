import 'game_room_session.dart';
import 'game_room_session_command.dart';

enum GameRoomSessionEventType {
  syncConnected,
  syncReady,
  commandDispatched,
  commandAcknowledged,
  phaseChanged,
  participantSynced,
  signalCardBroadcast,
  matchReset,
}

class GameRoomSessionEvent {
  const GameRoomSessionEvent({
    required this.type,
    required this.occurredAt,
    this.commandType,
    this.phase,
    this.syncState,
    this.seat,
    this.cardId,
  });

  final GameRoomSessionEventType type;
  final DateTime occurredAt;
  final GameRoomSessionCommandType? commandType;
  final GameSessionPhase? phase;
  final GameSessionSyncState? syncState;
  final int? seat;
  final String? cardId;
}
