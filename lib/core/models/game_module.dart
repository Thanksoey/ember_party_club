enum GameCategory { card, party, bluff, strategy }

enum MatchTempo { quick, standard, deep }

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
