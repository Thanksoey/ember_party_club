enum GameRoomSessionCommandType { connect, startGame, playCard, resetMatch }

class GameRoomSessionCommand {
  const GameRoomSessionCommand({
    required this.id,
    required this.type,
    required this.createdAt,
    this.payload = const <String, String>{},
  });

  factory GameRoomSessionCommand.connect() {
    return GameRoomSessionCommand(
      id: 'cmd-connect-${DateTime.now().microsecondsSinceEpoch}',
      type: GameRoomSessionCommandType.connect,
      createdAt: DateTime.now(),
    );
  }

  factory GameRoomSessionCommand.startGame() {
    return GameRoomSessionCommand(
      id: 'cmd-start-${DateTime.now().microsecondsSinceEpoch}',
      type: GameRoomSessionCommandType.startGame,
      createdAt: DateTime.now(),
    );
  }

  factory GameRoomSessionCommand.playCard({
    required String cardId,
    required int round,
  }) {
    return GameRoomSessionCommand(
      id: 'cmd-card-${DateTime.now().microsecondsSinceEpoch}',
      type: GameRoomSessionCommandType.playCard,
      createdAt: DateTime.now(),
      payload: <String, String>{'cardId': cardId, 'round': '$round'},
    );
  }

  factory GameRoomSessionCommand.resetMatch() {
    return GameRoomSessionCommand(
      id: 'cmd-reset-${DateTime.now().microsecondsSinceEpoch}',
      type: GameRoomSessionCommandType.resetMatch,
      createdAt: DateTime.now(),
    );
  }

  final String id;
  final GameRoomSessionCommandType type;
  final DateTime createdAt;
  final Map<String, String> payload;
}
