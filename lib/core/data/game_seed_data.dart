import '../models/game_module.dart';

final class GameSeedData {
  static const modules = <GameModule>[
    GameModule(
      id: 'signal-deck',
      name: 'Signal Deck',
      tagline: 'Fast-paced tactical card play',
      summary:
          'A turn-based card game built around hand combos and table chemistry.',
      category: GameCategory.card,
      tempo: MatchTempo.quick,
      minPlayers: 3,
      maxPlayers: 6,
      readiness: 0.92,
      isFeatured: true,
    ),
    GameModule(
      id: 'midnight-vote',
      name: 'Midnight Vote',
      tagline: 'Social deduction with brisk votes',
      summary:
          'A hidden-role case file game focused on clue reveals and vote timing.',
      category: GameCategory.bluff,
      tempo: MatchTempo.quick,
      minPlayers: 4,
      maxPlayers: 10,
      readiness: 0.87,
      isFeatured: true,
    ),
    GameModule(
      id: 'orbit-merchant',
      name: 'Orbit Merchant',
      tagline: 'Mid-weight strategy trading',
      summary:
          'Trade cargo, read the market, and grow net worth across a short route.',
      category: GameCategory.strategy,
      tempo: MatchTempo.deep,
      minPlayers: 2,
      maxPlayers: 4,
      readiness: 0.76,
      isFeatured: false,
    ),
    GameModule(
      id: 'chaos-mixer',
      name: 'Chaos Mixer',
      tagline: 'Party minigame collection',
      summary:
          'A rotating party challenge deck mixing acting, guessing, rhythm, and chaos.',
      category: GameCategory.party,
      tempo: MatchTempo.standard,
      minPlayers: 2,
      maxPlayers: 12,
      readiness: 0.95,
      isFeatured: true,
    ),
  ];
}
