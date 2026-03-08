import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'app_loading_indicator.dart';
import 'brand_mark.dart';

class AppStartupStage extends StatefulWidget {
  const AppStartupStage({
    super.key,
    required this.title,
    required this.caption,
    required this.statusLabel,
    required this.detailsLabel,
    required this.stageDuration,
    this.overline = 'EMBER PARTY CLUB',
  });

  final String overline;
  final String title;
  final String caption;
  final String statusLabel;
  final String detailsLabel;
  final Duration stageDuration;

  @override
  State<AppStartupStage> createState() => _AppStartupStageState();
}

class _AppStartupStageState extends State<AppStartupStage>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _ambientController;
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6800),
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
    final isLight = theme.brightness == Brightness.light;
    final backgroundColors = isLight
        ? const [Color(0xFFFDF4EA), Color(0xFFF8E9DC), Color(0xFFF4E0D2)]
        : const [Color(0xFF080505), Color(0xFF140D0A), Color(0xFF1E120D)];

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
          final progress = Curves.easeInOutCubic.transform(
            _progressController.value.clamp(0.0, 1.0),
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: backgroundColors,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _StartupBackdropPainter(
                      progress: ambient,
                      reveal: intro,
                      isLight: isLight,
                      primary: scheme.primary,
                      secondary: scheme.secondary,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 470),
                      child: Opacity(
                        opacity: intro,
                        child: Transform.translate(
                          offset: Offset(0, lerpDouble(14, 0, intro) ?? 0),
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: 44,
                                right: 44,
                                bottom: -28,
                                child: IgnorePointer(
                                  child: Container(
                                    height: 44,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(999),
                                      gradient: RadialGradient(
                                        colors: [
                                          scheme.secondary.withValues(
                                            alpha: isLight ? 0.28 : 0.2,
                                          ),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(34),
                                  gradient: LinearGradient(
                                    colors: isLight
                                        ? const [
                                            Color(0xFFEEDBC2),
                                            Color(0xFFC79E62),
                                            Color(0xFFF8E7D2),
                                          ]
                                        : const [
                                            Color(0xFF5E4A32),
                                            Color(0xFFD7AF73),
                                            Color(0xFF87663C),
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          (isLight
                                                  ? Colors.brown
                                                  : Colors.black)
                                              .withValues(
                                                alpha: isLight ? 0.2 : 0.34,
                                              ),
                                      blurRadius: 42,
                                      offset: const Offset(0, 24),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(1.6),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32),
                                    gradient: LinearGradient(
                                      colors: isLight
                                          ? [
                                              Colors.white.withValues(
                                                alpha: 0.96,
                                              ),
                                              const Color(
                                                0xFFF9EFE7,
                                              ).withValues(alpha: 0.94),
                                            ]
                                          : [
                                              const Color(
                                                0xFF241914,
                                              ).withValues(alpha: 0.94),
                                              const Color(
                                                0xFF15100E,
                                              ).withValues(alpha: 0.96),
                                            ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    border: Border.all(
                                      color: scheme.secondary.withValues(
                                        alpha: isLight ? 0.24 : 0.34,
                                      ),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: IgnorePointer(
                                          child: CustomPaint(
                                            painter: _StartupPanelSheenPainter(
                                              progress: ambient,
                                              radius: 32,
                                              isLight: isLight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 18,
                                        left: 24,
                                        right: 24,
                                        child: Container(
                                          height: 1,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.transparent,
                                                scheme.secondary.withValues(
                                                  alpha: isLight ? 0.34 : 0.3,
                                                ),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          26,
                                          28,
                                          26,
                                          22,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              widget.overline,
                                              textAlign: TextAlign.center,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    letterSpacing: 3.2,
                                                    fontWeight: FontWeight.w800,
                                                    color: scheme.secondary
                                                        .withValues(
                                                          alpha: isLight
                                                              ? 0.88
                                                              : 0.84,
                                                        ),
                                                  ),
                                            ),
                                            const SizedBox(height: 12),
                                            const BrandMark(size: 90),
                                            const SizedBox(height: 12),
                                            Text(
                                              widget.title,
                                              textAlign: TextAlign.center,
                                              style: theme
                                                  .textTheme
                                                  .headlineMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w900,
                                                    letterSpacing: -0.3,
                                                  ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              widget.caption,
                                              textAlign: TextAlign.center,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    height: 1.55,
                                                    fontWeight: FontWeight.w600,
                                                    color: scheme.onSurface
                                                        .withValues(
                                                          alpha: isLight
                                                              ? 0.78
                                                              : 0.74,
                                                        ),
                                                  ),
                                            ),
                                            const SizedBox(height: 18),
                                            Text(
                                              widget.statusLabel,
                                              textAlign: TextAlign.center,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                    letterSpacing: 0.3,
                                                  ),
                                            ),
                                            const SizedBox(height: 12),
                                            _SimpleProgressBar(
                                              progress: progress,
                                              width: 236,
                                              color: scheme.secondary,
                                              accent: scheme.tertiary,
                                              track: scheme.outline.withValues(
                                                alpha: isLight ? 0.3 : 0.36,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '${(progress * 100).round().clamp(0, 100)}%',
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                    color: scheme.secondary
                                                        .withValues(alpha: 0.9),
                                                  ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const AppLoadingIndicator(
                                                  size: 20,
                                                  strokeWidth: 2.2,
                                                ),
                                                const SizedBox(width: 8),
                                                Flexible(
                                                  child: Text(
                                                    widget.detailsLabel,
                                                    textAlign: TextAlign.center,
                                                    style: theme
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: scheme
                                                              .onSurface
                                                              .withValues(
                                                                alpha: 0.66,
                                                              ),
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
                              ),
                            ],
                          ),
                        ),
                      ),
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

class _StartupPanelSheenPainter extends CustomPainter {
  const _StartupPanelSheenPainter({
    required this.progress,
    required this.radius,
    required this.isLight,
  });

  final double progress;
  final double radius;
  final bool isLight;

  @override
  void paint(Canvas canvas, Size size) {
    final clip = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final sheenWidth = size.width * 0.3;
    final x = lerpDouble(-sheenWidth, size.width + sheenWidth, progress)!;
    final rect = Rect.fromLTWH(x - sheenWidth, 0, sheenWidth, size.height);

    canvas.save();
    canvas.clipRRect(clip);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withValues(alpha: isLight ? 0.14 : 0.08),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: const GradientRotation(-0.34),
        ).createShader(rect),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _StartupPanelSheenPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.radius != radius ||
        oldDelegate.isLight != isLight;
  }
}

class _SimpleProgressBar extends StatelessWidget {
  const _SimpleProgressBar({
    required this.progress,
    required this.width,
    required this.color,
    required this.accent,
    required this.track,
  });

  final double progress;
  final double width;
  final Color color;
  final Color accent;
  final Color track;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    return SizedBox(
      width: width,
      height: 8,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: track,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: clamped,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: LinearGradient(
                  colors: [accent.withValues(alpha: 0.84), color],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StartupBackdropPainter extends CustomPainter {
  const _StartupBackdropPainter({
    required this.progress,
    required this.reveal,
    required this.isLight,
    required this.primary,
    required this.secondary,
  });

  final double progress;
  final double reveal;
  final bool isLight;
  final Color primary;
  final Color secondary;

  @override
  void paint(Canvas canvas, Size size) {
    final leftGlow = isLight
        ? primary.withValues(alpha: 0.08 * reveal)
        : primary.withValues(alpha: 0.14 * reveal);
    final rightGlow = isLight
        ? secondary.withValues(alpha: 0.06 * reveal)
        : secondary.withValues(alpha: 0.1 * reveal);

    _paintGlow(
      canvas,
      center: Offset(size.width * 0.2, size.height * 0.2),
      radius: size.shortestSide * 0.28,
      color: leftGlow,
    );
    _paintGlow(
      canvas,
      center: Offset(size.width * 0.8, size.height * 0.72),
      radius: size.shortestSide * 0.26,
      color: rightGlow,
    );

    final beamColor = isLight
        ? secondary.withValues(alpha: 0.05 * reveal)
        : secondary.withValues(alpha: 0.08 * reveal);
    _paintBeam(
      canvas,
      size: size,
      start: Offset(size.width * 0.26, -size.height * 0.04),
      bend: Offset(size.width * 0.38, size.height * 0.32),
      end: Offset(size.width * 0.45, size.height * 0.9),
      color: beamColor,
    );
    _paintBeam(
      canvas,
      size: size,
      start: Offset(size.width * 0.74, -size.height * 0.04),
      bend: Offset(size.width * 0.62, size.height * 0.3),
      end: Offset(size.width * 0.55, size.height * 0.9),
      color: beamColor.withValues(alpha: beamColor.a * 0.85),
    );

    for (int i = 0; i < 3; i++) {
      final phase = progress * math.pi * 2 + i * 1.4;
      final x = size.width * (0.28 + i * 0.22);
      final y = size.height * (0.2 + math.sin(phase) * 0.012);
      final pulse = lerpDouble(1.8, 3.2, (math.cos(phase) + 1) / 2)!;
      final dotColor = (i.isEven ? secondary : primary).withValues(
        alpha: (isLight ? 0.4 : 0.56) * reveal,
      );
      canvas.drawCircle(Offset(x, y), pulse, Paint()..color = dotColor);
    }
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
      ..moveTo(start.dx - size.width * 0.045, start.dy)
      ..quadraticBezierTo(bend.dx, bend.dy, end.dx, end.dy)
      ..quadraticBezierTo(
        bend.dx + size.width * 0.045,
        bend.dy,
        start.dx + size.width * 0.045,
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

  @override
  bool shouldRepaint(covariant _StartupBackdropPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.reveal != reveal ||
        oldDelegate.isLight != isLight ||
        oldDelegate.primary != primary ||
        oldDelegate.secondary != secondary;
  }
}
