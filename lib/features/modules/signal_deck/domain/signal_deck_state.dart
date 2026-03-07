import 'signal_card.dart';

class SignalPlayerState {
  const SignalPlayerState({
    required this.score,
    required this.roundsWon,
    required this.hand,
    required this.playedCard,
  });

  final int score;
  final int roundsWon;
  final List<SignalCard> hand;
  final SignalCard? playedCard;

  SignalPlayerState copyWith({
    int? score,
    int? roundsWon,
    List<SignalCard>? hand,
    SignalCard? playedCard,
    bool clearPlayedCard = false,
  }) {
    return SignalPlayerState(
      score: score ?? this.score,
      roundsWon: roundsWon ?? this.roundsWon,
      hand: hand ?? this.hand,
      playedCard: clearPlayedCard ? null : playedCard ?? this.playedCard,
    );
  }
}

enum SignalRoundOutcome {
  playerWin,
  rivalWin,
  draw,
}

enum SignalMatchWinner {
  player,
  rival,
  draw,
}

class SignalRoundLog {
  const SignalRoundLog({
    required this.round,
    required this.playerCard,
    required this.rivalCard,
    required this.playerPower,
    required this.rivalPower,
    required this.outcome,
  });

  final int round;
  final SignalCard playerCard;
  final SignalCard rivalCard;
  final int playerPower;
  final int rivalPower;
  final SignalRoundOutcome outcome;
}

class SignalDeckState {
  const SignalDeckState({
    required this.round,
    required this.maxRounds,
    required this.player,
    required this.rival,
    required this.deck,
    required this.logs,
    required this.isFinished,
    required this.winner,
  });

  final int round;
  final int maxRounds;
  final SignalPlayerState player;
  final SignalPlayerState rival;
  final List<SignalCard> deck;
  final List<SignalRoundLog> logs;
  final bool isFinished;
  final SignalMatchWinner? winner;
}
