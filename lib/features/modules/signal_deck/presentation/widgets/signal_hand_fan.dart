import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../../app/widgets/app_panel.dart';
import '../../domain/signal_card.dart';
import 'signal_card_tile.dart';

class SignalHandFan extends StatefulWidget {
  const SignalHandFan({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.hand,
    required this.battleSuit,
    required this.momentum,
    required this.enabled,
    required this.onPlay,
    required this.drawSeed,
    required this.discardSeed,
    this.drawnCard,
    this.discardedCard,
  });

  final String title;
  final String subtitle;
  final Color accentColor;
  final List<SignalCard> hand;
  final SignalSuit battleSuit;
  final int momentum;
  final bool enabled;
  final ValueChanged<SignalCard> onPlay;
  final int drawSeed;
  final int discardSeed;
  final SignalCard? drawnCard;
  final SignalCard? discardedCard;

  @override
  State<SignalHandFan> createState() => _SignalHandFanState();
}

class _SignalHandFanState extends State<SignalHandFan> {
  late List<String> _order;
  int _seenDrawSeed = 0;
  int _seenDiscardSeed = 0;
  SignalCard? _drawGhost;
  SignalCard? _discardGhost;
  Timer? _drawTimer;
  Timer? _discardTimer;

  @override
  void initState() {
    super.initState();
    _order = widget.hand.map((card) => card.id).toList(growable: true);
  }

  @override
  void didUpdateWidget(covariant SignalHandFan oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextIds = widget.hand.map((card) => card.id).toList(growable: false);
    final preservedOrder = _order
        .where(nextIds.contains)
        .toList(growable: true);
    for (final id in nextIds) {
      if (!preservedOrder.contains(id)) {
        preservedOrder.add(id);
      }
    }
    _order = preservedOrder;

    if (widget.drawSeed != _seenDrawSeed && widget.drawnCard != null) {
      _seenDrawSeed = widget.drawSeed;
      _drawGhost = widget.drawnCard;
      _bringToFront(widget.drawnCard!.id, emitState: false);
      _drawTimer?.cancel();
      _drawTimer = Timer(const Duration(milliseconds: 760), () {
        if (!mounted) {
          return;
        }
        setState(() {
          _drawGhost = null;
        });
      });
    }

    if (widget.discardSeed != _seenDiscardSeed &&
        widget.discardedCard != null) {
      _seenDiscardSeed = widget.discardSeed;
      _discardGhost = widget.discardedCard;
      _discardTimer?.cancel();
      _discardTimer = Timer(const Duration(milliseconds: 640), () {
        if (!mounted) {
          return;
        }
        setState(() {
          _discardGhost = null;
        });
      });
    }
  }

