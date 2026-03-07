import '../models/game_module.dart';

final class GameSeedData {
  static const modules = <GameModule>[
    GameModule(
      id: 'signal-deck',
      name: '信号牌局',
      tagline: '快节奏卡牌配合',
      summary: '围绕手牌联动和团队默契的回合制卡牌游戏，适合聚会开局热场。',
      category: GameCategory.card,
      tempo: MatchTempo.quick,
      minPlayers: 3,
      maxPlayers: 6,
      readiness: 0.92,
      isFeatured: true,
    ),
    GameModule(
      id: 'midnight-vote',
      name: '午夜投票',
      tagline: '轻推理阵营博弈',
      summary: '每局十分钟的隐藏身份玩法，重点在语音互动和投票节奏控制。',
      category: GameCategory.bluff,
      tempo: MatchTempo.quick,
      minPlayers: 4,
      maxPlayers: 10,
      readiness: 0.87,
      isFeatured: true,
    ),
    GameModule(
      id: 'orbit-merchant',
      name: '轨道商旅',
      tagline: '中度策略交易',
      summary: '资源交换和卡牌构筑结合，适合熟人长期房间和赛季排行。',
      category: GameCategory.strategy,
      tempo: MatchTempo.deep,
      minPlayers: 2,
      maxPlayers: 4,
      readiness: 0.76,
      isFeatured: false,
    ),
    GameModule(
      id: 'chaos-mixer',
      name: '混沌派对',
      tagline: '派对小游戏合集',
      summary: '把抢答、表演、你画我猜和惩罚轮盘整合进一个聚会房间。',
      category: GameCategory.party,
      tempo: MatchTempo.standard,
      minPlayers: 2,
      maxPlayers: 12,
      readiness: 0.95,
      isFeatured: true,
    ),
  ];
}
