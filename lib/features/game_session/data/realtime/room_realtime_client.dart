import 'room_realtime_message.dart';

abstract class RoomRealtimeClient {
  Stream<RoomRealtimeMessage> subscribe({
    required String roomId,
    required String moduleId,
  });

  Future<void> connect({required String roomId, required String moduleId});

  Future<void> send({
    required String roomId,
    required String moduleId,
    required String command,
    Map<String, String> payload = const <String, String>{},
  });

  Future<void> close({required String roomId, required String moduleId});
}
