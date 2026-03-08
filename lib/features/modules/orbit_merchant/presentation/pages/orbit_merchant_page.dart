import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../../app/services/app_feedback.dart';
import '../../../../../app/widgets/app_card_deck_carousel.dart';
import '../../../../../app/widgets/app_expandable_panel.dart';
import '../../../../../app/widgets/app_fade_in_up.dart';
import '../../../../../app/widgets/app_ornate_card.dart';
import '../../../../../app/widgets/app_panel.dart';
import '../../../../game_session/application/game_guide_preferences.dart';
import '../../../../game_session/application/game_room_session_controller.dart';
import '../../../../game_session/presentation/widgets/game_guide_sheet.dart';
import '../../../../game_session/presentation/widgets/game_room_session_panel.dart';
import '../../../../game_session/presentation/widgets/game_session_scaffold.dart';
import '../../application/orbit_merchant_controller.dart';

class OrbitMerchantPage extends StatefulWidget {
  const OrbitMerchantPage({
    super.key,
    required this.controller,
    this.roomSessionController,
    this.disposeRoomSessionController = false,
  });

  final OrbitMerchantController controller;
  final GameRoomSessionController? roomSessionController;
  final bool disposeRoomSessionController;

  @override
  State<OrbitMerchantPage> createState() => _OrbitMerchantPageState();
}

class _OrbitMerchantPageState extends State<OrbitMerchantPage> {
  static const _guideId = 'orbit_merchant';