  @override
  void dispose() {
    _drawTimer?.cancel();
    _discardTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final topCardId = _order.isEmpty ? null : _order.last;

    return AppPanel(
      tint: widget.accentColor,
      borderOpacity: 0.18,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: widget.accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.accentColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(Icons.style_rounded, color: widget.accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: theme.textTheme.headlineSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: widget.accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${widget.hand.length}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: widget.accentColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = math.min(280.0, constraints.maxWidth * 0.72);
              const cardHeight = 316.0;
              final overlap = math.max(44.0, cardWidth * 0.24);
              final contentWidth =
                  cardWidth +
                  math.max(0, widget.hand.length - 1) * overlap +
                  28;

              return SizedBox(
                height: cardHeight + 36,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.surface.withValues(alpha: 0.62),
                              widget.accentColor.withValues(alpha: 0.08),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      bottom: 6,
                      child: _HandPileBadge(
                        title: l10n.signalPileDiscard,
                        accent: theme.colorScheme.secondary,
                        active: _discardGhost != null,
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 6,
                      child: _HandPileBadge(
                        title: l10n.signalPileDraw,
                        accent: widget.accentColor,
                        active: _drawGhost != null,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                      child: SizedBox(
                        width: contentWidth,
                        height: cardHeight + 10,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ..._buildCards(
                              hand: widget.hand,
                              cardWidth: cardWidth,
                              cardHeight: cardHeight,
                              overlap: overlap,
                              topCardId: topCardId,
                            ),
                            if (_drawGhost != null)
                              _buildDrawGhost(
                                cardWidth: cardWidth,
                                cardHeight: cardHeight,
                                overlap: overlap,
                              ),
                            if (_discardGhost != null)
                              _buildDiscardGhost(
                                cardWidth: cardWidth,
                                cardHeight: cardHeight,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Text(
            topCardId == null ? '' : l10n.signalCardTitle(topCardId),
            style: theme.textTheme.titleMedium?.copyWith(
              color: widget.accentColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCards({
    required List<SignalCard> hand,
    required double cardWidth,
    required double cardHeight,
    required double overlap,
    required String? topCardId,
  }) {
    final widgets = <Widget>[];
    for (var index = 0; index < _order.length; index += 1) {
      final cardId = _order[index];
      final card = hand.where((item) => item.id == cardId).firstOrNull;
      if (card == null) {
        continue;
      }
      final depth = _order.length - 1 - index;
      final isTop = card.id == topCardId;
      final topOffset = isTop ? 10.0 : 28.0 + depth * 6;
      final angle = isTop ? 0.0 : (index.isEven ? -0.035 : 0.03);

      widgets.add(
        AnimatedPositioned(
          key: ValueKey('signal-hand-card-${card.id}'),
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          left: index * overlap,
          top: topOffset,
          child: GestureDetector(
            onTap: () => _bringToFront(card.id),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 180),
              scale: isTop ? 1 : 0.94,
              child: Transform.rotate(
                angle: angle,
                child: SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: IgnorePointer(
                    ignoring: !isTop,
                    child: SignalCardTile(
                      key: ValueKey('signal-card-${card.id}'),
                      card: card,
                      battleSuit: widget.battleSuit,
                      momentum: widget.momentum,
                      enabled: widget.enabled,
                      onPlay: () => widget.onPlay(card),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  Widget _buildDrawGhost({
    required double cardWidth,
    required double cardHeight,
    required double overlap,
  }) {
    final ghost = _drawGhost!;
    final targetIndex = _order.indexOf(ghost.id);
    final targetLeft = targetIndex < 0 ? 0.0 : targetIndex * overlap;
    final accent = _accentFor(ghost.suit);
    final highlight = _highlightFor(ghost.suit);

    return TweenAnimationBuilder<double>(
      key: ValueKey('signal-hand-draw-${widget.drawSeed}'),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 760),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        final left = lerpDouble(cardWidth * 0.82, targetLeft, value)!;
        final top = lerpDouble(6, 12, value)!;
        final tilt = lerpDouble(-0.18, 0, value)!;
        final showBack = value < 0.58;
        return Positioned(
          left: left,
          top: top,
          child: IgnorePointer(
            child: Transform.rotate(
              angle: tilt,
              child: Opacity(
                opacity: 1 - value * 0.14,
                child: SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: showBack
                      ? SignalCardBackTile(accent: accent, highlight: highlight)
                      : SignalCardTile(
                          card: ghost,
                          battleSuit: widget.battleSuit,
                          momentum: widget.momentum,
                          enabled: false,
                          onPlay: () {},
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiscardGhost({
    required double cardWidth,
    required double cardHeight,
  }) {
    final ghost = _discardGhost!;
    final accent = _accentFor(ghost.suit);
    final highlight = _highlightFor(ghost.suit);

    return TweenAnimationBuilder<double>(
      key: ValueKey('signal-hand-discard-${widget.discardSeed}'),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 640),
      curve: Curves.easeInCubic,
      builder: (context, value, _) {
        final left = lerpDouble(cardWidth * 0.3, 4, value)!;
        final top = lerpDouble(18, cardHeight * 0.54, value)!;
        final scale = lerpDouble(1, 0.42, value)!;
        return Positioned(
          left: left,
          top: top,
          child: IgnorePointer(
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: 1 - value * 0.22,
                child: SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: SignalCardBackTile(
                    accent: accent,
                    highlight: highlight,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _bringToFront(String cardId, {bool emitState = true}) {
    final index = _order.indexOf(cardId);
    if (index < 0 || index == _order.length - 1) {
      return;
    }
    final nextOrder = [..._order]
      ..removeAt(index)
      ..add(cardId);
    if (!emitState) {
      _order = nextOrder;
      return;
    }
    setState(() {
      _order = nextOrder;
    });
  }

  Color _accentFor(SignalSuit suit) {
    switch (suit) {
      case SignalSuit.ember:
        return const Color(0xFFD65734);
      case SignalSuit.tide:
        return const Color(0xFF2F73A8);
      case SignalSuit.spark:
        return const Color(0xFF5A8A2D);
    }
  }

  Color _highlightFor(SignalSuit suit) {
    switch (suit) {
      case SignalSuit.ember:
        return const Color(0xFFFFC36F);
      case SignalSuit.tide:
        return const Color(0xFF90E2EB);
      case SignalSuit.spark:
        return const Color(0xFFE8F07C);
    }
  }
}

class _HandPileBadge extends StatelessWidget {
  const _HandPileBadge({
    required this.title,
    required this.accent,
    required this.active,
  });

  final String title;
  final Color accent;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      scale: active ? 1.04 : 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: active ? 0.18 : 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: accent.withValues(alpha: 0.22)),
        ),
        child: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: accent,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

double? lerpDouble(num? a, num? b, double t) {
  if (a == null && b == null) {
    return null;
  }
  a ??= 0;
  b ??= 0;
  return a + (b - a) * t;
}

extension on Iterable<SignalCard> {
  SignalCard? get firstOrNull => isEmpty ? null : first;
}
