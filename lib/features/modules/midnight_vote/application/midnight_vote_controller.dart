import 'dart:math';

import 'package:flutter/foundation.dart';

class MidnightCase {
  const MidnightCase({
    required this.id,
    required this.culpritId,
    required this.suspects,
    required this.clueIds,
  });

  final String id;
  final String culpritId;
  final List<String> suspects;
  final List<String> clueIds;
}

class MidnightRoundLog {
  const MidnightRoundLog({
    required this.round,
    required this.caseId,
    required this.playerVote,
    required this.aiVote,
    required this.culpritId,
    required this.playerCorrect,
    required this.aiCorrect,
  });

  final int round;
  final String caseId;
  final String playerVote;
  final String aiVote;
  final String culpritId;
  final bool playerCorrect;
  final bool aiCorrect;
}

class MidnightVoteState {
  const MidnightVoteState({
    required this.round,
    required this.maxRounds,
    required this.playerScore,
    required this.aiScore,
    required this.insightTokens,
    required this.currentCase,
    required this.revealedClueCount,
    required this.logs,
    required this.isFinished,
  });

  final int round;
  final int maxRounds;
  final int playerScore;
  final int aiScore;
  final int insightTokens;
  final MidnightCase currentCase;
  final int revealedClueCount;
  final List<MidnightRoundLog> logs;
  final bool isFinished;
}

class MidnightVoteController extends ChangeNotifier {
  MidnightVoteController()
    : _random = Random(91),
      _state = _buildInitialState(Random(91));

  static const int _maxRounds = 5;

  final Random _random;
  MidnightVoteState _state;

  MidnightVoteState get state => _state;

  static MidnightVoteState _buildInitialState(Random random) {
    final initialCase = _casePool[random.nextInt(_casePool.length)];
    return MidnightVoteState(
      round: 1,
      maxRounds: _maxRounds,
      playerScore: 0,
      aiScore: 0,
      insightTokens: 2,
      currentCase: initialCase,
      revealedClueCount: 1,
      logs: const [],
      isFinished: false,
    );
  }

  void revealClue() {
    if (_state.isFinished) {
      return;
    }
    if (_state.insightTokens <= 0) {
      return;
    }
    if (_state.revealedClueCount >= _state.currentCase.clueIds.length) {
      return;
    }

    _state = MidnightVoteState(
      round: _state.round,
      maxRounds: _state.maxRounds,
      playerScore: _state.playerScore,
      aiScore: _state.aiScore,
      insightTokens: _state.insightTokens - 1,
      currentCase: _state.currentCase,
      revealedClueCount: _state.revealedClueCount + 1,
      logs: _state.logs,
      isFinished: _state.isFinished,
    );
    notifyListeners();
  }

  void vote(String suspectId) {
    if (_state.isFinished) {
      return;
    }

    final aiVote = _aiVoteFor(_state.currentCase);
    final playerCorrect = suspectId == _state.currentCase.culpritId;
    final aiCorrect = aiVote == _state.currentCase.culpritId;
    final playerScore = _state.playerScore + (playerCorrect ? 3 : 0);
    final aiScore = _state.aiScore + (aiCorrect ? 3 : 0);

    final logs = [
      MidnightRoundLog(
        round: _state.round,
        caseId: _state.currentCase.id,
        playerVote: suspectId,
        aiVote: aiVote,
        culpritId: _state.currentCase.culpritId,
        playerCorrect: playerCorrect,
        aiCorrect: aiCorrect,
      ),
      ..._state.logs,
    ];

    final finished = _state.round >= _state.maxRounds;
    final nextCase = finished
        ? _state.currentCase
        : _randomNextCase(_state.currentCase.id);
    final nextInsight = _state.insightTokens + (playerCorrect ? 0 : 1);

    _state = MidnightVoteState(
      round: finished ? _state.round : _state.round + 1,
      maxRounds: _state.maxRounds,
      playerScore: playerScore,
      aiScore: aiScore,
      insightTokens: nextInsight.clamp(0, 4),
      currentCase: nextCase,
      revealedClueCount: 1,
      logs: logs,
      isFinished: finished,
    );
    notifyListeners();
  }

  void reset() {
    final seed = _random.nextInt(999999);
    _state = _buildInitialState(Random(seed));
    notifyListeners();
  }

  String _aiVoteFor(MidnightCase roomCase) {
    final bias = _random.nextDouble();
    if (bias < 0.62) {
      return roomCase.culpritId;
    }
    final decoys = roomCase.suspects
        .where((suspect) => suspect != roomCase.culpritId)
        .toList(growable: false);
    return decoys[_random.nextInt(decoys.length)];
  }

  MidnightCase _randomNextCase(String currentCaseId) {
    final candidates = _casePool
        .where((item) => item.id != currentCaseId)
        .toList(growable: false);
    return candidates[_random.nextInt(candidates.length)];
  }

  static const List<MidnightCase> _casePool = [
    MidnightCase(
      id: 'case-a',
      culpritId: 'vex',
      suspects: ['vex', 'lyra', 'kade', 'mina'],
      clueIds: ['a-1', 'a-2', 'a-3'],
    ),
    MidnightCase(
      id: 'case-b',
      culpritId: 'mina',
      suspects: ['mina', 'nox', 'sora', 'dax'],
      clueIds: ['b-1', 'b-2', 'b-3'],
    ),
    MidnightCase(
      id: 'case-c',
      culpritId: 'sora',
      suspects: ['sora', 'vex', 'yuri', 'kade'],
      clueIds: ['c-1', 'c-2', 'c-3'],
    ),
  ];
}
