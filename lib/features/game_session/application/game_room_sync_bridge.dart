import '../domain/game_room_session.dart';
import '../domain/game_room_session_command.dart';
import '../domain/game_room_session_event.dart';

abstract class GameRoomSyncBridge {
  Stream<GameRoomSessionEvent> get events;

  Future<void> connect(GameRoomSession session);

  Future<void> send(GameRoomSessionCommand command);

  Future<void> dispose();
}
