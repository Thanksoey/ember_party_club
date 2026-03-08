import 'dart:async';

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
import '../../application/chaos_mixer_controller.dart';

class ChaosMixerPage extends StatefulWidget {
  const ChaosMixerPage({
    super.key,
    required this.controller,
    this.roomSessionController,
    this.disposeRoomSessionController = false,
  });

  final ChaosMixerController controller;
  final GameRoomSessionController? roomSessionController;
  final bool disposeRoomSessionController;

  @override
  State<ChaosMixerPage> createState() => _ChaosMixerPageState();
}

class _ChaosMixerPageState extends State<ChaosMixerPage> {
  static const _guideId = 'chaos_mixer';

  int _spinSeed = 0;
  String? _lastChallengeId;
  bool _hasCheckedAutoGuide = false;
  final GlobalKey _guideButtonKey = GlobalKey(debugLabel: 'chaos-guide-button');
  final GlobalKey _arenaGuideKey = GlobalKey(debugLabel: 'chaos-arena');
  final GlobalKey _timelineGuideKey = GlobalKey(debugLabel: 'chaos-timeline');

  @override
  void initState() {
    super.initState();
    _lastChallengeId = widget.controller.state.currentChallenge.id;
    widget.controller.addListener(_onStateChanged);
    widget.roomSessionController?.startSession();
    _syncRoomPhase();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_maybeShowGuide());
    });
  }

  @override
  void didUpdateWidget(covariant ChaosMixerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onStateChanged);
      _lastChallengeId = widget.controller.state.currentChallenge.id;
      widget.controller.addListener(_onStateChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onStateChanged);
    if (widget.disposeRoomSessionController) {
      widget.roomSessionController?.dispose();
    }
    super.dispose();
  }

  void _onStateChanged() {
    final id = widget.controller.state.currentChallenge.id;
    if (_lastChallengeId != id) {
      _lastChallengeId = id;
      if (mounted) {
        setState(() {
          _spinSeed += 1;
        });
      }
    }
    _syncRoomPhase();
  }

  void _syncRoomPhase() {
    final state = widget.controller.state;
    widget.roomSessionController?.handleMatchState(
      hasAnyRound: state.logs.isNotEmpty,
      isFinished: state.isFinished,
    );
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
      title: '${l10n.moduleNameChaosMixer} · ${l10n.howToPlayAction}',
      subtitle: l10n.chaosIntro,
      accentColor: const Color(0xFFBC6328),
      highlightColor: const Color(0xFFFFD06D),
      aura: AppOrnateCardAura.aurora,
      actionLabel: l10n.guideReadyAction,
      backLabel: l10n.guideBackAction,
      nextLabel: l10n.guideNextAction,
      skipLabel: l10n.guideSkipAction,
      stepCounterLabelBuilder: l10n.guideStepCounter,
      sections: [
        GameGuideSectionData(
          icon: Icons.flag_rounded,
          title: l10n.guideSectionGoalTitle,
          body: l10n.chaosGuideGoalBody,
          targetKey: _arenaGuideKey,
        ),
        GameGuideSectionData(
          icon: Icons.play_circle_outline_rounded,
          title: l10n.guideSectionTurnTitle,
          body: l10n.chaosGuideTurnBody,
          targetKey: _arenaGuideKey,
        ),
        GameGuideSectionData(
          icon: Icons.tips_and_updates_outlined,
          title: l10n.guideSectionTipsTitle,
          body: l10n.chaosGuideTipsBody,
          targetKey: _timelineGuideKey,
        ),
        GameGuideSectionData(
          icon: Icons.auto_awesome_rounded,
          title: l10n.guideSectionReopenTitle,
          body: l10n.guideReopenBody,
          targetKey: _guideButtonKey,
          spotlightPadding: const EdgeInsets.all(10),
          spotlightShape: GameGuideSpotlightShape.circle,
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
        final state = widget.controller.state;
        final theme = Theme.of(context);
        final l10n = context.l10n;
        final challenge = state.currentChallenge;
        final challengeTitle = l10n.chaosChallengeTitle(challenge.id);
        final challengeDetail = l10n.chaosChallengeDetail(challenge.id);

        return GameSessionScaffold(
          title: l10n.moduleNameChaosMixer,
          subtitle: l10n.moduleTaglineChaosMixer,
          statusText: _statusText(l10n, state),
          contextPanel: widget.roomSessionController == null
              ? null
              : GameRoomSessionPanel(controller: widget.roomSessionController!),
          metrics: [
            GameSessionMetric(
              label: l10n.chaosScoreLabel,
              value: '${state.score}',
              icon: Icons.workspace_premium_outlined,
              accentColor: theme.colorScheme.primary,
            ),
            GameSessionMetric(
              label: l10n.chaosStreakLabel,
              value: '${state.streak}',
              icon: Icons.local_fire_department_outlined,
              accentColor: theme.colorScheme.secondary,
            ),
            GameSessionMetric(
              label: l10n.chaosBestLabel,
              value: '${state.bestStreak}',
              icon: Icons.emoji_events_outlined,
              accentColor: const Color(0xFFB06E28),
            ),
            GameSessionMetric(
              label: l10n.matchLabel,
              value: '${state.round} / ${state.maxRounds}',
              icon: Icons.layers_outlined,
              accentColor: theme.colorScheme.tertiary,
            ),
            GameSessionMetric(
              label: l10n.chaosRerollLabel,
              value: '${state.rerollCharges}',
              icon: Icons.casino_outlined,
              accentColor: const Color(0xFF9456AF),
            ),
          ],
          primaryPanel: KeyedSubtree(
            key: _arenaGuideKey,
            child: _ChaosChallengeArena(
              title: challengeTitle,
              detail: challengeDetail,
              scoreValue: challenge.basePoints,
              timeLimitSec: challenge.timeLimitSec,
              iconCode: challenge.iconCode,
              spinSeed: _spinSeed,
              footer: state.isFinished
                  ? null
                  : Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        FilledButton.icon(
                          key: const ValueKey('chaos-success'),
                          onPressed: () {
                            AppFeedback.instance.play(AppFeedbackType.success);
                            widget.controller.completeRound(success: true);
                          },
                          icon: const Icon(Icons.check_circle_outline),
                          label: Text(l10n.chaosActionSuccess),
                        ),
                        FilledButton.tonalIcon(
                          key: const ValueKey('chaos-fail'),
                          onPressed: () {
                            AppFeedback.instance.play(AppFeedbackType.failure);
                            widget.controller.completeRound(success: false);
                          },
                          icon: const Icon(Icons.close),
                          label: Text(l10n.chaosActionFail),
                        ),
                        OutlinedButton.icon(
                          key: const ValueKey('chaos-reroll'),
                          onPressed: state.rerollCharges > 0
                              ? () {
                                  AppFeedback.instance.play(
                                    AppFeedbackType.chaosSpin,
                                  );
                                  widget.controller.rerollChallenge();
                                }
                              : null,
                          icon: const Icon(Icons.casino_outlined),
                          label: Text(l10n.chaosActionReroll),
                        ),
                      ],
                    ),
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
          onReset: () {
            AppFeedback.instance.play(AppFeedbackType.reset);
            widget.controller.reset();
            widget.roomSessionController?.resetMatch();
          },
          resultPanel: state.isFinished
              ? _ChaosResultPanel(
                  score: state.score,
                  bestStreak: state.bestStreak,
                  onReplay: () {
                    AppFeedback.instance.play(AppFeedbackType.success);
                    widget.controller.reset();
                    widget.roomSessionController?.resetMatch();
                  },
                )
              : null,
          content: [
            AppExpandablePanel(
              icon: Icons.tips_and_updates_outlined,
              title: l10n.moduleTaglineChaosMixer,
              subtitle: l10n.chaosIntro,
              accentColor: theme.colorScheme.secondary,
              child: Text(l10n.chaosIntro, style: theme.textTheme.bodyLarge),
            ),
            const SizedBox(height: 16),
            KeyedSubtree(
              key: _timelineGuideKey,
              child: AppExpandablePanel(
                icon: Icons.history_rounded,
                title: l10n.chaosRoundTimeline,
                subtitle: state.logs.isEmpty ? l10n.chaosRoundEmpty : null,
                accentColor: theme.colorScheme.primary,
                child: state.logs.isEmpty
                    ? Text(
                        l10n.chaosRoundEmpty,
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
                                  child: _ChaosLogCard(log: log),
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

  String _statusText(AppLocalizations l10n, ChaosMixerState state) {
    if (state.isFinished) {
      return l10n.chaosStatusFinished(state.score, state.bestStreak);
    }
    return l10n.chaosStatusPlaying(state.round);
  }
}

class _ChaosChallengeArena extends StatelessWidget {
  const _ChaosChallengeArena({
    required this.title,
    required this.detail,
    required this.scoreValue,
    required this.timeLimitSec,
    required this.iconCode,
    required this.spinSeed,
    this.footer,
  });

  final String title;
  final String detail;
  final int scoreValue;
  final int timeLimitSec;
  final String iconCode;
  final int spinSeed;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return AppOrnateCard(
      aura: AppOrnateCardAura.aurora,
      accentColor: const Color(0xFFBC6328),
      highlightColor: const Color(0xFFFFD06D),
      borderRadius: 28,
      overlay: const IgnorePointer(
        child: CustomPaint(
          painter: _ChaosStageAuraPainter(
            accent: Color(0xFFBC6328),
            highlight: Color(0xFFFFD06D),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TweenAnimationBuilder<double>(
                key: ValueKey('chaos-spin-$spinSeed'),
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 520),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return Transform.rotate(
                    angle: value * 0.24,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0012)
                        ..rotateX(0.18)
                        ..rotateY(value * 0.9),
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.surface.withValues(alpha: 0.82),
                              const Color(0xFFFFD06D).withValues(alpha: 0.18),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: theme.colorScheme.secondary.withValues(
                              alpha: 0.32,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFFFD06D,
                              ).withValues(alpha: 0.16),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            iconCode,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      detail,
                      style: theme.textTheme.bodyLarge,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ArenaBadge(
                label: l10n.chaosBasePointsLabel(scoreValue),
                color: theme.colorScheme.primary,
              ),
              _ArenaBadge(
                label: l10n.chaosTimerLabel(timeLimitSec),
                color: theme.colorScheme.secondary,
              ),
            ],
          ),
          if (footer != null) ...[const SizedBox(height: 14), footer!],
        ],
      ),
    );
  }
}

class _ArenaBadge extends StatelessWidget {
  const _ArenaBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ChaosStageAuraPainter extends CustomPainter {
  const _ChaosStageAuraPainter({required this.accent, required this.highlight});

  final Color accent;
  final Color highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final beamPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader =
          LinearGradient(
            colors: [highlight.withValues(alpha: 0.16), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
            Rect.fromLTWH(size.width * 0.08, 0, size.width * 0.18, size.height),
          );

    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.08, 0)
        ..lineTo(size.width * 0.22, 0)
        ..lineTo(size.width * 0.3, size.height * 0.72)
        ..lineTo(0, size.height * 0.72)
        ..close(),
      beamPaint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.78, 0)
        ..lineTo(size.width * 0.92, 0)
        ..lineTo(size.width, size.height * 0.72)
        ..lineTo(size.width * 0.7, size.height * 0.72)
        ..close(),
      beamPaint
        ..shader =
            LinearGradient(
              colors: [accent.withValues(alpha: 0.16), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(
              Rect.fromLTWH(size.width * 0.7, 0, size.width * 0.3, size.height),
            ),
    );

    final stagePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = accent.withValues(alpha: 0.18);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.92),
        width: size.width * 0.86,
        height: size.height * 0.48,
      ),
      3.3,
      2.8,
      false,
      stagePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ChaosStageAuraPainter oldDelegate) {
    return oldDelegate.accent != accent || oldDelegate.highlight != highlight;
  }
}

class _ChaosLogCard extends StatelessWidget {
  const _ChaosLogCard({required this.log});

  final ChaosRoundLog log;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final success = log.outcome == ChaosRoundOutcome.success;
    final tone = success ? const Color(0xFF2D8A56) : const Color(0xFFB14D4D);
    final title = l10n.chaosChallengeTitle(log.challenge.id);

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
          Text(
            l10n.chaosRoundTitle(log.round, title),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            success
                ? l10n.chaosRoundSuccess(log.pointsAwarded)
                : l10n.chaosRoundFailed,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.chaosStreakAfterRound(log.streakAfterRound),
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ChaosResultPanel extends StatelessWidget {
  const _ChaosResultPanel({
    required this.score,
    required this.bestStreak,
    required this.onReplay,
  });

  final int score;
  final int bestStreak;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.secondary,
            Color.lerp(
                  theme.colorScheme.secondary,
                  theme.colorScheme.primary,
                  0.4,
                ) ??
                theme.colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.chaosSummaryTitle,
            style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.chaosSummaryBody(score, bestStreak),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.tonal(
            onPressed: onReplay,
            child: Text(l10n.chaosRunAgain),
          ),
        ],
      ),
    );
  }
}
