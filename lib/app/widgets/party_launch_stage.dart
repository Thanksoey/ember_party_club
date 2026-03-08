import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'app_loading_indicator.dart';
import 'brand_mark.dart';

enum PartyLaunchStageVariant { opening, entry }

class PartyLaunchStage extends StatefulWidget {
  const PartyLaunchStage({
    super.key,
    required this.variant,
    required this.title,
    required this.caption,
    required this.statusLabel,
    required this.detailsLabel,
    required this.stageDuration,
    this.overline = 'EMBER PARTY CLUB',
  });

  final PartyLaunchStageVariant variant;
  final String overline;
  final String title;
  final String caption;
  final String statusLabel;
  final String detailsLabel;
  final Duration stageDuration;

  @override
  State<PartyLaunchStage> createState() => _PartyLaunchStageState();
}

class _PartyLaunchStageState extends State<PartyLaunchStage>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _ambientController;
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1350),
    )..forward();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7800),
    )..repeat();
    _progressController = AnimationController(
      vsync: this,
      duration: widget.stageDuration,
    )..forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    _ambientController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _introController,
          _ambientController,
          _progressController,
        ]),
        builder: (context, _) {
          final intro = Curves.easeOutCubic.transform(_introController.value);
          final ambient = _ambientController.value;
          final loadProgress = Curves.easeInOutCubic.transform(
            _progressController.value.clamp(0.0, 1.0),
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.variant == PartyLaunchStageVariant.opening
                        ? const [
                            Color(0xFF090605),
                            Color(0xFF130C0A),
                            Color(0xFF22110D),
                          ]
                        : const [
                            Color(0xFF070505),
                            Color(0xFF120B09),
                            Color(0xFF1B100D),
                          ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _ClubBackdropPainter(
                      progress: ambient,
                      reveal: intro,
                      variant: widget.variant,
                      primary: scheme.primary,
                      secondary: scheme.secondary,
                      tertiary: scheme.tertiary,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.015 * intro),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.08 * intro),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.variant == PartyLaunchStageVariant.entry)
                Positioned.fill(
                  child: IgnorePointer(
                    child: _DoorRevealCurtains(progress: intro),
                  ),
                ),
              SafeArea(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          widget.variant == PartyLaunchStageVariant.opening
                          ? 24
                          : 20,
                      vertical: 28,
                    ),
                    child: widget.variant == PartyLaunchStageVariant.opening
                        ? _OpeningClubCard(
                            intro: intro,
                            ambient: ambient,
                            overline: widget.overline,
                            title: widget.title,
                            caption: widget.caption,
                            statusLabel: widget.statusLabel,
                            detailsLabel: widget.detailsLabel,
                            loadProgress: loadProgress,
                          )
                        : _EntryRoomPanel(
                            intro: intro,
                            ambient: ambient,
                            overline: widget.overline,
                            title: widget.title,
                            caption: widget.caption,
                            statusLabel: widget.statusLabel,
                            detailsLabel: widget.detailsLabel,
                            loadProgress: loadProgress,
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DoorRevealCurtains extends StatelessWidget {
  const _DoorRevealCurtains({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final opened = Curves.easeInOutCubic.transform(progress.clamp(0.0, 1.0));
    final opacity = (1 - opened).clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        final panelWidth = constraints.maxWidth * 0.56;
        final slide = panelWidth * (opened * 1.08);

        return Stack(
          children: [
            Positioned(
              left: constraints.maxWidth / 2 - panelWidth,
              top: 0,
              bottom: 0,
              width: panelWidth,
              child: Transform.translate(
                offset: Offset(-slide, 0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(
                          0xFF050303,
                        ).withValues(alpha: 0.92 * opacity),
                        const Color(
                          0xFF0C0706,
                        ).withValues(alpha: 0.84 * opacity),
                        Colors.transparent,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: constraints.maxWidth / 2,
              top: 0,
              bottom: 0,
              width: panelWidth,
              child: Transform.translate(
                offset: Offset(slide, 0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        const Color(
                          0xFF0C0706,
                        ).withValues(alpha: 0.84 * opacity),
                        const Color(
                          0xFF050303,
                        ).withValues(alpha: 0.92 * opacity),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 2,
                height: constraints.maxHeight * 0.62,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      const Color(0xFFF1CB82).withValues(alpha: 0.34 * opacity),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OpeningClubCard extends StatelessWidget {
  const _OpeningClubCard({
    required this.intro,
    required this.ambient,
    required this.overline,
    required this.title,
    required this.caption,
    required this.statusLabel,
    required this.detailsLabel,
    required this.loadProgress,
  });

  final double intro;
  final double ambient;
  final String overline;
  final String title;
  final String caption;
  final String statusLabel;
  final String detailsLabel;
  final double loadProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Opacity(
      opacity: intro,
      child: Transform.translate(
        offset: Offset(0, lerpDouble(28, 0, intro) ?? 0),
        child: Transform.scale(
          scale: lerpDouble(0.96, 1, Curves.easeOutBack.transform(intro)) ?? 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 232,
                  height: 214,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _BadgeOrbitPainter(
                            progress: ambient,
                            secondary: scheme.secondary,
                            tertiary: scheme.tertiary,
                            variant: PartyLaunchStageVariant.opening,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 14,
                        child: Container(
                          width: 128,
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            gradient: RadialGradient(
                              colors: [
                                scheme.secondary.withValues(alpha: 0.2),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, lerpDouble(16, -4, intro) ?? 0),
                        child: Transform.scale(
                          scale: lerpDouble(0.82, 1, intro) ?? 1,
                          child: const BrandMark(size: 124),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    gradient: LinearGradient(
                      colors: [
                        theme.cardColor.withValues(alpha: 0.98),
                        scheme.surface.withValues(alpha: 0.92),
                        theme.cardColor.withValues(alpha: 0.9),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    border: Border.all(
                      color: scheme.secondary.withValues(alpha: 0.16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.34),
                        blurRadius: 42,
                        offset: const Offset(0, 26),
                      ),
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.1),
                        blurRadius: 28,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 28,
                        right: 28,
                        top: 18,
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                scheme.secondary.withValues(alpha: 0.22),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 18,
                        right: 18,
                        top: 18,
                        bottom: 18,
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: scheme.secondary.withValues(alpha: 0.08),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 34, 30, 28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              overline,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                letterSpacing: 3.8,
                                fontWeight: FontWeight.w800,
                                color: scheme.secondary.withValues(alpha: 0.86),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontSize: 34,
                                letterSpacing: -0.8,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              caption,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.55,
                                fontWeight: FontWeight.w600,
                                color: scheme.onSurface.withValues(alpha: 0.78),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _StatusPill(label: statusLabel),
                            const SizedBox(height: 18),
                            _SweepMeter(progress: loadProgress, width: 254),
                            const SizedBox(height: 8),
                            Text(
                              '${(loadProgress * 100).round().clamp(0, 100)}%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: scheme.secondary.withValues(alpha: 0.88),
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const AppLoadingIndicator(
                                  size: 24,
                                  strokeWidth: 2.4,
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    detailsLabel,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: scheme.onSurface.withValues(
                                        alpha: 0.68,
                                      ),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EntryRoomPanel extends StatelessWidget {
  const _EntryRoomPanel({
    required this.intro,
    required this.ambient,
    required this.overline,
    required this.title,
    required this.caption,
    required this.statusLabel,
    required this.detailsLabel,
    required this.loadProgress,
  });

  final double intro;
  final double ambient;
  final String overline;
  final String title;
  final String caption;
  final String statusLabel;
  final String detailsLabel;
  final double loadProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Opacity(
      opacity: intro,
      child: Transform.translate(
        offset: Offset(0, lerpDouble(24, 0, intro) ?? 0),
        child: Transform.scale(
          scale: lerpDouble(0.97, 1, Curves.easeOutBack.transform(intro)) ?? 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                gradient: LinearGradient(
                  colors: [
                    scheme.surface.withValues(alpha: 0.92),
                    theme.cardColor.withValues(alpha: 0.9),
                    scheme.surface.withValues(alpha: 0.86),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: scheme.secondary.withValues(alpha: 0.14),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 38,
                    offset: const Offset(0, 24),
                  ),
                  BoxShadow(
                    color: scheme.secondary.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _PanelSheenPainter(
                          progress: ambient,
                          radius: 34,
                          color: scheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    top: 18,
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            scheme.secondary.withValues(alpha: 0.18),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final compact = constraints.maxWidth < 560;
                        if (compact) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _EntryBadgeCluster(
                                ambient: ambient,
                                intro: intro,
                              ),
                              const SizedBox(height: 18),
                              _EntryTextBlock(
                                overline: overline,
                                title: title,
                                caption: caption,
                                statusLabel: statusLabel,
                                detailsLabel: detailsLabel,
                                center: true,
                                loadProgress: loadProgress,
                              ),
                              const SizedBox(height: 18),
                              const AppLoadingIndicator(
                                size: 28,
                                strokeWidth: 2.6,
                              ),
                            ],
                          );
                        }

                        return Row(
                          children: [
                            _EntryBadgeCluster(ambient: ambient, intro: intro),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _EntryTextBlock(
                                overline: overline,
                                title: title,
                                caption: caption,
                                statusLabel: statusLabel,
                                detailsLabel: detailsLabel,
                                center: false,
                                loadProgress: loadProgress,
                              ),
                            ),
                            const SizedBox(width: 18),
                            Container(
                              width: 86,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: scheme.surface.withValues(alpha: 0.68),
                                border: Border.all(
                                  color: scheme.outline.withValues(alpha: 0.56),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const AppLoadingIndicator(
                                    size: 30,
                                    strokeWidth: 2.8,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'LIVE',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2,
                                      color: scheme.secondary.withValues(
                                        alpha: 0.84,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _SweepMeter(
                                    progress: loadProgress,
                                    width: 44,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EntryBadgeCluster extends StatelessWidget {
  const _EntryBadgeCluster({required this.ambient, required this.intro});

  final double ambient;
  final double intro;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 136,
      height: 136,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _BadgeOrbitPainter(
                progress: ambient,
                secondary: scheme.secondary,
                tertiary: scheme.tertiary,
                variant: PartyLaunchStageVariant.entry,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, lerpDouble(14, 0, intro) ?? 0),
            child: Transform.scale(
              scale: lerpDouble(0.84, 1, intro) ?? 1,
              child: const BrandMark(size: 88),
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryTextBlock extends StatelessWidget {
  const _EntryTextBlock({
    required this.overline,
    required this.title,
    required this.caption,
    required this.statusLabel,
    required this.detailsLabel,
    required this.center,
    required this.loadProgress,
  });

  final String overline;
  final String title;
  final String caption;
  final String statusLabel;
  final String detailsLabel;
  final bool center;
  final double loadProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          overline,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: theme.textTheme.bodySmall?.copyWith(
            letterSpacing: 3.2,
            fontWeight: FontWeight.w800,
            color: scheme.secondary.withValues(alpha: 0.82),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: 28,
            letterSpacing: -0.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          caption,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.5,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface.withValues(alpha: 0.76),
          ),
        ),
        const SizedBox(height: 16),
        _StatusPill(label: statusLabel),
        const SizedBox(height: 14),
        Align(
          alignment: center ? Alignment.center : Alignment.centerLeft,
          child: _SweepMeter(progress: loadProgress, width: center ? 220 : 260),
        ),
        const SizedBox(height: 8),
        Text(
          '${(loadProgress * 100).round().clamp(0, 100)}%',
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: scheme.secondary.withValues(alpha: 0.84),
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          detailsLabel,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: scheme.onSurface.withValues(alpha: 0.66),
            letterSpacing: 0.28,
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.62)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [scheme.secondary, scheme.tertiary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: scheme.secondary.withValues(alpha: 0.3),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SweepMeter extends StatelessWidget {
  const _SweepMeter({required this.progress, required this.width});

  final double progress;
  final double width;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: width,
      height: 8,
      child: CustomPaint(
        painter: _SweepMeterPainter(
          progress: progress,
          color: scheme.secondary,
          accent: scheme.tertiary,
          track: scheme.outline.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

class _SweepMeterPainter extends CustomPainter {
  const _SweepMeterPainter({
    required this.progress,
    required this.color,
    required this.accent,
    required this.track,
  });

  final double progress;
  final Color color;
  final Color accent;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height / 2 - 2, size.width, 4),
      const Radius.circular(999),
    );
    canvas.drawRRect(trackRect, Paint()..color = track);

    final fillWidth = size.width * clampedProgress;
    final fillRect = Rect.fromLTWH(0, size.height / 2 - 2, fillWidth, 4);
    final fillMeter = RRect.fromRectAndRadius(
      fillRect,
      const Radius.circular(999),
    );
    canvas.drawRRect(
      fillMeter,
      Paint()
        ..shader = LinearGradient(
          colors: [accent.withValues(alpha: 0.8), color],
        ).createShader(fillRect),
    );

    if (fillWidth > 1) {
      canvas.drawCircle(
        Offset(fillWidth, size.height / 2),
        2.6,
        Paint()..color = color.withValues(alpha: 0.95),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SweepMeterPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.accent != accent ||
        oldDelegate.track != track;
  }
}

class _BadgeOrbitPainter extends CustomPainter {
  const _BadgeOrbitPainter({
    required this.progress,
    required this.secondary,
    required this.tertiary,
    required this.variant,
  });

  final double progress;
  final Color secondary;
  final Color tertiary;
  final PartyLaunchStageVariant variant;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final baseRadius =
        size.shortestSide *
        (variant == PartyLaunchStageVariant.opening ? 0.34 : 0.32);

    for (int i = 0; i < 2; i++) {
      final local = ((progress + i * 0.36) % 1.0);
      final radius = baseRadius + local * size.shortestSide * 0.14;
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = lerpDouble(1.2, 3.6, 1 - local)!
          ..color = secondary.withValues(alpha: 0.14 * (1 - local)),
      );
    }

    final orbitRect = Rect.fromCircle(
      center: center,
      radius:
          baseRadius *
          (variant == PartyLaunchStageVariant.opening ? 1.3 : 1.16),
    );
    canvas.drawArc(
      orbitRect,
      -math.pi / 2 + progress * math.pi * 2,
      math.pi * 0.7,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = variant == PartyLaunchStageVariant.opening ? 4.5 : 3.6
        ..shader = SweepGradient(
          colors: [
            secondary.withValues(alpha: 0.06),
            secondary.withValues(alpha: 0.9),
            tertiary.withValues(alpha: 0.62),
            secondary.withValues(alpha: 0.06),
          ],
          stops: const [0.0, 0.34, 0.66, 1.0],
          transform: GradientRotation(progress * math.pi * 2),
        ).createShader(orbitRect),
    );

    final sparklePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          secondary.withValues(alpha: 0.88),
          tertiary.withValues(alpha: 0.3),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: baseRadius * 1.5));
    for (int i = 0; i < 4; i++) {
      final phase = progress * math.pi * 2 + i * (math.pi * 2 / 4);
      final orbit =
          baseRadius *
          (variant == PartyLaunchStageVariant.opening ? 1.28 : 1.12);
      canvas.drawCircle(
        Offset(
          center.dx + math.cos(phase) * orbit,
          center.dy + math.sin(phase) * orbit,
        ),
        variant == PartyLaunchStageVariant.opening ? 4 : 3.2,
        sparklePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BadgeOrbitPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.secondary != secondary ||
        oldDelegate.tertiary != tertiary ||
        oldDelegate.variant != variant;
  }
}

class _PanelSheenPainter extends CustomPainter {
  const _PanelSheenPainter({
    required this.progress,
    required this.radius,
    required this.color,
  });

  final double progress;
  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final clip = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final sheenWidth = size.width * 0.28;
    final x = lerpDouble(-sheenWidth, size.width, progress)!;
    final rect = Rect.fromLTWH(x, 0, sheenWidth, size.height);

    canvas.save();
    canvas.clipRRect(clip);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.transparent,
            color.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.05),
            Colors.transparent,
          ],
          stops: const [0.0, 0.34, 0.62, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: const GradientRotation(-0.34),
        ).createShader(rect),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PanelSheenPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.radius != radius ||
        oldDelegate.color != color;
  }
}

class _ClubBackdropPainter extends CustomPainter {
  const _ClubBackdropPainter({
    required this.progress,
    required this.reveal,
    required this.variant,
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });

  final double progress;
  final double reveal;
  final PartyLaunchStageVariant variant;
  final Color primary;
  final Color secondary;
  final Color tertiary;

  @override
  void paint(Canvas canvas, Size size) {
    _paintGlow(
      canvas,
      center: Offset(size.width * 0.16, size.height * 0.16),
      radius: size.shortestSide * 0.3,
      color: primary.withValues(alpha: 0.16 * reveal),
    );
    _paintGlow(
      canvas,
      center: Offset(size.width * 0.84, size.height * 0.72),
      radius: size.shortestSide * 0.28,
      color: tertiary.withValues(alpha: 0.1 * reveal),
    );

    if (variant == PartyLaunchStageVariant.opening) {
      _paintBeam(
        canvas,
        size: size,
        start: Offset(size.width * 0.2, -size.height * 0.06),
        bend: Offset(size.width * 0.34, size.height * 0.38),
        end: Offset(size.width * 0.48, size.height * 0.94),
        color: secondary.withValues(alpha: 0.06 * reveal),
      );
      _paintBeam(
        canvas,
        size: size,
        start: Offset(size.width * 0.8, -size.height * 0.04),
        bend: Offset(size.width * 0.66, size.height * 0.42),
        end: Offset(size.width * 0.52, size.height * 0.94),
        color: tertiary.withValues(alpha: 0.04 * reveal),
      );
      _paintGlow(
        canvas,
        center: Offset(
          size.width * 0.5,
          size.height * (0.34 + math.sin(progress * math.pi * 2) * 0.008),
        ),
        radius: size.shortestSide * 0.24,
        color: secondary.withValues(alpha: 0.06 * reveal),
      );
      _paintFloor(
        canvas,
        rect: Rect.fromCenter(
          center: Offset(size.width * 0.5, size.height * 0.86),
          width: size.width * 0.5,
          height: size.height * 0.08,
        ),
        color: secondary.withValues(alpha: 0.08 * reveal),
      );
      _paintSparkles(
        canvas,
        size: size,
        count: 6,
        primaryColor: secondary.withValues(alpha: 0.18 * reveal),
        accentColor: tertiary.withValues(alpha: 0.12 * reveal),
      );
      return;
    }

    _paintBeam(
      canvas,
      size: size,
      start: Offset(size.width * 0.38, -size.height * 0.08),
      bend: Offset(size.width * 0.45, size.height * 0.28),
      end: Offset(size.width * 0.48, size.height * 0.88),
      color: secondary.withValues(alpha: 0.05 * reveal),
    );
    _paintBeam(
      canvas,
      size: size,
      start: Offset(size.width * 0.62, -size.height * 0.08),
      bend: Offset(size.width * 0.55, size.height * 0.28),
      end: Offset(size.width * 0.52, size.height * 0.88),
      color: tertiary.withValues(alpha: 0.04 * reveal),
    );
    _paintFloor(
      canvas,
      rect: Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.78),
        width: size.width * 0.44,
        height: size.height * 0.06,
      ),
      color: secondary.withValues(alpha: 0.06 * reveal),
    );
    _paintGlow(
      canvas,
      center: Offset(size.width * 0.5, size.height * 0.46),
      radius: size.shortestSide * 0.2,
      color: secondary.withValues(alpha: 0.04 * reveal),
    );
    _paintSparkles(
      canvas,
      size: size,
      count: 4,
      primaryColor: secondary.withValues(alpha: 0.14 * reveal),
      accentColor: primary.withValues(alpha: 0.1 * reveal),
    );
  }

  void _paintGlow(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required Color color,
  }) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [color, Colors.transparent],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  void _paintBeam(
    Canvas canvas, {
    required Size size,
    required Offset start,
    required Offset bend,
    required Offset end,
    required Color color,
  }) {
    final path = Path()
      ..moveTo(start.dx - size.width * 0.05, start.dy)
      ..quadraticBezierTo(bend.dx, bend.dy, end.dx, end.dy)
      ..quadraticBezierTo(
        bend.dx + size.width * 0.05,
        bend.dy,
        start.dx + size.width * 0.05,
        start.dy,
      )
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          colors: [color, Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(path.getBounds()),
    );
  }

  void _paintFloor(Canvas canvas, {required Rect rect, required Color color}) {
    canvas.drawOval(
      rect,
      Paint()
        ..shader = RadialGradient(
          colors: [color, Colors.transparent],
        ).createShader(rect),
    );
  }

  void _paintSparkles(
    Canvas canvas, {
    required Size size,
    required int count,
    required Color primaryColor,
    required Color accentColor,
  }) {
    for (int i = 0; i < count; i++) {
      final phase = progress * math.pi * 2 + i * 0.74;
      final x = size.width * (0.16 + i * (0.68 / math.max(1, count - 1)));
      final y = size.height * (0.16 + ((i % 2 == 0) ? 0.12 : 0.3));
      final glow = lerpDouble(1.2, 3.2, ((math.sin(phase) + 1) / 2))!;
      final color = i.isEven ? primaryColor : accentColor;
      canvas.drawCircle(
        Offset(x, y),
        glow * 2.2,
        Paint()
          ..shader = RadialGradient(colors: [color, Colors.transparent])
              .createShader(
                Rect.fromCircle(center: Offset(x, y), radius: glow * 2.2),
              ),
      );
      canvas.drawCircle(Offset(x, y), glow, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _ClubBackdropPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.reveal != reveal ||
        oldDelegate.variant != variant ||
        oldDelegate.primary != primary ||
        oldDelegate.secondary != secondary ||
        oldDelegate.tertiary != tertiary;
  }
}
