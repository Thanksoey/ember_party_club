import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../../app/services/app_feedback.dart';
import '../../../../../app/widgets/app_expandable_panel.dart';
import '../../../../../app/widgets/app_fade_in_up.dart';
import '../../../../../app/widgets/app_ornate_card.dart';
import '../../../../../app/widgets/app_panel.dart';
import '../../../../game_session/application/game_guide_preferences.dart';
import '../../../../game_session/application/game_room_session_controller.dart';
import '../../../../game_session/presentation/widgets/game_guide_sheet.dart';
import '../../../../game_session/presentation/widgets/game_room_session_panel.dart';
import '../../../../game_session/presentation/widgets/game_session_scaffold.dart';
import '../../application/signal_deck_controller.dart';
import '../../domain/signal_card.dart';
import '../../domain/signal_deck_state.dart';
import '../widgets/signal_hand_fan.dart';

class SignalDeckPage extends StatefulWidget {
  const SignalDeckPage({
    super.key,
    required this.controller,
    this.roomSessionController,
    this.disposeRoomSessionController = false,
  });

  final SignalDeckController controller;
  final GameRoomSessionController? roomSessionController;
  final bool disposeRoomSessionController;

  @override
  State<SignalDeckPage> createState() => _SignalDeckPageState();
}

class _SignalDeckPageState extends State<SignalDeckPage> {
  static const _guideId = 'signal_deck';

  int _arenaPulseSeed = 0;
  int _arenaCastSeed = 0;
  int _arenaOutcomeSeed = 0;
  int _arenaFinishSeed = 0;
  int _handDrawSeed = 0;
  int _handDiscardSeed = 0;
  int _lastLogCount = 0;
  bool _lastFinished = false;
  bool _hasCheckedAutoGuide = false;
  List<String> _lastPlayerHandIds = const [];
  SignalSuit? _arenaCastSuit;
  int _arenaCastPower = 0;
  SignalRoundOutcome? _arenaOutcome;
  SignalMatchWinner? _arenaFinishWinner;
  SignalCard? _drawnHandCard;
  SignalCard? _discardedHandCard;
  final GlobalKey _guideButtonKey = GlobalKey(
    debugLabel: 'signal-guide-button',
  );
  final GlobalKey _arenaGuideKey = GlobalKey(debugLabel: 'signal-arena');
  final GlobalKey _handGuideKey = GlobalKey(debugLabel: 'signal-hand');
  final GlobalKey _logGuideKey = GlobalKey(debugLabel: 'signal-log');

