import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../../app/widgets/app_ornate_card.dart';
import '../../domain/signal_card.dart';

class SignalCardTile extends StatefulWidget {
  const SignalCardTile({
    super.key,
    required this.card,
    required this.battleSuit,
    required this.momentum,
    required this.enabled,
    required this.onPlay,
  });

  final SignalCard card;
  final SignalSuit battleSuit;
  final int momentum;
  final bool enabled;
  final VoidCallback onPlay;

  @override
  State<SignalCardTile> createState() => _SignalCardTileState();
}

class _SignalCardTileState extends State<SignalCardTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fxController;

  @override
  void initState() {
    super.initState();
    _fxController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
  }

  @override
  void dispose() {
    _fxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final palette = _palette(widget.card.suit);
    final isBattleSuit = widget.card.suit == widget.battleSuit;
    final extraPower = widget.momentum + (isBattleSuit ? 1 : 0);
    final effectivePower = widget.card.power + extraPower;
    final effectStrength = isBattleSuit ? 1.0 : 0.68;

    return AppOrnateCard(
      aura: palette.aura,
      accentColor: palette.primary,
      highlightColor: palette.highlight,
      borderRadius: 24,
      padding: const EdgeInsets.all(16),
      overlay: IgnorePointer(
        child: AnimatedBuilder(
          animation: _fxController,
          builder: (context, _) {
            return CustomPaint(
              painter: _SignalCardFxPainter(
                progress: _fxController.value,
                suit: widget.card.suit,
                accent: palette.primary,
                highlight: palette.highlight,
                intensity: effectStrength,
              ),
            );
          },
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.signalCardTitle(widget.card.id),
                            style: theme.textTheme.titleLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.viewAbilityAction,
                          visualDensity: VisualDensity.compact,
                          onPressed: _showAbilityDialog,
                          icon: Icon(
                            Icons.help_outline_rounded,
                            color: palette.highlight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _SignalChip(
                          icon: palette.suitIcon,
                          label: l10n.signalSuitLabel(widget.card.suit),
                          color: palette.primary,
                        ),
                        _SignalChip(
                          icon: _abilityIcon(widget.card.ability),
                          label: l10n.signalAbilityLabel(widget.card.ability),
                          color: palette.highlight,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              TweenAnimationBuilder<double>(
                key: ValueKey('power-${widget.card.id}-$effectivePower'),
                tween: Tween(begin: 0.92, end: 1),
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: _PowerCore(power: effectivePower, palette: palette),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.signalCardNote(widget.card.id),
            style: theme.textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isBattleSuit || widget.momentum > 0) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (isBattleSuit)
                  _SignalChip(
                    icon: Icons.local_fire_department_outlined,
                    label: l10n.signalBattleBonus,
                    color: palette.primary,
                  ),
                if (widget.momentum > 0)
                  _SignalChip(
                    icon: Icons.auto_graph_rounded,
                    label: l10n.signalMomentumBonus(widget.momentum),
                    color: theme.colorScheme.secondary,
                  ),
              ],
            ),
          ],
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              key: ValueKey('signal-play-${widget.card.id}'),
              onPressed: widget.enabled ? widget.onPlay : null,
              style: FilledButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.flash_on_rounded),
              label: Text(
                l10n.play,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAbilityDialog() {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final palette = _palette(widget.card.suit);

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.signalCardAbilityDialogTitle(
                    l10n.signalCardTitle(widget.card.id),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: palette.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(palette.suitIcon, size: 18, color: palette.primary),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.signalCardMeta(widget.card),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: palette.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.signalCardNote(widget.card.id),
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.closeAction),
            ),
          ],
        );
      },
    );
  }

  _SignalCardPalette _palette(SignalSuit suit) {
    switch (suit) {
      case SignalSuit.ember:
        return const _SignalCardPalette(
          primary: Color(0xFFD65734),
          highlight: Color(0xFFFFC36F),
          aura: AppOrnateCardAura.ember,
          suitIcon: Icons.local_fire_department_rounded,
        );
      case SignalSuit.tide:
        return const _SignalCardPalette(
          primary: Color(0xFF2F73A8),
          highlight: Color(0xFF90E2EB),
          aura: AppOrnateCardAura.tide,
          suitIcon: Icons.water_drop_rounded,
        );
      case SignalSuit.spark:
        return const _SignalCardPalette(
          primary: Color(0xFF5A8A2D),
          highlight: Color(0xFFE8F07C),
          aura: AppOrnateCardAura.spark,
          suitIcon: Icons.bolt_rounded,
        );
    }
  }

  IconData _abilityIcon(SignalAbility ability) {
    switch (ability) {
      case SignalAbility.chain:
        return Icons.all_inclusive_rounded;
      case SignalAbility.counter:
        return Icons.shield_outlined;
      case SignalAbility.surge:
        return Icons.trending_up_rounded;
      case SignalAbility.anchor:
        return Icons.anchor_rounded;
    }
  }
}

