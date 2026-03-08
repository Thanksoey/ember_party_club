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
import '../../application/midnight_vote_controller.dart';

class MidnightVotePage extends StatefulWidget {
  const MidnightVotePage({
    super.key,
    required this.controller,
    this.roomSessionController,
    this.disposeRoomSessionController = false,
  });

  final MidnightVoteController controller;
  final GameRoomSessionController? roomSessionController;
  final bool disposeRoomSessionController;

  @override
  State<MidnightVotePage> createState() => _MidnightVotePageState();
}

class _MidnightVotePageState extends State<MidnightVotePage> {
  static const _guideId = 'midnight_vote';

  String? _selectedSuspectId;
  bool _lastFinished = false;
  bool _hasCheckedAutoGuide = false;
  final GlobalKey _guideButtonKey = GlobalKey(
    debugLabel: 'midnight-guide-button',
  );
  final GlobalKey _boardGuideKey = GlobalKey(debugLabel: 'midnight-board');
  final GlobalKey _revealGuideKey = GlobalKey(debugLabel: 'midnight-reveal');
  final GlobalKey _deskGuideKey = GlobalKey(debugLabel: 'midnight-desk');

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onStateChanged);
    widget.roomSessionController?.startSession();
    _syncRoomPhase();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_maybeShowGuide());
    });
  }

  @override
  void didUpdateWidget(covariant MidnightVotePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onStateChanged);
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
    final state = widget.controller.state;
    _syncRoomPhase();
    if (!_lastFinished && state.isFinished) {
      if (state.playerScore >= state.aiScore) {
        unawaited(AppFeedback.instance.play(AppFeedbackType.success));
      } else {
        unawaited(AppFeedback.instance.play(AppFeedbackType.failure));
      }
    }
    _lastFinished = state.isFinished;
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
      title: '${l10n.moduleNameMidnightVote} · ${l10n.howToPlayAction}',
      subtitle: l10n.moduleSummaryMidnightVote,
      accentColor: const Color(0xFF6D4D7E),
      highlightColor: const Color(0xFFCEB7EA),
      aura: AppOrnateCardAura.noir,
      actionLabel: l10n.guideReadyAction,
      backLabel: l10n.guideBackAction,
      nextLabel: l10n.guideNextAction,
      skipLabel: l10n.guideSkipAction,
      stepCounterLabelBuilder: l10n.guideStepCounter,
      sections: [
        GameGuideSectionData(
          icon: Icons.flag_rounded,
          title: l10n.guideSectionGoalTitle,
          body: l10n.midnightGuideGoalBody,
          targetKey: _boardGuideKey,
        ),
        GameGuideSectionData(
          icon: Icons.play_circle_outline_rounded,
          title: l10n.guideSectionTurnTitle,
          body: l10n.midnightGuideTurnBody,
          targetKey: _revealGuideKey,
          spotlightShape: GameGuideSpotlightShape.circle,
        ),
        GameGuideSectionData(
          icon: Icons.tips_and_updates_outlined,
          title: l10n.guideSectionTipsTitle,
          body: l10n.midnightGuideTipsBody,
          targetKey: _deskGuideKey,
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
        final theme = Theme.of(context);
        final l10n = context.l10n;
        final state = widget.controller.state;
        final visibleClues = state.currentCase.clueIds
            .take(state.revealedClueCount)
            .toList(growable: false);
        final selectedSuspectId = _resolvedSelectedSuspect(
          state.currentCase.suspects,
        );

        return GameSessionScaffold(
          title: l10n.moduleNameMidnightVote,
          subtitle: l10n.moduleTaglineMidnightVote,
          statusText: state.isFinished
              ? l10n.midnightStatusFinished(state.playerScore, state.aiScore)
              : l10n.midnightStatusPlaying(state.round),
          contextPanel: widget.roomSessionController == null
              ? null
              : GameRoomSessionPanel(controller: widget.roomSessionController!),
          metrics: [
            GameSessionMetric(
              label: l10n.youLabel,
              value: '${state.playerScore}',
              icon: Icons.person_rounded,
              accentColor: theme.colorScheme.primary,
            ),
            GameSessionMetric(
              label: l10n.rivalLabel,
              value: '${state.aiScore}',
              icon: Icons.smart_toy_outlined,
              accentColor: theme.colorScheme.secondary,
            ),
            GameSessionMetric(
              label: l10n.midnightInsightLabel,
              value: '${state.insightTokens}',
              icon: Icons.lightbulb_outline_rounded,
              accentColor: const Color(0xFFB57A24),
            ),
            GameSessionMetric(
              label: l10n.matchLabel,
              value: '${state.round} / ${state.maxRounds}',
              icon: Icons.layers_outlined,
              accentColor: theme.colorScheme.tertiary,
            ),
          ],
          onReset: () {
            unawaited(AppFeedback.instance.play(AppFeedbackType.reset));
            widget.controller.reset();
            widget.roomSessionController?.resetMatch();
            _lastFinished = false;
            _selectedSuspectId = null;
          },
          primaryPanel: KeyedSubtree(
            key: _boardGuideKey,
            child: AppOrnateCard(
              aura: AppOrnateCardAura.noir,
              accentColor: const Color(0xFF6D4D7E),
              highlightColor: const Color(0xFFCEB7EA),
              borderRadius: 28,
              overlay: const IgnorePointer(
                child: CustomPaint(
                  painter: _EvidenceBoardAuraPainter(
                    accent: Color(0xFF6D4D7E),
                    highlight: Color(0xFFCEB7EA),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF6D4D7E,
                          ).withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(
                              0xFFCEB7EA,
                            ).withValues(alpha: 0.24),
                          ),
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: Color(0xFF6D4D7E),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.midnightCaseLabel(
                                l10n.midnightCaseTitle(state.currentCase.id),
                              ),
                              style: theme.textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.midnightStatusPlaying(state.round),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      KeyedSubtree(
                        key: _revealGuideKey,
                        child: OutlinedButton.icon(
                          onPressed:
                              state.isFinished ||
                                  state.insightTokens <= 0 ||
                                  state.revealedClueCount >=
                                      state.currentCase.clueIds.length
                              ? null
                              : () {
                                  unawaited(
                                    AppFeedback.instance.play(
                                      AppFeedbackType.investigate,
                                    ),
                                  );
                                  widget.controller.revealClue();
                                },
                          icon: const Icon(Icons.visibility_outlined),
                          label: Text(l10n.midnightRevealClue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _EvidenceBoardPreview(
                    caseId: state.currentCase.id,
                    visibleClues: visibleClues,
                    selectedSuspectId: selectedSuspectId,
                  ),
                  if (visibleClues.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: visibleClues
                          .map(
                            (clueId) => _ClueChip(
                              text: l10n.midnightClue(
                                state.currentCase.id,
                                clueId,
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ],
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
          resultPanel: state.isFinished
              ? _MidnightResultPanel(
                  playerScore: state.playerScore,
                  aiScore: state.aiScore,
                  onReplay: () {
                    unawaited(
                      AppFeedback.instance.play(AppFeedbackType.success),
                    );
                    widget.controller.reset();
                    widget.roomSessionController?.resetMatch();
                    _lastFinished = false;
                    _selectedSuspectId = null;
                  },
                )
              : null,
          content: [
            KeyedSubtree(
              key: _deskGuideKey,
              child: _InvestigationDesk(
                caseId: state.currentCase.id,
                suspects: state.currentCase.suspects,
                selectedSuspectId: selectedSuspectId,
                visibleClues: visibleClues,
                insightTokens: state.insightTokens,
                enabled: !state.isFinished,
                onSelectSuspect: _selectSuspect,
                onVote: () {
                  unawaited(
                    AppFeedback.instance.play(AppFeedbackType.cardPlay),
                  );
                  widget.controller.vote(selectedSuspectId);
                },
              ),
            ),
            const SizedBox(height: 16),
            AppExpandablePanel(
              icon: Icons.history_rounded,
              title: l10n.midnightTimelineTitle,
              subtitle: state.logs.isEmpty ? l10n.midnightTimelineEmpty : null,
              accentColor: theme.colorScheme.secondary,
              child: state.logs.isEmpty
                  ? Text(
                      l10n.midnightTimelineEmpty,
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
                                child: _VoteLogCard(log: log),
                              ),
                            );
                          })
                          .toList(growable: false),
                    ),
            ),
          ],
        );
      },
    );
  }

  String _resolvedSelectedSuspect(List<String> suspects) {
    final selected = _selectedSuspectId;
    if (selected != null && suspects.contains(selected)) {
      return selected;
    }
    return suspects.first;
  }

  void _selectSuspect(String suspectId) {
    if (_selectedSuspectId == suspectId) {
      return;
    }
    unawaited(AppFeedback.instance.play(AppFeedbackType.investigate));
    setState(() {
      _selectedSuspectId = suspectId;
    });
  }
}

class _EvidenceBoardPreview extends StatelessWidget {
  const _EvidenceBoardPreview({
    required this.caseId,
    required this.visibleClues,
    required this.selectedSuspectId,
  });

  final String caseId;
  final List<String> visibleClues;
  final String selectedSuspectId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          Positioned(
            left: 8,
            top: 18,
            child: _EvidencePinnedCard(
              color: const Color(0xFF6D4D7E),
              title: l10n.midnightCaseTitle(caseId),
              body: visibleClues.isEmpty
                  ? l10n.midnightRevealClue
                  : l10n.midnightClue(caseId, visibleClues.first),
              angle: -0.08,
            ),
          ),
          Positioned(
            right: 14,
            top: 4,
            child: _EvidencePinnedCard(
              color: const Color(0xFF8F5BB5),
              title: l10n.midnightSuspectsTitle,
              body: visibleClues.length > 1
                  ? l10n.midnightClue(caseId, visibleClues[1])
                  : l10n.midnightSelectSuspect,
              angle: 0.06,
            ),
          ),
          Positioned(
            right: 26,
            bottom: 18,
            child: _SuspectPortraitBadge(
              suspectId: selectedSuspectId,
              size: 72,
            ),
          ),
          Positioned(
            left: 54,
            right: 54,
            bottom: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFCEB7EA).withValues(alpha: 0.26),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6D4D7E).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF6D4D7E),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.midnightRevealClue,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF6D4D7E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          visibleClues.isEmpty
                              ? l10n.midnightSelectSuspect
                              : l10n.midnightClue(caseId, visibleClues.last),
                          style: theme.textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuspectPortraitBadge extends StatelessWidget {
  const _SuspectPortraitBadge({required this.suspectId, required this.size});

  final String suspectId;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final palette = _suspectPalette(suspectId);
    final initials = l10n.midnightSuspectName(suspectId).characters.first;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            palette.highlight.withValues(alpha: 0.94),
            palette.accent,
            palette.accent.withValues(alpha: 0.78),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: palette.highlight.withValues(alpha: 0.22),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            child: Container(
              width: size * 0.54,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.86),
                borderRadius: BorderRadius.circular(size * 0.16),
              ),
            ),
          ),
          Positioned(
            bottom: 6,
            child: Text(
              initials,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EvidencePinnedCard extends StatelessWidget {
  const _EvidencePinnedCard({
    required this.color,
    required this.title,
    required this.body,
    required this.angle,
  });

  final Color color;
  final String title;
  final String body;
  final double angle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 148,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color.withValues(alpha: 0.22)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: theme.textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ClueChip extends StatelessWidget {
  const _ClueChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(minWidth: 132, maxWidth: 220),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF6D4D7E).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF6D4D7E).withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.push_pin_rounded,
              size: 14,
              color: Color(0xFF6D4D7E),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _EvidenceBoardAuraPainter extends CustomPainter {
  const _EvidenceBoardAuraPainter({
    required this.accent,
    required this.highlight,
  });

  final Color accent;
  final Color highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = highlight.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(
      Offset(size.width * 0.26, size.height * 0.24),
      size.shortestSide * 0.18,
      glow,
    );
    canvas.drawCircle(
      Offset(size.width * 0.74, size.height * 0.64),
      size.shortestSide * 0.14,
      glow..color = accent.withValues(alpha: 0.08),
    );

    final threadPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = accent.withValues(alpha: 0.18);
    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.22)
      ..lineTo(size.width * 0.68, size.height * 0.26)
      ..lineTo(size.width * 0.42, size.height * 0.68)
      ..lineTo(size.width * 0.78, size.height * 0.52);
    canvas.drawPath(path, threadPaint);
  }

  @override
  bool shouldRepaint(covariant _EvidenceBoardAuraPainter oldDelegate) {
    return oldDelegate.accent != accent || oldDelegate.highlight != highlight;
  }
}

