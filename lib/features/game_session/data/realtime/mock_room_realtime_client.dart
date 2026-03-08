import 'dart:async';

import 'room_realtime_client.dart';
import 'room_realtime_message.dart';

class MockRoomRealtimeClient implements RoomRealtimeClient {
  final Map<String, StreamController<RoomRealtimeMessage>> _channels =
      <String, StreamController<RoomRealtimeMessage>>{};

  @override
  Stream<RoomRealtimeMessage> subscribe({
    required String roomId,
    required String moduleId,
  }) {
    return _channel(roomId, moduleId).stream;
  }

  @override
  Future<void> connect({
    required String roomId,
    required String moduleId,
  }) async {
    final channel = _channel(roomId, moduleId);
    channel.add(RoomRealtimeMessage.connected());
    await Future<void>.delayed(const Duration(milliseconds: 80));
    channel.add(RoomRealtimeMessage.syncReady());
    await Future<void>.delayed(const Duration(milliseconds: 50));
    channel.add(RoomRealtimeMessage.participantJoined(3));
  }

  @override
  Future<void> send({
    required String roomId,
    required String moduleId,
    required String command,
    Map<String, String> payload = const <String, String>{},
  }) async {
    final channel = _channel(roomId, moduleId);
    channel.add(RoomRealtimeMessage.commandAccepted(command));
    switch (command) {
      case 'start_game':
        channel.add(RoomRealtimeMessage.phaseChanged('briefing'));
        break;
      case 'play_card':
        channel.add(RoomRealtimeMessage.phaseChanged('playing'));
        final cardId = payload['cardId'];
        if (cardId != null) {
          channel.add(RoomRealtimeMessage.cardPlayed(cardId));
        }
        break;
      case 'reset_match':
        channel.add(RoomRealtimeMessage.resetAcknowledged());
        channel.add(RoomRealtimeMessage.phaseChanged('briefing'));
        break;
      case 'connect':
        break;
    }
  }

  @override
  Future<void> close({required String roomId, required String moduleId}) async {
    final key = _key(roomId, moduleId);
    final controller = _channels.remove(key);
    await controller?.close();
  }

  StreamController<RoomRealtimeMessage> _channel(
    String roomId,
    String moduleId,
  ) {
    final key = _key(roomId, moduleId);
    return _channels.putIfAbsent(
      key,
      () => StreamController<RoomRealtimeMessage>.broadcast(),
    );
  }

  String _key(String roomId, String moduleId) => '$roomId::$moduleId';
}
