enum GameCategory {
  card('Card'),
  party('Party'),
  bluff('Bluff'),
  strategy('Strategy');

  const GameCategory(this.label);

  final String label;
}

enum MatchTempo {
  quick('15 min'),
  standard('30 min'),
  deep('45+ min');

  const MatchTempo(this.label);

  final String label;
}

class GameModule {
  const GameModule({
    required this.id,
    required this.name,
    required this.tagline,
    required this.summary,
    required this.category,
    required this.tempo,
    required this.minPlayers,
    required this.maxPlayers,
    required this.readiness,
    required this.isFeatured,
  });

  final String id;
  final String name;
  final String tagline;
  final String summary;
  final GameCategory category;
  final MatchTempo tempo;
  final int minPlayers;
  final int maxPlayers;
  final double readiness;
  final bool isFeatured;
}

