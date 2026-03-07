import '../../core/models/player_profile.dart';
import '../../features/rooms/domain/room_summary.dart';

final class RoomSeedData {
  static const rooms = <RoomSummary>[
    RoomSummary(
      id: 'room-signal-01',
      title: '信号牌局 冲分房',
      gameModuleId: 'signal-deck',
      host: PlayerProfile(
        id: 'u-101',
        nickname: 'Nova',
        level: 18,
        isOnline: true,
      ),
      currentPlayers: 4,
      capacity: 6,
      isVoiceEnabled: true,
      isRanked: true,
      status: RoomStatus.waiting,
    ),
    RoomSummary(
      id: 'room-chaos-02',
      title: '混沌派对 周五局',
      gameModuleId: 'chaos-mixer',
      host: PlayerProfile(
        id: 'u-205',
        nickname: 'Kite',
        level: 11,
        isOnline: true,
      ),
      currentPlayers: 7,
      capacity: 12,
      isVoiceEnabled: true,
      isRanked: false,
      status: RoomStatus.waiting,
    ),
    RoomSummary(
      id: 'room-vote-03',
      title: '午夜投票 熟人局',
      gameModuleId: 'midnight-vote',
      host: PlayerProfile(
        id: 'u-302',
        nickname: 'Echo',
        level: 24,
        isOnline: true,
      ),
      currentPlayers: 8,
      capacity: 10,
      isVoiceEnabled: true,
      isRanked: false,
      status: RoomStatus.inGame,
    ),
  ];
}
