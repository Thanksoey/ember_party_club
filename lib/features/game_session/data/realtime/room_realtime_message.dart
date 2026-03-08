enum RoomRealtimeMessageType {
  connected,
  syncReady,
  participantJoined,
  phaseChanged,
  cardPlayed,
  resetAcknowledged,
  commandAccepted,
}

class RoomRealtimeMessage {
  const RoomRealtimeMessage({
    required this.type,
    required this.timestamp,
    this.payload = const <String, String>{},
  });

  factory RoomRealtimeMessage.connected() {
    return RoomRealtimeMessage(
      type: RoomRealtimeMessageType.connected,
      timestamp: DateTime.now(),
    );
  }

  factory RoomRealtimeMessage.syncReady() {
    return RoomRealtimeMessage(
      type: RoomRealtimeMessageType.syncReady,
      timestamp: DateTime.now(),
    );
  }

  factory RoomRealtimeMessage.commandAccepted(String command) {
    return RoomRealtimeMessage(
      type: RoomRealtimeMessageType.commandAccepted,
      timestamp: DateTime.now(),
      payload: <String, String>{'command': command},
    );
  }

  factory RoomRealtimeMessage.phaseChanged(String phase) {
    return RoomRealtimeMessage(
      type: RoomRealtimeMessageType.phaseChanged,
      timestamp: DateTime.now(),
      payload: <String, String>{'phase': phase},
    );
  }

  factory RoomRealtimeMessage.participantJoined(int seat) {
    return RoomRealtimeMessage(
      type: RoomRealtimeMessageType.participantJoined,
      timestamp: DateTime.now(),
      payload: <String, String>{'seat': '$seat'},
    );
  }

  factory RoomRealtimeMessage.cardPlayed(String cardId) {
    return RoomRealtimeMessage(
      type: RoomRealtimeMessageType.cardPlayed,
      timestamp: DateTime.now(),
      payload: <String, String>{'cardId': cardId},
    );
  }

  factory RoomRealtimeMessage.resetAcknowledged() {
    return RoomRealtimeMessage(
      type: RoomRealtimeMessageType.resetAcknowledged,
      timestamp: DateTime.now(),
    );
  }

  final RoomRealtimeMessageType type;
  final DateTime timestamp;
  final Map<String, String> payload;
}
