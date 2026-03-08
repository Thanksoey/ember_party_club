import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../rooms/domain/room_summary.dart';
import '../data/realtime/realtime_game_room_sync_bridge.dart';
import '../domain/game_room_session.dart';
import '../domain/game_room_session_command.dart';
import '../domain/game_room_session_event.dart';
import 'game_room_sync_bridge.dart';

class GameRoomSessionController extends ChangeNotifier {
  GameRoomSessionController._(this._session, this._syncBridge) {
    _bootstrapSync();
  }

  factory GameRoomSessionController.fromRoom({
    required RoomSummary room,
    required String moduleName,
    GameRoomSyncBridge? syncBridge,
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
      syncBridge ?? RealtimeGameRoomSyncBridge.mock(),
    );
  }

  GameRoomSession _session;
  final GameRoomSyncBridge _syncBridge;
  final List<GameRoomSessionEvent> _timeline = <GameRoomSessionEvent>[];
  StreamSubscription<GameRoomSessionEvent>? _subscription;

  GameRoomSession get session => _session;
  List<GameRoomSessionEvent> get timeline =>
      List<GameRoomSessionEvent>.unmodifiable(_timeline);

  Future<void> startSession() =>
      sendCommand(GameRoomSessionCommand.startGame());

  Future<void> sendCardPlayed({required String cardId, required int round}) {
    return sendCommand(
      GameRoomSessionCommand.playCard(cardId: cardId, round: round),
    );
  }

  Future<void> resetMatch() async {
    _updateSession(phase: GameSessionPhase.briefing);
    await sendCommand(GameRoomSessionCommand.resetMatch());
  }

  void handleMatchState({required bool hasAnyRound, required bool isFinished}) {
    final nextPhase = isFinished
        ? GameSessionPhase.finished
        : hasAnyRound
        ? GameSessionPhase.playing
        : GameSessionPhase.briefing;
    if (nextPhase == _session.phase) {
      return;
    }
    _appendEvent(
      GameRoomSessionEvent(
        type: GameRoomSessionEventType.phaseChanged,
        occurredAt: DateTime.now(),
        phase: nextPhase,
      ),
    );
    _updateSession(phase: nextPhase);
  }

  Future<void> sendCommand(GameRoomSessionCommand command) async {
    _appendEvent(
      GameRoomSessionEvent(
        type: GameRoomSessionEventType.commandDispatched,
        occurredAt: DateTime.now(),
        commandType: command.type,
      ),
    );
    await _syncBridge.send(command);
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    unawaited(_syncBridge.dispose());
    super.dispose();
  }

  Future<void> _bootstrapSync() async {
    await _syncBridge.connect(_session);
    _subscription = _syncBridge.events.listen(_handleEvent);
    await sendCommand(GameRoomSessionCommand.connect());
  }

  void _handleEvent(GameRoomSessionEvent event) {
    switch (event.type) {
      case GameRoomSessionEventType.syncConnected:
        break;
      case GameRoomSessionEventType.syncReady:
        _updateSession(syncState: event.syncState);
        break;
      case GameRoomSessionEventType.commandDispatched:
      case GameRoomSessionEventType.commandAcknowledged:
        break;
      case GameRoomSessionEventType.phaseChanged:
        _updateSession(phase: event.phase);
        break;
      case GameRoomSessionEventType.participantSynced:
        if (event.seat != null &&
            _session.participants.every(
              (participant) => participant.seat != event.seat,
            )) {
          final nextParticipants = <GameSessionParticipant>[
            ..._session.participants,
            GameSessionParticipant(
              id: 'guest-seat-${event.seat}',
              nickname: 'Seat ${event.seat}',
              seat: event.seat!,
              isHost: false,
              isLocal: false,
            ),
          ];
          _updateSession(participants: List.unmodifiable(nextParticipants));
        }
        break;
      case GameRoomSessionEventType.signalCardBroadcast:
      case GameRoomSessionEventType.matchReset:
        if (event.type == GameRoomSessionEventType.matchReset) {
          _updateSession(phase: GameSessionPhase.briefing);
        }
        break;
    }
    _appendEvent(event);
  }

  void _appendEvent(GameRoomSessionEvent event) {
    _timeline.insert(0, event);
    if (_timeline.length > 10) {
      _timeline.removeLast();
    }
    notifyListeners();
  }

  void _updateSession({
    GameSessionPhase? phase,
    GameSessionSyncState? syncState,
    List<GameSessionParticipant>? participants,
  }) {
    final next = _session.copyWith(
      phase: phase,
      syncState: syncState,
      participants: participants,
    );
    if (next.phase == _session.phase &&
        next.syncState == _session.syncState &&
        listEquals(next.participants, _session.participants)) {
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
