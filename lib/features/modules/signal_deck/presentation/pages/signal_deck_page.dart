import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../game_session/application/game_room_session_controller.dart';
import '../../../../game_session/presentation/widgets/game_room_session_panel.dart';
import '../../../../game_session/presentation/widgets/game_session_scaffold.dart';
import '../../application/signal_deck_controller.dart';
import '../../domain/signal_card.dart';
import '../../domain/signal_deck_state.dart';
import '../widgets/signal_card_tile.dart';

class SignalDeckPage extends StatefulWidget {
  const SignalDeckPage({
    super.key,
    required this.controller,
    this.roomSessionController,
  });

  final SignalDeckController controller;
  final GameRoomSessionController? roomSessionController;

  @override
  State<SignalDeckPage> createState() => _SignalDeckPageState();
}

class _SignalDeckPageState extends State<SignalDeckPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleStateChange);
    _handleStateChange();
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
    super.dispose();
  }

  void _handleStateChange() {
    final roomSessionController = widget.roomSessionController;
    if (roomSessionController == null) {
      return;
    }
    final state = widget.controller.state;
    roomSessionController.handleMatchState(
      hasAnyRound: state.logs.isNotEmpty,
      isFinished: state.isFinished,
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
            ),
            GameSessionMetric(
              label: l10n.rivalLabel,
              value: l10n.signalPoints(state.rival.score),
            ),
            GameSessionMetric(
              label: l10n.roundsWon,
              value: '${state.player.roundsWon}-${state.rival.roundsWon}',
            ),
            GameSessionMetric(
              label: l10n.matchLabel,
              value: '${state.round} / ${state.maxRounds}',
            ),
          ],
          primaryPanel: _PlayedCardsPanel(
            playerCard: state.player.playedCard,
            rivalCard: state.rival.playedCard,
          ),
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
            Text(l10n.signalDeckIntro, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 20),
            Text(l10n.yourHand, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            ...state.player.hand.map(
              (card) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SignalCardTile(
                  card: card,
                  enabled: !state.isFinished,
                  onPlay: () => widget.controller.playCard(card),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(l10n.roundLog, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            if (state.logs.isEmpty)
              Text(l10n.noRoundsPlayed)
            else
              ...state.logs.map(
                (log) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.signalRoundLabel(log.round), style: theme.textTheme.titleMedium),
                        const SizedBox(height: 6),
                        Text(l10n.signalRoundSummary(log), style: theme.textTheme.bodyLarge),
                        const SizedBox(height: 6),
                        Text(
                          l10n.signalPowerCheck(log.playerPower, log.rivalPower),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _handleReplay() {
    widget.roomSessionController?.resetMatch();
    widget.controller.reset();
  }
}

class _PlayedCardsPanel extends StatelessWidget {
  const _PlayedCardsPanel({
    required this.playerCard,
    required this.rivalCard,
  });

  final SignalCard? playerCard;
  final SignalCard? rivalCard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              playerCard == null
                  ? l10n.youNotPlayed
                  : l10n.youPlayed(l10n.signalCardTitle(playerCard!.id)),
              style: theme.textTheme.bodyLarge,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              rivalCard == null
                  ? l10n.rivalWaiting
                  : l10n.rivalPlayed(l10n.signalCardTitle(rivalCard!.id)),
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
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

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.signalResultHeadline(winner),
            style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            finishReason,
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: onReplay,
            child: Text(l10n.playAgain),
          ),
        ],
      ),
    );
  }
}
