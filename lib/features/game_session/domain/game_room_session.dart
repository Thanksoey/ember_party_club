enum GameSessionPhase { briefing, playing, finished }

enum GameSessionSyncState { localPreview, roomBound, multiplayerReady }

class GameSessionParticipant {
  const GameSessionParticipant({
    required this.id,
    required this.nickname,
    required this.seat,
    required this.isHost,
    required this.isLocal,
  });

  final String id;
  final String nickname;
  final int seat;
  final bool isHost;
  final bool isLocal;
}

class GameRoomSession {
  const GameRoomSession({
    required this.roomId,
    required this.roomTitle,
    required this.moduleId,
    required this.moduleName,
    required this.capacity,
    required this.voiceEnabled,
    required this.phase,
    required this.syncState,
    required this.participants,
    required this.highlightParticipantId,
  });

  final String roomId;
  final String roomTitle;
  final String moduleId;
  final String moduleName;
  final int capacity;
  final bool voiceEnabled;
  final GameSessionPhase phase;
  final GameSessionSyncState syncState;
  final List<GameSessionParticipant> participants;
  final String highlightParticipantId;

  int get occupiedSeats => participants.length;

  GameRoomSession copyWith({
    String? roomId,
    String? roomTitle,
    String? moduleId,
    String? moduleName,
    int? capacity,
    bool? voiceEnabled,
    GameSessionPhase? phase,
    GameSessionSyncState? syncState,
    List<GameSessionParticipant>? participants,
    String? highlightParticipantId,
  }) {
    return GameRoomSession(
      roomId: roomId ?? this.roomId,
      roomTitle: roomTitle ?? this.roomTitle,
      moduleId: moduleId ?? this.moduleId,
      moduleName: moduleName ?? this.moduleName,
      capacity: capacity ?? this.capacity,
      voiceEnabled: voiceEnabled ?? this.voiceEnabled,
      phase: phase ?? this.phase,
      syncState: syncState ?? this.syncState,
      participants: participants ?? this.participants,
      highlightParticipantId:
          highlightParticipantId ?? this.highlightParticipantId,
    );
  }
}
