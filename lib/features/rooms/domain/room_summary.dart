import '../../../core/models/player_profile.dart';

enum RoomStatus {
  waiting,
  inGame,
  settling,
}

class RoomSummary {
  const RoomSummary({
    required this.id,
    required this.title,
    required this.gameModuleId,
    required this.host,
    required this.currentPlayers,
    required this.capacity,
    required this.isVoiceEnabled,
    required this.isRanked,
    required this.status,
  });

  final String id;
  final String title;
  final String gameModuleId;
  final PlayerProfile host;
  final int currentPlayers;
  final int capacity;
  final bool isVoiceEnabled;
  final bool isRanked;
  final RoomStatus status;

  double get fillRatio => currentPlayers / capacity;

  int get remainingSeats => capacity - currentPlayers;

  RoomSummary copyWith({
    String? id,
    String? title,
    String? gameModuleId,
    PlayerProfile? host,
    int? currentPlayers,
    int? capacity,
    bool? isVoiceEnabled,
    bool? isRanked,
    RoomStatus? status,
  }) {
    return RoomSummary(
      id: id ?? this.id,
      title: title ?? this.title,
      gameModuleId: gameModuleId ?? this.gameModuleId,
      host: host ?? this.host,
      currentPlayers: currentPlayers ?? this.currentPlayers,
      capacity: capacity ?? this.capacity,
      isVoiceEnabled: isVoiceEnabled ?? this.isVoiceEnabled,
      isRanked: isRanked ?? this.isRanked,
      status: status ?? this.status,
    );
  }
}
