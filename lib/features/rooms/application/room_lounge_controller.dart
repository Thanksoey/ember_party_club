import 'package:flutter/foundation.dart';

import '../../../core/models/game_module.dart';
import '../../../core/models/player_profile.dart';
import '../../modules/application/game_module_registry.dart';
import '../domain/room_summary.dart';

class RoomLoungeController extends ChangeNotifier {
  RoomLoungeController.seeded({
    required List<RoomSummary> rooms,
    required GameModuleRegistry registry,
  })  : _rooms = List<RoomSummary>.of(rooms),
        _registry = registry;

  final List<RoomSummary> _rooms;
  final GameModuleRegistry _registry;
  int _createdRoomCount = 0;

  static const PlayerProfile _localHost = PlayerProfile(
    id: 'local-host',
    nickname: 'Captain',
    level: 1,
    isOnline: true,
  );

  List<RoomSummary> get rooms => List.unmodifiable(_rooms);

  List<GameModule> get availableModules => _registry.allModules;

  int get liveRoomCount => _rooms.length;

  int get liveSeatCount => _rooms.fold(0, (sum, room) => sum + room.currentPlayers);

  RoomSummary? get hottestRoom {
    if (_rooms.isEmpty) {
      return null;
    }

    final sortedRooms = [..._rooms]..sort((left, right) => right.fillRatio.compareTo(left.fillRatio));
    return sortedRooms.first;
  }

  GameModule? moduleFor(RoomSummary room) {
    return _registry.findById(room.gameModuleId);
  }

  RoomSummary? findRoomById(String roomId) {
    for (final room in _rooms) {
      if (room.id == roomId) {
        return room;
      }
    }
    return null;
  }

  RoomSummary createRoom({
    required String title,
    required GameModule module,
    required int capacity,
    required bool isVoiceEnabled,
    required bool isRanked,
  }) {
    _createdRoomCount += 1;
    final room = RoomSummary(
      id: 'room-local-${DateTime.now().microsecondsSinceEpoch}-$_createdRoomCount',
      title: title,
      gameModuleId: module.id,
      host: _localHost,
      currentPlayers: 1,
      capacity: capacity,
      isVoiceEnabled: isVoiceEnabled,
      isRanked: isRanked,
      status: RoomStatus.waiting,
    );
    _rooms.insert(0, room);
    notifyListeners();
    return room;
  }

  RoomSummary? markRoomInGame(String roomId) {
    final index = _rooms.indexWhere((room) => room.id == roomId);
    if (index < 0) {
      return null;
    }

    final current = _rooms[index];
    final updated = current.copyWith(status: RoomStatus.inGame);
    _rooms[index] = updated;
    notifyListeners();
    return updated;
  }

  RoomSummary? quickMatchTarget() {
    final waitingRooms = _rooms.where((room) => room.status == RoomStatus.waiting).toList(growable: false);
    if (waitingRooms.isEmpty) {
      return hottestRoom;
    }
    waitingRooms.sort((left, right) => right.fillRatio.compareTo(left.fillRatio));
    return waitingRooms.first;
  }
}
