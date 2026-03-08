import 'dart:async';

import '../../application/game_room_sync_bridge.dart';
import '../../domain/game_room_session.dart';
import '../../domain/game_room_session_command.dart';
import '../../domain/game_room_session_event.dart';
import 'mock_room_realtime_client.dart';
import 'room_realtime_client.dart';
import 'room_realtime_message.dart';

class RealtimeGameRoomSyncBridge implements GameRoomSyncBridge {
  RealtimeGameRoomSyncBridge({required RoomRealtimeClient client})
    : _client = client;

  factory RealtimeGameRoomSyncBridge.mock() {
    return RealtimeGameRoomSyncBridge(client: MockRoomRealtimeClient());
  }

  final RoomRealtimeClient _client;
  GameRoomSession? _session;
  final StreamController<GameRoomSessionEvent> _events =
      StreamController<GameRoomSessionEvent>.broadcast();
  StreamSubscription<RoomRealtimeMessage>? _subscription;

  @override
  Stream<GameRoomSessionEvent> get events => _events.stream;

  @override
  Future<void> connect(GameRoomSession session) async {
    _session = session;
    unawaited(_subscription?.cancel());
    _subscription = _client
        .subscribe(roomId: session.roomId, moduleId: session.moduleId)
        .listen((message) {
          _events.add(_mapMessage(message));
        });
    await _client.connect(roomId: session.roomId, moduleId: session.moduleId);
  }

  @override
  Future<void> send(GameRoomSessionCommand command) async {
    final session = _session;
    if (session == null) {
      return;
    }
    await _client.send(
      roomId: session.roomId,
      moduleId: session.moduleId,
      command: _commandName(command.type),
      payload: command.payload,
    );
  }

  @override
  Future<void> dispose() async {
    final session = _session;
    await _subscription?.cancel();
    if (session != null) {
      await _client.close(roomId: session.roomId, moduleId: session.moduleId);
    }
    await _events.close();
  }

  GameRoomSessionEvent _mapMessage(RoomRealtimeMessage message) {
    switch (message.type) {
      case RoomRealtimeMessageType.connected:
        return GameRoomSessionEvent(
          type: GameRoomSessionEventType.syncConnected,
          occurredAt: message.timestamp,
        );
      case RoomRealtimeMessageType.syncReady:
        return GameRoomSessionEvent(
          type: GameRoomSessionEventType.syncReady,
          occurredAt: message.timestamp,
          syncState: GameSessionSyncState.multiplayerReady,
        );
      case RoomRealtimeMessageType.participantJoined:
        return GameRoomSessionEvent(
          type: GameRoomSessionEventType.participantSynced,
          occurredAt: message.timestamp,
          seat: int.tryParse(message.payload['seat'] ?? ''),
        );
      case RoomRealtimeMessageType.phaseChanged:
        return GameRoomSessionEvent(
          type: GameRoomSessionEventType.phaseChanged,
          occurredAt: message.timestamp,
          phase: _phaseFromName(message.payload['phase']),
        );
      case RoomRealtimeMessageType.cardPlayed:
        return GameRoomSessionEvent(
          type: GameRoomSessionEventType.signalCardBroadcast,
          occurredAt: message.timestamp,
          cardId: message.payload['cardId'],
        );
      case RoomRealtimeMessageType.resetAcknowledged:
        return GameRoomSessionEvent(
          type: GameRoomSessionEventType.matchReset,
          occurredAt: message.timestamp,
          phase: GameSessionPhase.briefing,
        );
      case RoomRealtimeMessageType.commandAccepted:
        return GameRoomSessionEvent(
          type: GameRoomSessionEventType.commandAcknowledged,
          occurredAt: message.timestamp,
          commandType: _commandFromName(message.payload['command']),
        );
    }
  }

  String _commandName(GameRoomSessionCommandType type) {
    switch (type) {
      case GameRoomSessionCommandType.connect:
        return 'connect';
      case GameRoomSessionCommandType.startGame:
        return 'start_game';
      case GameRoomSessionCommandType.playCard:
        return 'play_card';
      case GameRoomSessionCommandType.resetMatch:
        return 'reset_match';
    }
  }

  GameRoomSessionCommandType? _commandFromName(String? name) {
    switch (name) {
      case 'connect':
        return GameRoomSessionCommandType.connect;
      case 'start_game':
        return GameRoomSessionCommandType.startGame;
      case 'play_card':
        return GameRoomSessionCommandType.playCard;
      case 'reset_match':
        return GameRoomSessionCommandType.resetMatch;
      default:
        return null;
    }
  }

  GameSessionPhase? _phaseFromName(String? name) {
    switch (name) {
      case 'briefing':
        return GameSessionPhase.briefing;
      case 'playing':
        return GameSessionPhase.playing;
      case 'finished':
        return GameSessionPhase.finished;
      default:
        return null;
    }
  }
}