class _SignalCardFxPainter extends CustomPainter {
  const _SignalCardFxPainter({
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
    switch (suit) {
      case SignalSuit.ember:
        _paintEmber(canvas, size);
      case SignalSuit.tide:
        _paintTide(canvas, size);
      case SignalSuit.spark:
        _paintSpark(canvas, size);
    }
  }

  void _paintEmber(Canvas canvas, Size size) {
    for (var index = 0; index < 6; index += 1) {
      final seed = (progress + index * 0.16) % 1;
      final x = size.width * (0.12 + (index % 3) * 0.26);
      final y = size.height * (0.94 - seed * 0.78);
      final radius = (1.8 + (index % 3)) * intensity;
      final paint = Paint()
        ..color = Color.lerp(
          accent,
          highlight,
          seed,
        )!.withValues(alpha: (0.22 + seed * 0.22) * intensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  void _paintTide(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6 * intensity
      ..color = accent.withValues(alpha: 0.16 * intensity);
    for (var index = 0; index < 3; index += 1) {
      final shift = ((progress + index * 0.18) % 1) * size.width * 0.34;
      final baseline = size.height * (0.28 + index * 0.2);
      final path = Path()
        ..moveTo(-24 + shift, baseline)
        ..quadraticBezierTo(
          size.width * 0.18 + shift,
          baseline - 12,
          size.width * 0.42 + shift,
          baseline + 6,
        )
        ..quadraticBezierTo(
          size.width * 0.64 + shift,
          baseline + 18,
          size.width * 0.92 + shift,
          baseline - 8,
        );
      canvas.drawPath(path, paint);
    }
  }

  void _paintSpark(Canvas canvas, Size size) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.6 * intensity
      ..color = highlight.withValues(alpha: 0.22 * intensity);
    for (var index = 0; index < 4; index += 1) {
      final seed = (progress + index * 0.24) % 1;
      final center = Offset(
        size.width * (0.18 + (index % 2) * 0.42),
        size.height * (0.24 + index * 0.16),
      );
      final length = 6 + seed * 8;
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
  bool shouldRepaint(covariant _SignalCardFxPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.suit != suit ||
        oldDelegate.accent != accent ||
        oldDelegate.highlight != highlight ||
        oldDelegate.intensity != intensity;
  }
}

class _SignalChip extends StatelessWidget {
  const _SignalChip({
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
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PowerCore extends StatelessWidget {
  const _PowerCore({required this.power, required this.palette});

  final int power;
  final _SignalCardPalette palette;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 72,
      height: 84,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            palette.highlight.withValues(alpha: 0.2),
            palette.primary.withValues(alpha: 0.14),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.primary.withValues(alpha: 0.26)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.74),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: palette.highlight.withValues(alpha: 0.34)),
        ),
        child: Center(
          child: Text(
            '$power',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: palette.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class SignalCardBackTile extends StatelessWidget {
  const SignalCardBackTile({
    super.key,
    required this.accent,
    required this.highlight,
    this.label,
  });

  final Color accent;
  final Color highlight;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF101822),
            accent.withValues(alpha: 0.8),
            highlight.withValues(alpha: 0.78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: highlight.withValues(alpha: 0.32)),
        boxShadow: [
          BoxShadow(
            color: highlight.withValues(alpha: 0.16),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 34,
                ),
                const SizedBox(height: 10),
                Text(
                  label ?? 'SIGNAL',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalCardPalette {
  const _SignalCardPalette({
    required this.primary,
    required this.highlight,
    required this.aura,
    required this.suitIcon,
  });

  final Color primary;
  final Color highlight;
  final AppOrnateCardAura aura;
  final IconData suitIcon;
}
