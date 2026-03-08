import 'dart:math';

import 'package:flutter/foundation.dart';

import '../domain/signal_card.dart';
import '../domain/signal_deck_state.dart';

class SignalDeckController extends ChangeNotifier {
  SignalDeckController()
    : _random = Random(7),
      _state = _buildInitialState(Random(7));

  static const int _maxRounds = 6;

  final Random _random;
  SignalDeckState _state;

  SignalDeckState get state => _state;

  static SignalDeckState _buildInitialState(Random random) {
    final deck = _buildDeck();
    deck.shuffle(random);
    final playerHand = deck.take(4).toList(growable: false);
    final rivalHand = deck.skip(4).take(4).toList(growable: false);
    final restDeck = deck.skip(8).toList(growable: false);

    return SignalDeckState(
      round: 1,
      maxRounds: _maxRounds,
      battleSuit: SignalSuit.values[random.nextInt(SignalSuit.values.length)],
      player: SignalPlayerState(
        score: 0,
        roundsWon: 0,
        momentum: 0,
        hand: playerHand,
        playedCard: null,
      ),
      rival: SignalPlayerState(
        score: 0,
        roundsWon: 0,
        momentum: 0,
        hand: rivalHand,
        playedCard: null,
      ),
      deck: restDeck,
      logs: const [],
      isFinished: false,
      winner: null,
    );
  }

  static List<SignalCard> _buildDeck() {
    return <SignalCard>[
      const SignalCard(
        id: 'e1',
        suit: SignalSuit.ember,
        power: 3,
        ability: SignalAbility.chain,
      ),
      const SignalCard(
        id: 'e2',
        suit: SignalSuit.ember,
        power: 4,
        ability: SignalAbility.surge,
      ),
      const SignalCard(
        id: 'e3',
        suit: SignalSuit.ember,
        power: 5,
        ability: SignalAbility.chain,
      ),
      const SignalCard(
        id: 'e4',
        suit: SignalSuit.ember,
        power: 2,
        ability: SignalAbility.anchor,
      ),
      const SignalCard(
        id: 't1',
        suit: SignalSuit.tide,
        power: 3,
        ability: SignalAbility.counter,
      ),
      const SignalCard(
        id: 't2',
        suit: SignalSuit.tide,
        power: 4,
        ability: SignalAbility.anchor,
      ),
      const SignalCard(
        id: 't3',
        suit: SignalSuit.tide,
        power: 5,
        ability: SignalAbility.counter,
      ),
      const SignalCard(
        id: 't4',
        suit: SignalSuit.tide,
        power: 2,
        ability: SignalAbility.surge,
      ),
      const SignalCard(
        id: 's1',
        suit: SignalSuit.spark,
        power: 3,
        ability: SignalAbility.surge,
      ),
      const SignalCard(
        id: 's2',
        suit: SignalSuit.spark,
        power: 4,
        ability: SignalAbility.chain,
      ),
      const SignalCard(
        id: 's3',
        suit: SignalSuit.spark,
        power: 5,
        ability: SignalAbility.surge,
      ),
      const SignalCard(
        id: 's4',
        suit: SignalSuit.spark,
        power: 2,
        ability: SignalAbility.anchor,
      ),
    ];
  }

  void playCard(SignalCard selectedCard) {
    if (_state.isFinished) {
      return;
    }

    final rivalCard = _chooseRivalCard(
      hand: _state.rival.hand,
      opponentCard: selectedCard,
      selfScore: _state.rival.score,
      opponentScore: _state.player.score,
      previousCard: _state.rival.playedCard,
      round: _state.round,
      battleSuit: _state.battleSuit,
      momentum: _state.rival.momentum,
    );

    final playerPower = _resolvePower(
      card: selectedCard,
      opponentCard: rivalCard,
      previousCard: _state.player.playedCard,
      selfScore: _state.player.score,
      opponentScore: _state.rival.score,
      round: _state.round,
      battleSuit: _state.battleSuit,
      momentum: _state.player.momentum,
    );
    final rivalPower = _resolvePower(
      card: rivalCard,
      opponentCard: selectedCard,
      previousCard: _state.rival.playedCard,
      selfScore: _state.rival.score,
      opponentScore: _state.player.score,
      round: _state.round,
      battleSuit: _state.battleSuit,
      momentum: _state.rival.momentum,
    );

    var playerScore = _state.player.score;
    var rivalScore = _state.rival.score;
    var playerRoundsWon = _state.player.roundsWon;
    var rivalRoundsWon = _state.rival.roundsWon;
    var playerMomentum = _state.player.momentum;
    var rivalMomentum = _state.rival.momentum;
    late final SignalRoundOutcome outcome;

    if (playerPower > rivalPower) {
      playerScore += 3;
      playerRoundsWon += 1;
      playerMomentum = _nextMomentum(playerMomentum + 1);
      rivalMomentum = 0;
      outcome = SignalRoundOutcome.playerWin;
    } else if (playerPower < rivalPower) {
      rivalScore += 3;
      rivalRoundsWon += 1;
      rivalMomentum = _nextMomentum(rivalMomentum + 1);
      playerMomentum = 0;
      outcome = SignalRoundOutcome.rivalWin;
    } else {
      playerScore += 1;
      rivalScore += 1;
      playerMomentum = _nextMomentum(playerMomentum - 1);
      rivalMomentum = _nextMomentum(rivalMomentum - 1);
      outcome = SignalRoundOutcome.draw;
    }

    final remainingDeck = [..._state.deck];
    final nextPlayerHand = _drawReplacement(
      currentHand: _state.player.hand,
      usedCard: selectedCard,
      deck: remainingDeck,
    );
    final nextRivalHand = _drawReplacement(
      currentHand: _state.rival.hand,
      usedCard: rivalCard,
      deck: remainingDeck,
    );

    final logs = [
      SignalRoundLog(
        round: _state.round,
        playerCard: selectedCard,
        rivalCard: rivalCard,
        playerPower: playerPower,
        rivalPower: rivalPower,
        outcome: outcome,
      ),
      ..._state.logs,
    ];

    final hasMoreRounds = _state.round < _state.maxRounds;
    final isFinished =
        !hasMoreRounds || nextPlayerHand.isEmpty || nextRivalHand.isEmpty;
    final nextBattleSuit = isFinished
        ? _state.battleSuit
        : _nextBattleSuit(_state.battleSuit);
    final winner = _resolveWinner(
      playerScore: playerScore,
      rivalScore: rivalScore,
      playerRoundsWon: playerRoundsWon,
      rivalRoundsWon: rivalRoundsWon,
      isFinished: isFinished,
    );

    _state = SignalDeckState(
      round: isFinished ? _state.round : _state.round + 1,
      maxRounds: _state.maxRounds,
      battleSuit: nextBattleSuit,
      player: SignalPlayerState(
        score: playerScore,
        roundsWon: playerRoundsWon,
        momentum: playerMomentum,
        hand: nextPlayerHand,
        playedCard: selectedCard,
      ),
      rival: SignalPlayerState(
        score: rivalScore,
        roundsWon: rivalRoundsWon,
        momentum: rivalMomentum,
        hand: nextRivalHand,
        playedCard: rivalCard,
      ),
      deck: remainingDeck,
      logs: logs,
      isFinished: isFinished,
      winner: winner,
    );

    notifyListeners();
  }