class _InvestigationDesk extends StatelessWidget {
  const _InvestigationDesk({
    required this.caseId,
    required this.suspects,
    required this.selectedSuspectId,
    required this.visibleClues,
    required this.insightTokens,
    required this.enabled,
    required this.onSelectSuspect,
    required this.onVote,
  });

  final String caseId;
  final List<String> suspects;
  final String selectedSuspectId;
  final List<String> visibleClues;
  final int insightTokens;
  final bool enabled;
  final ValueChanged<String> onSelectSuspect;
  final VoidCallback onVote;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppPanel(
      tint: const Color(0xFF6D4D7E),
      borderOpacity: 0.18,
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 780;
          final listSection = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6D4D7E).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.folder_special_rounded,
                      color: Color(0xFF6D4D7E),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.midnightDossierTitle,
                          style: Theme.of(context).textTheme.headlineSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.midnightDossierSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...suspects.map(
                (suspectId) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SuspectDossierRow(
                    suspectId: suspectId,
                    selected: suspectId == selectedSuspectId,
                    revealedClues: visibleClues.length,
                    totalClues: 3,
                    onTap: () => onSelectSuspect(suspectId),
                  ),
                ),
              ),
            ],
          );

          final focusSection = _SuspectFocusPanel(
            caseId: caseId,
            suspectId: selectedSuspectId,
            visibleClues: visibleClues,
            insightTokens: insightTokens,
            enabled: enabled,
            onVote: onVote,
          );

          if (!wide) {
            return Column(
              children: [listSection, const SizedBox(height: 16), focusSection],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: listSection),
              const SizedBox(width: 16),
              Expanded(flex: 4, child: focusSection),
            ],
          );
        },
      ),
    );
  }
}