  bool _lastFinished = false;
  bool _hasCheckedAutoGuide = false;

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
  void didUpdateWidget(covariant OrbitMerchantPage oldWidget) {
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
      unawaited(AppFeedback.instance.play(AppFeedbackType.success));
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
      title: '${l10n.moduleNameOrbitMerchant} · ${l10n.howToPlayAction}',
      subtitle: l10n.moduleSummaryOrbitMerchant,
      accentColor: const Color(0xFF2B7188),
      highlightColor: const Color(0xFF95E1EB),
      aura: AppOrnateCardAura.solar,
      actionLabel: l10n.guideReadyAction,
      backLabel: l10n.guideBackAction,
      nextLabel: l10n.guideNextAction,
      skipLabel: l10n.guideSkipAction,
      stepCounterLabelBuilder: l10n.guideStepCounter,
      sections: [
        GameGuideSectionData(
          icon: Icons.flag_rounded,
          title: l10n.guideSectionGoalTitle,
          body: l10n.orbitGuideGoalBody,
        ),
        GameGuideSectionData(
          icon: Icons.play_circle_outline_rounded,
          title: l10n.guideSectionTurnTitle,
          body: l10n.orbitGuideTurnBody,
        ),
        GameGuideSectionData(
          icon: Icons.tips_and_updates_outlined,
          title: l10n.guideSectionTipsTitle,
          body: l10n.orbitGuideTipsBody,
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
        final netWorth = state.netWorth();

        return GameSessionScaffold(
          title: l10n.moduleNameOrbitMerchant,
          subtitle: l10n.moduleTaglineOrbitMerchant,
          statusText: state.isFinished
              ? l10n.orbitStatusFinished(netWorth)
              : l10n.orbitStatusPlaying,
          contextPanel: widget.roomSessionController == null
              ? null
              : GameRoomSessionPanel(controller: widget.roomSessionController!),
          metrics: [
            GameSessionMetric(
              label: l10n.orbitMetricCash,
              value: '${state.cash}',
              icon: Icons.payments_outlined,
              accentColor: const Color(0xFFB06E28),
            ),
            GameSessionMetric(
              label: l10n.orbitMetricNetWorth,
              value: '$netWorth',
              icon: Icons.account_balance_wallet_outlined,
              accentColor: theme.colorScheme.primary,
            ),
            GameSessionMetric(
              label: l10n.orbitMetricCargo,
              value:
                  '${state.cargo[OrbitResource.ore]}/${state.cargo[OrbitResource.crystal]}/${state.cargo[OrbitResource.gas]}',
              icon: Icons.inventory_2_outlined,
              accentColor: theme.colorScheme.secondary,
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
          },
          primaryPanel: AppOrnateCard(
            aura: AppOrnateCardAura.solar,
            accentColor: const Color(0xFF2B7188),
            highlightColor: const Color(0xFF95E1EB),
            borderRadius: 28,
            overlay: const IgnorePointer(
              child: CustomPaint(
                painter: _OrbitStageAuraPainter(
                  accent: Color(0xFF2B7188),
                  highlight: Color(0xFF95E1EB),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.orbitMarketBoardTitle,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.orbitMarketBoardSubtitle,
                  style: theme.textTheme.bodyLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                _OrbitMarketStage(
                  prices: state.prices,
                  cargo: state.cargo,
                  cash: state.cash,
                  netWorth: netWorth,
                ),
              ],
            ),
          ),
          appBarActions: [
            IconButton(
              key: const ValueKey('game-guide-open'),
              tooltip: l10n.howToPlayAction,
              onPressed: _showGuide,
              icon: const Icon(Icons.auto_awesome_rounded),
            ),
          ],
          resultPanel: state.isFinished
              ? _OrbitResultPanel(
                  netWorth: netWorth,
                  onReplay: () {
                    unawaited(
                      AppFeedback.instance.play(AppFeedbackType.success),
                    );
                    widget.controller.reset();
                    widget.roomSessionController?.resetMatch();
                    _lastFinished = false;
                  },
                )
              : null,
          content: [
            AppCardDeckCarousel(
              title: l10n.orbitMarketBoardTitle,
              subtitle: l10n.orbitMarketBoardSubtitle,
              icon: Icons.view_carousel_outlined,
              accentColor: theme.colorScheme.primary,
              itemLabels: OrbitResource.values
                  .map(l10n.orbitResourceLabel)
                  .toList(growable: false),
              expandedHeight: 312,
              collapsedHeight: 196,
              itemBuilder: (context, index) {
                final resource = OrbitResource.values[index];
                return _ResourceCard(
                  resource: resource,
                  price: state.prices[resource] ?? 0,
                  cargo: state.cargo[resource] ?? 0,
                  cash: state.cash,
                  enabled: !state.isFinished,
                  onBuy: () {
                    unawaited(AppFeedback.instance.play(AppFeedbackType.tap));
                    widget.controller.buy(resource);
                  },
                  onSell: () {
                    unawaited(
                      AppFeedback.instance.play(AppFeedbackType.cardPlay),
                    );
                    widget.controller.sell(resource);
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            AppExpandablePanel(
              icon: Icons.history_rounded,
              title: l10n.orbitTimelineTitle,
              subtitle: state.logs.isEmpty ? l10n.orbitTimelineEmpty : null,
              accentColor: theme.colorScheme.secondary,
              child: state.logs.isEmpty
                  ? Text(
                      l10n.orbitTimelineEmpty,
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
                                child: _OrbitLogCard(log: log),
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
}

class _OrbitMarketStage extends StatelessWidget {
  const _OrbitMarketStage({
    required this.prices,
    required this.cargo,
    required this.cash,
    required this.netWorth,
  });

  final Map<OrbitResource, int> prices;
  final Map<OrbitResource, int> cargo;
  final int cash;
  final int netWorth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return SizedBox(
      height: 190,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 124,
              height: 124,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [
                    Color(0xFF95E1EB),
                    Color(0xFF2B7188),
                    Color(0xFF194B5B),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF95E1EB).withValues(alpha: 0.24),
                    blurRadius: 26,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$netWorth',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.orbitMetricNetWorth,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.86),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ...OrbitResource.values.asMap().entries.map((entry) {
            final index = entry.key;
            final resource = entry.value;
            final palette = _orbitNodePalette(resource);
            final positions = <Alignment>[
              const Alignment(-0.78, -0.34),
              const Alignment(0.82, -0.1),
              const Alignment(-0.16, 0.86),
            ];

            return Align(
              alignment: positions[index],
              child: _OrbitResourceNode(
                label: l10n.orbitResourceLabel(resource),
                price: prices[resource] ?? 0,
                cargo: cargo[resource] ?? 0,
                icon: palette.icon,
                accent: palette.accent,
              ),
            );
          }),
          Positioned(
            left: 8,
            right: 8,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.74),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF95E1EB).withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.payments_outlined,
                    size: 18,
                    color: Color(0xFF2B7188),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${l10n.orbitMetricCash}: $cash',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF2B7188),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

class _OrbitResourceNode extends StatelessWidget {
  const _OrbitResourceNode({
    required this.label,
    required this.price,
    required this.cargo,
    required this.icon,
    required this.accent,
  });

  final String label;
  final int price;
  final int cargo;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 116,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: accent),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(color: accent),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '$price / $cargo',
            style: theme.textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  const _ResourceCard({
    required this.resource,
    required this.price,
    required this.cargo,
    required this.cash,
    required this.enabled,
    required this.onBuy,
    required this.onSell,
  });

  final OrbitResource resource;
  final int price;
  final int cargo;
  final int cash;
  final bool enabled;
  final VoidCallback onBuy;
  final VoidCallback onSell;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final palette = _palette(resource);

    return AppOrnateCard(
      aura: palette.aura,
      accentColor: palette.accent,
      highlightColor: palette.highlight,
      borderRadius: 24,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: palette.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: palette.accent.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(palette.icon, color: palette.accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.orbitResourceLabel(resource),
                  style: theme.textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.orbitResourceStats(price, cargo),
            style: theme.textTheme.bodyLarge,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: enabled && cash >= price ? onBuy : null,
                  icon: const Icon(Icons.add_shopping_cart_rounded),
                  label: Text(
                    l10n.orbitBuy,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: enabled && cargo > 0 ? onSell : null,
                  icon: const Icon(Icons.sell_rounded),
                  label: Text(
                    l10n.orbitSell,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _ResourcePalette _palette(OrbitResource resource) {
    return switch (resource) {
      OrbitResource.ore => const _ResourcePalette(
        accent: Color(0xFFB36A24),
        highlight: Color(0xFFFFD787),
        aura: AppOrnateCardAura.solar,
        icon: Icons.landscape_rounded,
      ),
      OrbitResource.crystal => const _ResourcePalette(
        accent: Color(0xFF3F7FB2),
        highlight: Color(0xFFADEAF7),
        aura: AppOrnateCardAura.tide,
        icon: Icons.diamond_outlined,
      ),
      OrbitResource.gas => const _ResourcePalette(
        accent: Color(0xFF4F9360),
        highlight: Color(0xFFB8F2C2),
        aura: AppOrnateCardAura.aurora,
        icon: Icons.cloud_outlined,
      ),
    };
  }
}

class _ResourcePalette {
  const _ResourcePalette({
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

_ResourcePalette _orbitNodePalette(OrbitResource resource) {
  return switch (resource) {
    OrbitResource.ore => const _ResourcePalette(
      accent: Color(0xFFB36A24),
      highlight: Color(0xFFFFD787),
      aura: AppOrnateCardAura.solar,
      icon: Icons.landscape_rounded,
    ),
    OrbitResource.crystal => const _ResourcePalette(
      accent: Color(0xFF3F7FB2),
      highlight: Color(0xFFADEAF7),
      aura: AppOrnateCardAura.tide,
      icon: Icons.diamond_outlined,
    ),
    OrbitResource.gas => const _ResourcePalette(
      accent: Color(0xFF4F9360),
      highlight: Color(0xFFB8F2C2),
      aura: AppOrnateCardAura.aurora,
      icon: Icons.cloud_outlined,
    ),
  };
}

class _OrbitStageAuraPainter extends CustomPainter {
  const _OrbitStageAuraPainter({required this.accent, required this.highlight});

  final Color accent;
  final Color highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = accent.withValues(alpha: 0.18);
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = highlight.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    final center = Offset(size.width * 0.52, size.height * 0.46);
    for (var index = 0; index < 3; index += 1) {
      final rect = Rect.fromCenter(
        center: center,
        width: size.width * (0.38 + index * 0.18),
        height: size.height * (0.22 + index * 0.12),
      );
      canvas.drawOval(rect, glowPaint);
      canvas.drawOval(rect, ringPaint);
    }

    final pulsePaint = Paint()
      ..color = highlight.withValues(alpha: 0.14)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.32),
      size.shortestSide * 0.06,
      pulsePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.22),
      size.shortestSide * 0.05,
      pulsePaint..color = accent.withValues(alpha: 0.12),
    );
    canvas.drawCircle(
      Offset(size.width * 0.36, size.height * 0.78),
      size.shortestSide * 0.05,
      pulsePaint..color = const Color(0xFFB8F2C2).withValues(alpha: 0.12),
    );
  }

  @override
  bool shouldRepaint(covariant _OrbitStageAuraPainter oldDelegate) {
    return oldDelegate.accent != accent || oldDelegate.highlight != highlight;
  }
}

class _OrbitLogCard extends StatelessWidget {
  const _OrbitLogCard({required this.log});

  final OrbitTurnLog log;

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
            l10n.orbitRoundLogTitle(
              log.round,
              l10n.orbitTradeActionLabel(log.action),
              l10n.orbitResourceLabel(log.resource),
              log.price,
            ),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.orbitRoundLogStats(
              log.cashAfterAction,
              log.netWorthAfterAction,
            ),
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _OrbitResultPanel extends StatelessWidget {
  const _OrbitResultPanel({required this.netWorth, required this.onReplay});

  final int netWorth;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, const Color(0xFF2A6A8F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.orbitResultTitle,
            style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.orbitResultBody(netWorth),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: onReplay,
            child: Text(l10n.orbitTradeAgain),
          ),
        ],
      ),
    );
  }
}