  void reset() {
    final seed = _random.nextInt(999999);
    _state = _buildInitialState(Random(seed));
    notifyListeners();
  }

  static SignalCard _chooseRivalCard({
    required List<SignalCard> hand,
    required SignalCard opponentCard,
    required int selfScore,
    required int opponentScore,
    required SignalCard? previousCard,
    required int round,
    required SignalSuit battleSuit,
    required int momentum,
  }) {
    final ranked = [...hand]
      ..sort(
        (left, right) =>
            _resolvePower(
              card: right,
              opponentCard: opponentCard,
              previousCard: previousCard,
              selfScore: selfScore,
              opponentScore: opponentScore,
              round: round,
              battleSuit: battleSuit,
              momentum: momentum,
            ).compareTo(
              _resolvePower(
                card: left,
                opponentCard: opponentCard,
                previousCard: previousCard,
                selfScore: selfScore,
                opponentScore: opponentScore,
                round: round,
                battleSuit: battleSuit,
                momentum: momentum,
              ),
            ),
      );
    return ranked.first;
  }

  static int _resolvePower({
    required SignalCard card,
    required SignalCard opponentCard,
    required SignalCard? previousCard,
    required int selfScore,
    required int opponentScore,
    required int round,
    required SignalSuit battleSuit,
    required int momentum,
  }) {
    var score = card.power;
    score += momentum;
    if (card.suit == battleSuit) {
      score += 1;
    }

    switch (card.ability) {
      case SignalAbility.chain:
        if (previousCard?.suit == card.suit) {
          score += 2;
        }
        break;
      case SignalAbility.counter:
        if (opponentCard.suit == SignalSuit.ember) {
          score += 2;
        }
        break;
      case SignalAbility.surge:
        if (selfScore < opponentScore || round >= 5) {
          score += 1;
        }
        break;
      case SignalAbility.anchor:
        if (card.power <= 3 && opponentCard.power >= 4) {
          score += 2;
        }
        break;
    }

    return score;
  }

  SignalSuit _nextBattleSuit(SignalSuit current) {
    final options = SignalSuit.values
        .where((suit) => suit != current)
        .toList(growable: false);
    return options[_random.nextInt(options.length)];
  }

  static int _nextMomentum(int value) {
    if (value < 0) {
      return 0;
    }
    if (value > 2) {
      return 2;
    }
    return value;
  }

  static List<SignalCard> _drawReplacement({
    required List<SignalCard> currentHand,
    required SignalCard usedCard,
    required List<SignalCard> deck,
  }) {
    final updatedHand = currentHand
        .where((card) => card.id != usedCard.id)
        .toList(growable: true);
    if (deck.isNotEmpty) {
      updatedHand.add(deck.removeAt(0));
    }
    return List.unmodifiable(updatedHand);
  }

  static SignalMatchWinner? _resolveWinner({
    required int playerScore,
    required int rivalScore,
    required int playerRoundsWon,
    required int rivalRoundsWon,
    required bool isFinished,
  }) {
    if (!isFinished) {
      return null;
    }
    if (playerScore > rivalScore) {
      return SignalMatchWinner.player;
    }
    if (rivalScore > playerScore) {
      return SignalMatchWinner.rival;
    }
    if (playerRoundsWon > rivalRoundsWon) {
      return SignalMatchWinner.player;
    }
    if (rivalRoundsWon > playerRoundsWon) {
      return SignalMatchWinner.rival;
    }
    return SignalMatchWinner.draw;
  }
}