class _SuspectDossierRow extends StatelessWidget {
  const _SuspectDossierRow({
    required this.suspectId,
    required this.selected,
    required this.revealedClues,
    required this.totalClues,
    required this.onTap,
  });

  final String suspectId;
  final bool selected;
  final int revealedClues;
  final int totalClues;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final palette = _suspectPalette(suspectId);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: ValueKey('midnight-suspect-$suspectId'),
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.surface.withValues(alpha: 0.96),
                palette.highlight.withValues(alpha: selected ? 0.18 : 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (selected ? palette.accent : palette.highlight).withValues(
                alpha: selected ? 0.32 : 0.16,
              ),
            ),
          ),
          child: Row(
            children: [
              _SuspectPortraitBadge(suspectId: suspectId, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.midnightSuspectName(suspectId),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: palette.accent,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.midnightEvidenceProgress(revealedClues, totalClues),
                      style: theme.textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.chevron_right_rounded,
                color: selected ? palette.accent : theme.colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuspectFocusPanel extends StatelessWidget {
  const _SuspectFocusPanel({
    required this.caseId,
    required this.suspectId,
    required this.visibleClues,
    required this.insightTokens,
    required this.enabled,
    required this.onVote,
  });

  final String caseId;
  final String suspectId;
  final List<String> visibleClues;
  final int insightTokens;
  final bool enabled;
  final VoidCallback onVote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final palette = _suspectPalette(suspectId);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface.withValues(alpha: 0.98),
            palette.highlight.withValues(alpha: 0.18),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.accent.withValues(alpha: 0.24)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _DossierFlowPainter(
                  accent: palette.accent,
                  highlight: palette.highlight,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _SuspectPortraitBadge(suspectId: suspectId, size: 64),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.midnightFocusLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: palette.accent,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.midnightSuspectName(suspectId),
                          style: theme.textTheme.headlineSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                l10n.midnightCaseLabel(l10n.midnightCaseTitle(caseId)),
                style: theme.textTheme.bodyLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _DeskChip(
                    icon: Icons.visibility_outlined,
                    text: l10n.midnightEvidenceProgress(visibleClues.length, 3),
                    color: palette.accent,
                  ),
                  _DeskChip(
                    icon: Icons.lightbulb_outline_rounded,
                    text: '${l10n.midnightInsightLabel}: $insightTokens',
                    color: const Color(0xFFB57A24),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                l10n.midnightVisibleCluesTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: palette.accent,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              ...visibleClues.map(
                (clueId) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.push_pin_rounded,
                        size: 16,
                        color: palette.accent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.midnightClue(caseId, clueId),
                          style: theme.textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                key: const ValueKey('midnight-lock-vote'),
                onPressed: enabled ? onVote : null,
                icon: const Icon(Icons.how_to_vote_outlined),
                label: Text(
                  l10n.midnightLockVote,
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

class _DeskChip extends StatelessWidget {
  const _DeskChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _DossierFlowPainter extends CustomPainter {
  const _DossierFlowPainter({required this.accent, required this.highlight});

  final Color accent;
  final Color highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = highlight.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.18),
      size.shortestSide * 0.12,
      glow,
    );

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = accent.withValues(alpha: 0.16);
    final path = Path()
      ..moveTo(size.width * 0.1, size.height * 0.2)
      ..lineTo(size.width * 0.68, size.height * 0.2)
      ..lineTo(size.width * 0.52, size.height * 0.56)
      ..lineTo(size.width * 0.86, size.height * 0.7);
    canvas.drawPath(path, line);

    final node = Paint()..color = accent.withValues(alpha: 0.2);
    for (final offset in <Offset>[
      Offset(size.width * 0.1, size.height * 0.2),
      Offset(size.width * 0.68, size.height * 0.2),
      Offset(size.width * 0.52, size.height * 0.56),
      Offset(size.width * 0.86, size.height * 0.7),
    ]) {
      canvas.drawCircle(offset, 4, node);
    }
  }

  @override
  bool shouldRepaint(covariant _DossierFlowPainter oldDelegate) {
    return oldDelegate.accent != accent || oldDelegate.highlight != highlight;
  }
}

_SuspectPalette _suspectPalette(String suspectId) {
  return switch (suspectId) {
    'vex' => const _SuspectPalette(
      accent: Color(0xFFD45E37),
      highlight: Color(0xFFFFC46D),
      aura: AppOrnateCardAura.ember,
    ),
    'lyra' => const _SuspectPalette(
      accent: Color(0xFF7550B7),
      highlight: Color(0xFFD6BEFF),
      aura: AppOrnateCardAura.noir,
    ),
    'kade' => const _SuspectPalette(
      accent: Color(0xFF2D74A7),
      highlight: Color(0xFF9ADDE8),
      aura: AppOrnateCardAura.tide,
    ),
    'mina' => const _SuspectPalette(
      accent: Color(0xFFAF5A74),
      highlight: Color(0xFFF5C3D0),
      aura: AppOrnateCardAura.aurora,
    ),
    'nox' => const _SuspectPalette(
      accent: Color(0xFF616B79),
      highlight: Color(0xFFD4DBE6),
      aura: AppOrnateCardAura.noir,
    ),
    'sora' => const _SuspectPalette(
      accent: Color(0xFF377F68),
      highlight: Color(0xFFAEE7D4),
      aura: AppOrnateCardAura.aurora,
    ),
    'dax' => const _SuspectPalette(
      accent: Color(0xFFAD7A24),
      highlight: Color(0xFFFFD985),
      aura: AppOrnateCardAura.solar,
    ),
    'yuri' => const _SuspectPalette(
      accent: Color(0xFF438AA9),
      highlight: Color(0xFFAFEAF5),
      aura: AppOrnateCardAura.tide,
    ),
    _ => const _SuspectPalette(
      accent: Color(0xFF7550B7),
      highlight: Color(0xFFD6BEFF),
      aura: AppOrnateCardAura.noir,
    ),
  };
}

class _SuspectPalette {
  const _SuspectPalette({
    required this.accent,
    required this.highlight,
    required this.aura,
  });

  final Color accent;
  final Color highlight;
  final AppOrnateCardAura aura;
}

class _VoteLogCard extends StatelessWidget {
  const _VoteLogCard({required this.log});

  final MidnightRoundLog log;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return AppPanel(
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.midnightTimelineRound(
              log.round,
              l10n.midnightCaseTitle(log.caseId),
            ),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.midnightTimelineVotes(
              l10n.midnightSuspectName(log.playerVote),
              l10n.midnightSuspectName(log.aiVote),
              l10n.midnightSuspectName(log.culpritId),
            ),
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.midnightTimelineResult(
              log.playerCorrect ? 3 : 0,
              log.aiCorrect ? 3 : 0,
            ),
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _MidnightResultPanel extends StatelessWidget {
  const _MidnightResultPanel({
    required this.playerScore,
    required this.aiScore,
    required this.onReplay,
  });

  final int playerScore;
  final int aiScore;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final playerWon = playerScore >= aiScore;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            playerWon ? const Color(0xFF2C7E62) : const Color(0xFF975A4A),
            theme.colorScheme.primary,
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
            playerWon ? l10n.midnightResultWin : l10n.midnightResultLose,
            style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.midnightResultScore(playerScore, aiScore),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(onPressed: onReplay, child: Text(l10n.playAgain)),
        ],
      ),
    );
  }
}
