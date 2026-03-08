import 'dart:math';

import 'package:flutter/foundation.dart';

class ChaosChallenge {
  const ChaosChallenge({
    required this.id,
    required this.basePoints,
    required this.timeLimitSec,
    required this.iconCode,
  });

  final String id;
  final int basePoints;
  final int timeLimitSec;
  final String iconCode;
}

enum ChaosRoundOutcome { success, failed }

class ChaosRoundLog {
  const ChaosRoundLog({
    required this.round,
    required this.challenge,
    required this.outcome,
    required this.pointsAwarded,
    required this.streakAfterRound,
  });

  final int round;
  final ChaosChallenge challenge;
  final ChaosRoundOutcome outcome;
  final int pointsAwarded;
  final int streakAfterRound;
}

class ChaosMixerState {
  const ChaosMixerState({
    required this.round,
    required this.maxRounds,
    required this.score,
    required this.streak,
    required this.bestStreak,
    required this.rerollCharges,
    required this.currentChallenge,
    required this.logs,
    required this.isFinished,
  });

  final int round;
  final int maxRounds;
  final int score;
  final int streak;
  final int bestStreak;
  final int rerollCharges;
  final ChaosChallenge currentChallenge;
  final List<ChaosRoundLog> logs;
  final bool isFinished;
}

class ChaosMixerController extends ChangeNotifier {
  ChaosMixerController()
    : _random = Random(37),
      _state = _buildInitialState(Random(37));

  static const int _maxRounds = 8;
  static const int _startingRerollCharges = 2;

  final Random _random;
  ChaosMixerState _state;

  ChaosMixerState get state => _state;

  static ChaosMixerState _buildInitialState(Random random) {
    final challenge = _randomChallenge(random, previousId: null);
    return ChaosMixerState(
      round: 1,
      maxRounds: _maxRounds,
      score: 0,
      streak: 0,
      bestStreak: 0,
      rerollCharges: _startingRerollCharges,
      currentChallenge: challenge,
      logs: const [],
      isFinished: false,
    );
  }

  void completeRound({required bool success}) {
    if (_state.isFinished) {
      return;
    }

    final multiplier = success ? 1 + _state.streak.clamp(0, 2) : 0;
    final pointsAwarded = success
        ? _state.currentChallenge.basePoints * multiplier
        : 0;
    final nextStreak = success ? _state.streak + 1 : 0;
    final nextBestStreak = nextStreak > _state.bestStreak
        ? nextStreak
        : _state.bestStreak;
    final nextScore = _state.score + pointsAwarded;

    final logs = [
      ChaosRoundLog(
        round: _state.round,
        challenge: _state.currentChallenge,
        outcome: success ? ChaosRoundOutcome.success : ChaosRoundOutcome.failed,
        pointsAwarded: pointsAwarded,
        streakAfterRound: nextStreak,
      ),
      ..._state.logs,
    ];

    final isFinalRound = _state.round >= _state.maxRounds;
    final isFinished = isFinalRound;
    final nextRound = isFinished ? _state.round : _state.round + 1;
    final nextChallenge = isFinished
        ? _state.currentChallenge
        : _randomChallenge(_random, previousId: _state.currentChallenge.id);

    _state = ChaosMixerState(
      round: nextRound,
      maxRounds: _state.maxRounds,
      score: nextScore,
      streak: nextStreak,
      bestStreak: nextBestStreak,
      rerollCharges: _state.rerollCharges,
      currentChallenge: nextChallenge,
      logs: logs,
      isFinished: isFinished,
    );

    notifyListeners();
  }

  void rerollChallenge() {
    if (_state.isFinished || _state.rerollCharges <= 0) {
      return;
    }

    final nextChallenge = _randomChallenge(
      _random,
      previousId: _state.currentChallenge.id,
    );
    _state = ChaosMixerState(
      round: _state.round,
      maxRounds: _state.maxRounds,
      score: _state.score,
      streak: _state.streak,
      bestStreak: _state.bestStreak,
      rerollCharges: _state.rerollCharges - 1,
      currentChallenge: nextChallenge,
      logs: _state.logs,
      isFinished: _state.isFinished,
    );
    notifyListeners();
  }

  void reset() {
    final seed = _random.nextInt(999999);
    _state = _buildInitialState(Random(seed));
    notifyListeners();
  }

  static ChaosChallenge _randomChallenge(
    Random random, {
    required String? previousId,
  }) {
    final candidates = _challengeBank
        .where((challenge) => challenge.id != previousId)
        .toList(growable: false);
    return candidates[random.nextInt(candidates.length)];
  }

  static const List<ChaosChallenge> _challengeBank = [
    ChaosChallenge(
      id: 'mimic',
      basePoints: 6,
      timeLimitSec: 30,
      iconCode: 'ACT',
    ),
    ChaosChallenge(
      id: 'rapid-qa',
      basePoints: 7,
      timeLimitSec: 20,
      iconCode: 'SPD',
    ),
    ChaosChallenge(
      id: 'rhythm',
      basePoints: 8,
      timeLimitSec: 25,
      iconCode: 'RHY',
    ),
    ChaosChallenge(
      id: 'draw-and-guess',
      basePoints: 6,
      timeLimitSec: 20,
      iconCode: 'DRW',
    ),
    ChaosChallenge(
      id: 'sound-only',
      basePoints: 7,
      timeLimitSec: 24,
      iconCode: 'SFX',
    ),
    ChaosChallenge(
      id: 'frozen-pose',
      basePoints: 5,
      timeLimitSec: 22,
      iconCode: 'POS',
    ),
    ChaosChallenge(
      id: 'reverse-story',
      basePoints: 8,
      timeLimitSec: 28,
      iconCode: 'PUZ',
    ),
    ChaosChallenge(
      id: 'emoji-speak',
      basePoints: 6,
      timeLimitSec: 18,
      iconCode: 'EMJ',
    ),
  ];
}
