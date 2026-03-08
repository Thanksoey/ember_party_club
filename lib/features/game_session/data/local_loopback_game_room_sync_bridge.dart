import 'dart:async';

import '../application/game_room_sync_bridge.dart';
import '../domain/game_room_session.dart';
import '../domain/game_room_session_command.dart';
import '../domain/game_room_session_event.dart';

class LocalLoopbackGameRoomSyncBridge implements GameRoomSyncBridge {
  LocalLoopbackGameRoomSyncBridge();

  final StreamController<GameRoomSessionEvent> _controller =
      StreamController<GameRoomSessionEvent>.broadcast();
  bool _connected = false;

  @override
  Stream<GameRoomSessionEvent> get events => _controller.stream;

  @override
  Future<void> connect(GameRoomSession session) async {
    if (_connected) {
      return;
    }
    _connected = true;
    _controller.add(
      GameRoomSessionEvent(
        type: GameRoomSessionEventType.syncConnected,
        occurredAt: DateTime.now(),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 60));
    _controller.add(
      GameRoomSessionEvent(
        type: GameRoomSessionEventType.syncReady,
        occurredAt: DateTime.now(),
        syncState: GameSessionSyncState.multiplayerReady,
      ),
    );
    if (session.participants.length < session.capacity) {
      _controller.add(
        GameRoomSessionEvent(
          type: GameRoomSessionEventType.participantSynced,
          occurredAt: DateTime.now(),
          seat: session.participants.length + 1,
        ),
      );
    }
  }

  @override
  Future<void> send(GameRoomSessionCommand command) async {
    _controller.add(
      GameRoomSessionEvent(
        type: GameRoomSessionEventType.commandAcknowledged,
        occurredAt: DateTime.now(),
        commandType: command.type,
      ),
    );

    switch (command.type) {
      case GameRoomSessionCommandType.connect:
        break;
      case GameRoomSessionCommandType.startGame:
        _controller.add(
          GameRoomSessionEvent(
            type: GameRoomSessionEventType.phaseChanged,
            occurredAt: DateTime.now(),
            phase: GameSessionPhase.briefing,
          ),
        );
        break;
      case GameRoomSessionCommandType.playCard:
        _controller.add(
          GameRoomSessionEvent(
            type: GameRoomSessionEventType.phaseChanged,
            occurredAt: DateTime.now(),
            phase: GameSessionPhase.playing,
          ),
        );
        _controller.add(
          GameRoomSessionEvent(
            type: GameRoomSessionEventType.signalCardBroadcast,
            occurredAt: DateTime.now(),
            cardId: command.payload['cardId'],
          ),
        );
        break;
      case GameRoomSessionCommandType.resetMatch:
        _controller.add(
          GameRoomSessionEvent(
            type: GameRoomSessionEventType.matchReset,
            occurredAt: DateTime.now(),
            phase: GameSessionPhase.briefing,
          ),
        );
        break;
    }
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
  }
}