  @override
  void initState() {
    super.initState();
    _lastPlayerHandIds = widget.controller.state.player.hand
        .map((card) => card.id)
        .toList(growable: false);
    widget.controller.addListener(_handleStateChange);
    _handleStateChange();
    widget.roomSessionController?.startSession();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_maybeShowGuide());
    });
  }

  @override
  void didUpdateWidget(covariant SignalDeckPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleStateChange);
      widget.controller.addListener(_handleStateChange);
      _handleStateChange();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleStateChange);
    if (widget.disposeRoomSessionController) {
      widget.roomSessionController?.dispose();
    }
    super.dispose();
  }

  void _handleStateChange() {
    final roomSessionController = widget.roomSessionController;
    final state = widget.controller.state;

    if (roomSessionController != null) {
      roomSessionController.handleMatchState(
        hasAnyRound: state.logs.isNotEmpty,
        isFinished: state.isFinished,
      );
    }

    if (_lastLogCount != state.logs.length) {
      final currentHandIds = state.player.hand
          .map((card) => card.id)
          .toList(growable: false);
      SignalCard? drawnCard;
      for (final card in state.player.hand) {
        if (!_lastPlayerHandIds.contains(card.id)) {
          drawnCard = card;
          break;
        }
      }
      _lastLogCount = state.logs.length;
      if (mounted && state.logs.isNotEmpty) {
        final latestLog = state.logs.first;
        setState(() {
          _arenaPulseSeed += 1;
          _arenaOutcomeSeed += 1;
          _arenaOutcome = latestLog.outcome;
          _discardedHandCard = latestLog.playerCard;
          _handDiscardSeed += 1;
          _drawnHandCard = drawnCard;
          if (drawnCard != null) {
            _handDrawSeed += 1;
          }
        });
      }
      if (state.logs.isNotEmpty && !state.isFinished) {
        final latestLog = state.logs.first;
        if (drawnCard != null) {
          unawaited(AppFeedback.instance.play(AppFeedbackType.cardDraw));
        }
        switch (latestLog.outcome) {
          case SignalRoundOutcome.playerWin:
            unawaited(AppFeedback.instance.play(AppFeedbackType.roundWin));
          case SignalRoundOutcome.rivalWin:
            unawaited(AppFeedback.instance.play(AppFeedbackType.roundLose));
          case SignalRoundOutcome.draw:
            unawaited(AppFeedback.instance.play(AppFeedbackType.tap));
        }
      }
      _lastPlayerHandIds = currentHandIds;
    }

    if (!_lastFinished && state.isFinished) {
      if (mounted) {
        setState(() {
          _arenaFinishSeed += 1;
          _arenaFinishWinner = state.winner;
        });
      }
      if (state.winner == SignalMatchWinner.player) {
        unawaited(AppFeedback.instance.play(AppFeedbackType.success));
      } else if (state.winner == SignalMatchWinner.rival) {
        unawaited(AppFeedback.instance.play(AppFeedbackType.failure));
      } else {
        unawaited(AppFeedback.instance.play(AppFeedbackType.tap));
      }
    }
    _lastFinished = state.isFinished;
  }

  Future<void> _maybeShowGuide() async {
    if (!mounted || _hasCheckedAutoGuide) {
      return;
    }
    _hasCheckedAutoGuide = true;

    final shouldAutoShow = await GameGuidePreferences.instance.shouldAutoShow(
      _guideId,
    );
    if (!shouldAutoShow || !mounted) {
      return;
    }

    await GameGuidePreferences.instance.markSeen(_guideId);
    if (!mounted) {
      return;
    }
    await _showGuide();
  }

  Future<void> _showGuide() {
    final l10n = context.l10n;
    return showGameGuideSheet(
      context: context,
      title: '${l10n.signalDeckTitle} · ${l10n.howToPlayAction}',
      subtitle: l10n.signalDeckIntro,
      accentColor: const Color(0xFFD15A3A),
      highlightColor: const Color(0xFFFFC46D),
      aura: AppOrnateCardAura.ember,
      actionLabel: l10n.guideReadyAction,
      backLabel: l10n.guideBackAction,
      nextLabel: l10n.guideNextAction,
      skipLabel: l10n.guideSkipAction,
      stepCounterLabelBuilder: l10n.guideStepCounter,
      sections: [
        GameGuideSectionData(
          icon: Icons.flag_rounded,
          title: l10n.guideSectionGoalTitle,
          body: l10n.signalGuideGoalBody,
          targetKey: _arenaGuideKey,
        ),
        GameGuideSectionData(
          icon: Icons.play_circle_outline_rounded,
          title: l10n.guideSectionTurnTitle,
          body: l10n.signalGuideTurnBody,
          targetKey: _handGuideKey,
        ),
        GameGuideSectionData(
          icon: Icons.auto_awesome_rounded,
          title: l10n.guideSectionReopenTitle,
          body: l10n.guideReopenBody,
          targetKey: _guideButtonKey,
          spotlightPadding: const EdgeInsets.all(10),
          spotlightShape: GameGuideSpotlightShape.circle,
        ),
        GameGuideSectionData(
          icon: Icons.tips_and_updates_outlined,
          title: l10n.guideSectionTipsTitle,
          body: l10n.signalGuideTipsBody,
          targetKey: _logGuideKey,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final animations = <Listenable>[widget.controller];
    if (widget.roomSessionController != null) {
      animations.add(widget.roomSessionController!);
    }

    return AnimatedBuilder(
      animation: Listenable.merge(animations),
      builder: (context, _) {
        final theme = Theme.of(context);
        final l10n = context.l10n;
        final state = widget.controller.state;

        return GameSessionScaffold(
          title: l10n.signalDeckTitle,
          subtitle: widget.roomSessionController == null
              ? l10n.signalDeckSubtitle
              : l10n.signalDeckRoomSubtitle,
          statusText: state.isFinished
              ? l10n.signalFinishReason(
                  state.round,
                  state.player.score,
                  state.rival.score,
                  state.player.roundsWon,
                  state.rival.roundsWon,
                )
              : l10n.signalStatus(state.round, state.maxRounds),
          contextPanel: widget.roomSessionController == null
              ? null
              : GameRoomSessionPanel(controller: widget.roomSessionController!),
          metrics: [
            GameSessionMetric(
              label: l10n.youLabel,
              value: l10n.signalPoints(state.player.score),
              icon: Icons.person_rounded,
              accentColor: theme.colorScheme.primary,
            ),
            GameSessionMetric(
              label: l10n.rivalLabel,
              value: l10n.signalPoints(state.rival.score),
              icon: Icons.smart_toy_outlined,
              accentColor: theme.colorScheme.secondary,
            ),
            GameSessionMetric(
              label: l10n.roundsWon,
              value: '${state.player.roundsWon}-${state.rival.roundsWon}',
              icon: Icons.emoji_events_outlined,
              accentColor: const Color(0xFFB36A24),
            ),
            GameSessionMetric(
              label: l10n.matchLabel,
              value: '${state.round} / ${state.maxRounds}',
              icon: Icons.layers_outlined,
              accentColor: theme.colorScheme.tertiary,
            ),
            GameSessionMetric(
              label: l10n.signalMetricBattlefield,
              value: l10n.signalSuitLabel(state.battleSuit),
              icon: Icons.outlined_flag_rounded,
              accentColor: const Color(0xFFBF6332),
            ),
            GameSessionMetric(
              label: l10n.signalMetricMomentum,
              value: '${state.player.momentum}-${state.rival.momentum}',
              icon: Icons.auto_graph_rounded,
              accentColor: const Color(0xFF3A8D7F),
            ),
          ],
          primaryPanel: KeyedSubtree(
            key: _arenaGuideKey,
            child: _BattleArenaPanel(
              state: state,
              pulseSeed: _arenaPulseSeed,
              castSeed: _arenaCastSeed,
              castSuit: _arenaCastSuit,
              castPower: _arenaCastPower,
              outcomeSeed: _arenaOutcomeSeed,
              outcome: _arenaOutcome,
              finishSeed: _arenaFinishSeed,
              finishWinner: _arenaFinishWinner,
            ),
          ),
          appBarActions: [
            KeyedSubtree(
              key: _guideButtonKey,
              child: IconButton(
                key: const ValueKey('game-guide-open'),
                tooltip: l10n.howToPlayAction,
                onPressed: _showGuide,
                icon: const Icon(Icons.auto_awesome_rounded),
              ),
            ),
          ],
          resultPanel: state.isFinished
              ? _ResultPanel(
                  winner: state.winner,
                  onReplay: _handleReplay,
                  finishReason: l10n.signalFinishReason(
                    state.round,
                    state.player.score,
                    state.rival.score,
                    state.player.roundsWon,
                    state.rival.roundsWon,
                  ),
                )
              : null,
          onReset: _handleReplay,
          content: [
            AppFadeInUp(
              order: 0,
              child: KeyedSubtree(
                key: _handGuideKey,
                child: SignalHandFan(
                  title: l10n.yourHand,
                  subtitle: l10n.signalHandSubtitle,
                  accentColor: theme.colorScheme.primary,
                  hand: state.player.hand,
                  battleSuit: state.battleSuit,
                  momentum: state.player.momentum,
                  enabled: !state.isFinished,
                  drawSeed: _handDrawSeed,
                  discardSeed: _handDiscardSeed,
                  drawnCard: _drawnHandCard,
                  discardedCard: _discardedHandCard,
                  onPlay: (card) => _handlePlayCard(card, state),
                ),
              ),
            ),
            const SizedBox(height: 12),
            KeyedSubtree(
              key: _logGuideKey,
              child: AppExpandablePanel(
                icon: Icons.history_rounded,
                title: l10n.roundLog,
                subtitle: state.logs.isEmpty ? l10n.noRoundsPlayed : null,
                accentColor: theme.colorScheme.secondary,
                child: state.logs.isEmpty
                    ? Text(
                        l10n.noRoundsPlayed,
                        style: theme.textTheme.bodyLarge,
                      )
                    : Column(
                        children: state.logs
                            .asMap()
                            .entries
                            .map((entry) {
                              final index = entry.key;
                              final log = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: AppFadeInUp(
                                  order: index,
                                  child: _RoundLogCard(log: log),
                                ),
                              );
                            })
                            .toList(growable: false),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleReplay() {
    unawaited(AppFeedback.instance.play(AppFeedbackType.reset));
    widget.roomSessionController?.resetMatch();
    widget.controller.reset();
    _lastFinished = false;
    _lastPlayerHandIds = widget.controller.state.player.hand
        .map((card) => card.id)
        .toList(growable: false);
    if (!mounted) {
      return;
    }
    setState(() {
      _arenaCastSuit = null;
      _arenaCastPower = 0;
      _arenaOutcome = null;
      _arenaFinishWinner = null;
      _drawnHandCard = null;
      _discardedHandCard = null;
    });
  }

  Future<void> _handlePlayCard(SignalCard card, SignalDeckState state) async {
    _triggerCastFx(card, state);
    unawaited(AppFeedback.instance.play(AppFeedbackType.cardPlay));
    final round = state.round;
    widget.controller.playCard(card);
    widget.roomSessionController?.handleMatchState(
      hasAnyRound: true,
      isFinished: widget.controller.state.isFinished,
    );
    await widget.roomSessionController?.sendCardPlayed(
      cardId: card.id,
      round: round,
    );
  }

  void _triggerCastFx(SignalCard card, SignalDeckState state) {
    if (!mounted) {
      return;
    }
    final effectivePower =
        card.power +
        state.player.momentum +
        (card.suit == state.battleSuit ? 1 : 0);
    setState(() {
      _arenaCastSeed += 1;
      _arenaCastSuit = card.suit;
      _arenaCastPower = effectivePower;
    });
  }
}

class _BattleArenaPanel extends StatefulWidget {
  const _BattleArenaPanel({
    required this.state,
    required this.pulseSeed,
    required this.castSeed,
    required this.castSuit,
    required this.castPower,
    required this.outcomeSeed,
    required this.outcome,
    required this.finishSeed,
    required this.finishWinner,
  });

  final SignalDeckState state;
  final int pulseSeed;
  final int castSeed;
  final SignalSuit? castSuit;
  final int castPower;
  final int outcomeSeed;
  final SignalRoundOutcome? outcome;
  final int finishSeed;
  final SignalMatchWinner? finishWinner;

  @override
  State<_BattleArenaPanel> createState() => _BattleArenaPanelState();
}

class _BattleArenaPanelState extends State<_BattleArenaPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ambientController;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final state = widget.state;
    final palette = _battlePalette(state.battleSuit);
    final topLog = state.logs.isEmpty ? null : state.logs.first;

    return AppOrnateCard(
      aura: palette.aura,
      accentColor: palette.accent,
      highlightColor: palette.highlight,
      borderRadius: 28,
      overlay: IgnorePointer(
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _ambientController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _ArenaAmbientPainter(
                      progress: _ambientController.value,
                      suit: state.battleSuit,
                      accent: palette.accent,
                      highlight: palette.highlight,
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                key: ValueKey('arena-cast-${widget.castSeed}'),
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 760),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  if (widget.castSuit == null) {
                    return const SizedBox.shrink();
                  }
                  return CustomPaint(
                    painter: _ArenaCastPainter(
                      progress: value,
                      suit: widget.castSuit!,
                      accent: palette.accent,
                      highlight: palette.highlight,
                      intensity:
                          (widget.castPower.clamp(3, 8) as num).toDouble() / 8,
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                key: ValueKey('arena-pulse-${widget.pulseSeed}'),
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 560),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return CustomPaint(
                    painter: _ArenaImpactPainter(
                      progress: value,
                      suit: state.battleSuit,
                      color: palette.accent,
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                key: ValueKey('arena-outcome-${widget.outcomeSeed}'),
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 820),
                curve: Curves.easeOutQuart,
                builder: (context, value, _) {
                  if (widget.outcome == null) {
                    return const SizedBox.shrink();
                  }
                  return CustomPaint(
                    painter: _ArenaOutcomePainter(
                      progress: value,
                      outcome: widget.outcome!,
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                key: ValueKey('arena-finish-${widget.finishSeed}'),
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1180),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  if (widget.finishWinner == null) {
                    return const SizedBox.shrink();
                  }
                  return CustomPaint(
                    painter: _ArenaFinishPainter(
                      progress: value,
                      winner: widget.finishWinner!,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ArenaChip(
                icon: palette.icon,
                label: l10n.signalFieldChip(
                  l10n.signalSuitLabel(state.battleSuit),
                ),
                color: palette.accent,
              ),
              _ArenaChip(
                icon: Icons.auto_graph_rounded,
                label: l10n.signalMomentumChip(
                  state.player.momentum,
                  state.rival.momentum,
                ),
                color: theme.colorScheme.secondary,
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final panelWidth = constraints.maxWidth < 560
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 24) / 3;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: panelWidth,
                    child: _TablePileCard(
                      title: l10n.signalPileDraw,
                      count: state.deck.length,
                      icon: Icons.auto_stories_rounded,
                      accent: palette.highlight,
                      highlight: palette.accent,
                    ),
                  ),
                  SizedBox(
                    width: panelWidth,
                    child: _BattleCoreSeal(
                      title: l10n.signalBattleConsoleTitle,
                      suitLabel: l10n.signalSuitLabel(state.battleSuit),
                      roundLabel: '${state.round} / ${state.maxRounds}',
                      accent: palette.accent,
                      highlight: palette.highlight,
                      icon: palette.icon,
                    ),
                  ),
                  SizedBox(
                    width: panelWidth,
                    child: _TablePileCard(
                      title: l10n.signalPileDiscard,
                      count: state.logs.length * 2,
                      icon: Icons.layers_clear_rounded,
                      accent: theme.colorScheme.secondary,
                      highlight: palette.highlight,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ArenaSeatCard(
                  title: l10n.youLabel,
                  cardName: state.player.playedCard == null
                      ? null
                      : l10n.signalCardTitle(state.player.playedCard!.id),
                  fallback: l10n.youNotPlayed,
                  color: theme.colorScheme.primary,
                  icon: Icons.person_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ArenaSeatCard(
                  title: l10n.rivalLabel,
                  cardName: state.rival.playedCard == null
                      ? null
                      : l10n.signalCardTitle(state.rival.playedCard!.id),
                  fallback: l10n.rivalWaiting,
                  color: theme.colorScheme.secondary,
                  icon: Icons.smart_toy_outlined,
                  alignEnd: true,
                ),
              ),
            ],
          ),
          if (topLog != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.76),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: palette.highlight.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: palette.accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.flash_on_rounded, color: palette.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.signalRoundSummary(topLog),
                          style: theme.textTheme.bodyLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.signalPowerCheck(
                            topLog.playerPower,
                            topLog.rivalPower,
                          ),
                          style: theme.textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  _BattlePalette _battlePalette(SignalSuit suit) {
    switch (suit) {
      case SignalSuit.ember:
        return const _BattlePalette(
          accent: Color(0xFFD15A3A),
          highlight: Color(0xFFFFC46D),
          aura: AppOrnateCardAura.ember,
          icon: Icons.local_fire_department_rounded,
        );
      case SignalSuit.tide:
        return const _BattlePalette(
          accent: Color(0xFF2E6FA9),
          highlight: Color(0xFF90E2EB),
          aura: AppOrnateCardAura.tide,
          icon: Icons.water_drop_rounded,
        );
      case SignalSuit.spark:
        return const _BattlePalette(
          accent: Color(0xFF5A8A2D),
          highlight: Color(0xFFE8F07C),
          aura: AppOrnateCardAura.spark,
          icon: Icons.bolt_rounded,
        );
    }
  }
}

class _BattlePalette {
  const _BattlePalette({
    required this.accent,
    required this.highlight,
    required this.aura,
    required this.icon,
  });

  final Color accent;
  final Color highlight;
  final AppOrnateCardAura aura;
  final IconData icon;
}

class _TablePileCard extends StatelessWidget {
  const _TablePileCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.accent,
    required this.highlight,
  });

  final String title;
  final int count;
  final IconData icon;
  final Color accent;
  final Color highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 132,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface.withValues(alpha: 0.94),
            accent.withValues(alpha: 0.14),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 8,
            top: 4,
            child: Icon(icon, color: accent, size: 20),
          ),
          Positioned(
            right: 12,
            bottom: 10,
            child: _PileStackGlow(accent: accent, highlight: highlight),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(color: accent),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: Text(
                  '$count',
                  key: ValueKey('$title-$count'),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PileStackGlow extends StatelessWidget {
  const _PileStackGlow({required this.accent, required this.highlight});

  final Color accent;
  final Color highlight;

  @override
  Widget build(BuildContext context) {
    Widget buildLayer(double angle, double opacity) {
      return Transform.rotate(
        angle: angle,
        child: Container(
          width: 58,
          height: 76,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accent.withValues(alpha: opacity),
                highlight.withValues(alpha: opacity * 0.86),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: highlight.withValues(alpha: opacity)),
          ),
        ),
      );
    }

    return SizedBox(
      width: 84,
      height: 86,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(bottom: 4, child: buildLayer(-0.16, 0.14)),
          Positioned(bottom: 10, child: buildLayer(0.08, 0.18)),
          Positioned(bottom: 16, child: buildLayer(-0.02, 0.22)),
        ],
      ),
    );
  }
}

class _BattleCoreSeal extends StatelessWidget {
  const _BattleCoreSeal({
    required this.title,
    required this.suitLabel,
    required this.roundLabel,
    required this.accent,
    required this.highlight,
    required this.icon,
  });

  final String title;
  final String suitLabel;
  final String roundLabel;
  final Color accent;
  final Color highlight;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 132,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  highlight.withValues(alpha: 0.94),
                  accent,
                  accent.withValues(alpha: 0.72),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: highlight.withValues(alpha: 0.22),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(color: accent),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  suitLabel,
                  style: theme.textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  roundLabel,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArenaSeatCard extends StatelessWidget {
  const _ArenaSeatCard({
    required this.title,
    required this.cardName,
    required this.fallback,
    required this.color,
    required this.icon,
    this.alignEnd = false,
  });

  final String title;
  final String? cardName;
  final String fallback;
  final Color color;
  final IconData icon;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: alignEnd
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: alignEnd
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            cardName ?? fallback,
            style: theme.textTheme.bodyLarge,
            textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          ),
        ],
      ),
    );
  }
}

class _ArenaChip extends StatelessWidget {
  const _ArenaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArenaAmbientPainter extends CustomPainter {
  const _ArenaAmbientPainter({
    required this.progress,
    required this.suit,
    required this.accent,
    required this.highlight,
  });

  final double progress;
  final SignalSuit suit;
  final Color accent;
  final Color highlight;

  @override
  void paint(Canvas canvas, Size size) {
    switch (suit) {
      case SignalSuit.ember:
        _paintEmbers(canvas, size);
      case SignalSuit.tide:
        _paintTide(canvas, size);
      case SignalSuit.spark:
        _paintSpark(canvas, size);
    }
  }

  void _paintEmbers(Canvas canvas, Size size) {
    for (var index = 0; index < 10; index += 1) {
      final seed = (progress + index * 0.12) % 1;
      final x = size.width * (0.08 + (index % 5) * 0.18);
      final y = size.height * (0.98 - seed * 0.92);
      final radius = 2 + (index % 3) * 0.8;
      final paint = Paint()
        ..color = Color.lerp(
          accent,
          highlight,
          seed,
        )!.withValues(alpha: 0.16 + seed * 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  void _paintTide(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = accent.withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    for (var index = 0; index < 4; index += 1) {
      final offset = ((progress + index * 0.18) % 1) * size.width * 0.3;
      final baseline = size.height * (0.2 + index * 0.18);
      final path = Path()
        ..moveTo(-20 + offset, baseline)
        ..cubicTo(
          size.width * 0.18 + offset,
          baseline - 14,
          size.width * 0.34 + offset,
          baseline + 16,
          size.width * 0.56 + offset,
          baseline - 10,
        )
        ..cubicTo(
          size.width * 0.72 + offset,
          baseline - 24,
          size.width * 0.86 + offset,
          baseline + 6,
          size.width + 20,
          baseline - 8,
        );
      canvas.drawPath(path, paint);
    }
  }

  void _paintSpark(Canvas canvas, Size size) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2
      ..color = highlight.withValues(alpha: 0.2);
    for (var index = 0; index < 6; index += 1) {
      final seed = (progress + index * 0.18) % 1;
      final center = Offset(
        size.width * (0.12 + (index % 3) * 0.28),
        size.height * (0.16 + (index ~/ 3) * 0.42),
      );
      final length = 6 + seed * 10;
      canvas.drawLine(
        Offset(center.dx - length, center.dy),
        Offset(center.dx + length, center.dy),
        stroke,
      );
      canvas.drawLine(
        Offset(center.dx, center.dy - length),
        Offset(center.dx, center.dy + length),
        stroke,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ArenaAmbientPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.suit != suit ||
        oldDelegate.accent != accent ||
        oldDelegate.highlight != highlight;
  }
}

class _ArenaImpactPainter extends CustomPainter {
  const _ArenaImpactPainter({
    required this.progress,
    required this.suit,
    required this.color,
  });

  final double progress;
  final SignalSuit suit;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * (0.14 + progress * 0.44);
    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: (1 - progress) * 0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, radius, glowPaint);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..color = color.withValues(alpha: (1 - progress) * 0.28);
    canvas.drawCircle(center, radius + 10, ringPaint);

    switch (suit) {
      case SignalSuit.ember:
        _paintEmberBurst(canvas, center, radius);
      case SignalSuit.tide:
        _paintTideBurst(canvas, center, radius);
      case SignalSuit.spark:
        _paintSparkBurst(canvas, center, radius);
    }
  }

  void _paintEmberBurst(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color.withValues(alpha: (1 - progress) * 0.26);
    for (var index = 0; index < 4; index += 1) {
      final start = Offset(center.dx - radius * 0.5 + index * 12, center.dy);
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(
          start.dx + 10,
          start.dy - radius * 0.4,
          start.dx + 22,
          start.dy - radius * 0.12,
        );
      canvas.drawPath(path, paint);
    }
  }

  void _paintTideBurst(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color.withValues(alpha: (1 - progress) * 0.24);
    final path = Path()
      ..moveTo(center.dx - radius * 0.9, center.dy)
      ..quadraticBezierTo(
        center.dx - radius * 0.4,
        center.dy - radius * 0.2,
        center.dx,
        center.dy,
      )
      ..quadraticBezierTo(
        center.dx + radius * 0.4,
        center.dy + radius * 0.2,
        center.dx + radius * 0.9,
        center.dy,
      );
    canvas.drawPath(path, paint);
  }

  void _paintSparkBurst(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = color.withValues(alpha: (1 - progress) * 0.28);
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArenaImpactPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.suit != suit ||
        oldDelegate.color != color;
  }
}

class _ArenaCastPainter extends CustomPainter {
  const _ArenaCastPainter({
    required this.progress,
    required this.suit,
    required this.accent,
    required this.highlight,
    required this.intensity,
  });

  final double progress;
  final SignalSuit suit;
  final Color accent;
  final Color highlight;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final curved = Curves.easeOutCubic.transform(
      progress.clamp(0, 1).toDouble(),
    );
    final path = _buildPath(size);
    final metricIterator = path.computeMetrics().iterator;
    if (!metricIterator.moveNext()) {
      return;
    }
    final metric = metricIterator.current;

    final visiblePath = metric.extractPath(0, metric.length * curved);
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = (10 + intensity * 8) * (1 - progress * 0.3)
      ..color = highlight.withValues(
        alpha: (0.16 + intensity * 0.18) * (1 - progress),
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    final trailPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.6 + intensity * 1.8
      ..color = accent.withValues(alpha: 0.22 + (1 - progress) * 0.18);

    canvas.drawPath(visiblePath, glowPaint);
    canvas.drawPath(visiblePath, trailPaint);

    for (var index = 0; index < 6; index += 1) {
      final offset =
          metric.length * (curved * (0.18 + index * 0.13)).clamp(0.0, curved);
      final tangent = metric.getTangentForOffset(offset);
      if (tangent == null) {
        continue;
      }
      final particlePaint = Paint()
        ..color = Color.lerp(
          accent,
          highlight,
          index / 6,
        )!.withValues(alpha: (0.16 + index * 0.03) * (1 - progress))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(
        tangent.position,
        2 + (index % 3) * 0.8 + intensity * 1.2,
        particlePaint,
      );
    }

    switch (suit) {
      case SignalSuit.ember:
        _paintEmberCenter(canvas, size, curved);
      case SignalSuit.tide:
        _paintTideCenter(canvas, size, curved);
      case SignalSuit.spark:
        _paintSparkCenter(canvas, size, curved);
    }
  }

  Path _buildPath(Size size) {
    switch (suit) {
      case SignalSuit.ember:
        return Path()
          ..moveTo(size.width * 0.14, size.height * 1.02)
          ..cubicTo(
            size.width * 0.2,
            size.height * 0.82,
            size.width * 0.34,
            size.height * 0.7,
            size.width * 0.48,
            size.height * 0.46,
          );
      case SignalSuit.tide:
        return Path()
          ..moveTo(size.width * 0.5, size.height * 1.04)
          ..cubicTo(
            size.width * 0.38,
            size.height * 0.84,
            size.width * 0.34,
            size.height * 0.62,
            size.width * 0.5,
            size.height * 0.44,
          );
      case SignalSuit.spark:
        return Path()
          ..moveTo(size.width * 0.86, size.height * 1.02)
          ..lineTo(size.width * 0.74, size.height * 0.8)
          ..lineTo(size.width * 0.66, size.height * 0.74)
          ..lineTo(size.width * 0.58, size.height * 0.52)
          ..lineTo(size.width * 0.5, size.height * 0.44);
    }
  }

  void _paintEmberCenter(Canvas canvas, Size size, double curved) {
    final center = Offset(size.width * 0.5, size.height * 0.44);
    for (var index = 0; index < 7; index += 1) {
      final angle = -1 + index * 0.34;
      final orbit = 14 + curved * 28 + index * 4;
      final point = Offset(
        center.dx + orbit * angle,
        center.dy - orbit * 0.4 + (index % 2) * 10,
      );
      final paint = Paint()
        ..color = Color.lerp(
          accent,
          highlight,
          curved,
        )!.withValues(alpha: (1 - progress) * 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(point, 2.8 + intensity * 1.4, paint);
    }
  }

  void _paintTideCenter(Canvas canvas, Size size, double curved) {
    final center = Offset(size.width * 0.5, size.height * 0.44);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..color = accent.withValues(alpha: (1 - progress) * 0.24);
    for (var index = 0; index < 3; index += 1) {
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: 34 + curved * 70 + index * 12,
          height: 16 + curved * 32 + index * 7,
        ),
        paint,
      );
    }
  }

  void _paintSparkCenter(Canvas canvas, Size size, double curved) {
    final center = Offset(size.width * 0.5, size.height * 0.44);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.4
      ..color = highlight.withValues(alpha: (1 - progress) * 0.28);
    final reach = 16 + curved * 34;
    canvas.drawLine(
      Offset(center.dx - reach, center.dy),
      Offset(center.dx + reach, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - reach),
      Offset(center.dx, center.dy + reach),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - reach * 0.6, center.dy - reach * 0.6),
      Offset(center.dx + reach * 0.6, center.dy + reach * 0.6),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArenaCastPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.suit != suit ||
        oldDelegate.accent != accent ||
        oldDelegate.highlight != highlight ||
        oldDelegate.intensity != intensity;
  }
}

class _ArenaOutcomePainter extends CustomPainter {
  const _ArenaOutcomePainter({required this.progress, required this.outcome});

  final double progress;
  final SignalRoundOutcome outcome;

  @override
  void paint(Canvas canvas, Size size) {
    final tone = switch (outcome) {
      SignalRoundOutcome.playerWin => const Color(0xFF34A769),
      SignalRoundOutcome.rivalWin => const Color(0xFFC55252),
      SignalRoundOutcome.draw => const Color(0xFFD2A44D),
    };
    final alpha = (1 - progress).clamp(0.0, 1.0);
    final center = size.center(Offset.zero);

    final glow = Paint()
      ..color = tone.withValues(alpha: 0.14 * alpha)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);
    canvas.drawCircle(
      center,
      size.shortestSide * (0.18 + progress * 0.28),
      glow,
    );

    final streamPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..color = tone.withValues(alpha: 0.28 * alpha);

    switch (outcome) {
      case SignalRoundOutcome.playerWin:
        _paintWinnerSweep(
          canvas,
          size,
          fromLeft: true,
          paint: streamPaint,
          tone: tone,
          alpha: alpha,
        );
      case SignalRoundOutcome.rivalWin:
        _paintWinnerSweep(
          canvas,
          size,
          fromLeft: false,
          paint: streamPaint,
          tone: tone,
          alpha: alpha,
        );
      case SignalRoundOutcome.draw:
        final ring = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4
          ..color = tone.withValues(alpha: 0.24 * alpha);
        canvas.drawCircle(
          center,
          size.shortestSide * (0.2 + progress * 0.1),
          ring,
        );
        canvas.drawCircle(
          center,
          size.shortestSide * (0.28 + progress * 0.12),
          ring,
        );
    }
  }

  void _paintWinnerSweep(
    Canvas canvas,
    Size size, {
    required bool fromLeft,
    required Paint paint,
    required Color tone,
    required double alpha,
  }) {
    final start = Offset(
      fromLeft ? size.width * 0.14 : size.width * 0.86,
      size.height * 0.56,
    );
    final end = Offset(size.width * 0.5, size.height * 0.44);
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(
        fromLeft ? size.width * 0.26 : size.width * 0.74,
        size.height * 0.34,
        end.dx,
        end.dy,
      );
    canvas.drawPath(path, paint);

    for (var index = 0; index < 4; index += 1) {
      final point = Offset(
        start.dx + (fromLeft ? 1 : -1) * (24 + index * 18),
        start.dy - 12 - index * 16,
      );
      final sparkle = Paint()
        ..color = tone.withValues(alpha: (0.14 + index * 0.03) * alpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(point, 3 + index * 0.8, sparkle);
    }
  }

  @override
  bool shouldRepaint(covariant _ArenaOutcomePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.outcome != outcome;
  }
}

class _ArenaFinishPainter extends CustomPainter {
  const _ArenaFinishPainter({required this.progress, required this.winner});

  final double progress;
  final SignalMatchWinner winner;

  @override
  void paint(Canvas canvas, Size size) {
    final tone = switch (winner) {
      SignalMatchWinner.player => const Color(0xFF3AA76B),
      SignalMatchWinner.rival => const Color(0xFFC55252),
      SignalMatchWinner.draw => const Color(0xFFD4AE5C),
    };
    final center = size.center(Offset.zero);
    final alpha = (1 - progress).clamp(0.0, 1.0);

    final glow = Paint()
      ..color = tone.withValues(alpha: 0.18 * alpha)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(
      center,
      size.shortestSide * (0.18 + progress * 0.42),
      glow,
    );

    final rayPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.2
      ..color = tone.withValues(alpha: 0.24 * alpha);
    final reach = size.shortestSide * (0.12 + progress * 0.26);
    for (var index = 0; index < 10; index += 1) {
      final angle = (index / 10) * 6.28318;
      final inner = Offset(
        center.dx + reach * 0.42 * math.cos(angle),
        center.dy + reach * 0.42 * math.sin(angle),
      );
      final outer = Offset(
        center.dx + reach * math.cos(angle),
        center.dy + reach * math.sin(angle),
      );
      canvas.drawLine(inner, outer, rayPaint);
    }

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..color = tone.withValues(alpha: 0.2 * alpha);
    canvas.drawCircle(center, reach * 1.08, ringPaint);
  }

  @override
  bool shouldRepaint(covariant _ArenaFinishPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.winner != winner;
  }
}

class _RoundLogCard extends StatelessWidget {
  const _RoundLogCard({required this.log});

  final SignalRoundLog log;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final tone = _tone(log.outcome);

    return AppPanel(
      borderRadius: 20,
      tint: tone,
      borderOpacity: 0.24,
      gradient: LinearGradient(
        colors: [
          tone.withValues(alpha: 0.14),
          theme.colorScheme.surface.withValues(alpha: 0.95),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.signalRoundLabel(log.round),
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Icon(Icons.bolt_rounded, color: tone, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          Text(l10n.signalRoundSummary(log), style: theme.textTheme.bodyLarge),
          const SizedBox(height: 6),
          Text(
            l10n.signalPowerCheck(log.playerPower, log.rivalPower),
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Color _tone(SignalRoundOutcome outcome) {
    switch (outcome) {
      case SignalRoundOutcome.playerWin:
        return const Color(0xFF2F8B56);
      case SignalRoundOutcome.rivalWin:
        return const Color(0xFFB64646);
      case SignalRoundOutcome.draw:
        return const Color(0xFF746A53);
    }
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({
    required this.winner,
    required this.finishReason,
    required this.onReplay,
  });

  final SignalMatchWinner? winner;
  final String finishReason;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final onPrimary = theme.colorScheme.onPrimary;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.96 + value * 0.04,
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              Color.lerp(
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                    0.42,
                  ) ??
                  theme.colorScheme.primary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.signalResultHeadline(winner),
              style: theme.textTheme.headlineSmall?.copyWith(color: onPrimary),
            ),
            const SizedBox(height: 10),
            Text(
              finishReason,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: onPrimary.withValues(alpha: 0.92),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: onReplay,
              child: Text(l10n.playAgain),
            ),
          ],
        ),
      ),
    );
  }
}
