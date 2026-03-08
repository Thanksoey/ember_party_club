import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/services/app_feedback.dart';
import '../../../../app/widgets/app_ornate_card.dart';

enum GameGuideSpotlightShape { roundedRect, circle }

class GameGuideSectionData {
  const GameGuideSectionData({
    required this.icon,
    required this.title,
    required this.body,
    this.targetKey,
    this.spotlightPadding = const EdgeInsets.all(12),
    this.spotlightShape = GameGuideSpotlightShape.roundedRect,
  });

  final IconData icon;
  final String title;
  final String body;
  final GlobalKey? targetKey;
  final EdgeInsets spotlightPadding;
  final GameGuideSpotlightShape spotlightShape;
}

class GameGuideSheet extends StatefulWidget {
  const GameGuideSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.highlightColor,
    required this.aura,
    required this.sections,
    required this.actionLabel,
    required this.backLabel,
    required this.nextLabel,
    required this.skipLabel,
    required this.stepCounterLabelBuilder,
  });

  final String title;
  final String subtitle;
  final Color accentColor;
  final Color highlightColor;
  final AppOrnateCardAura aura;
  final List<GameGuideSectionData> sections;
  final String actionLabel;
  final String backLabel;
  final String nextLabel;
  final String skipLabel;
  final String Function(int current, int total) stepCounterLabelBuilder;

  @override
  State<GameGuideSheet> createState() => _GameGuideSheetState();
}

class _GameGuideSheetState extends State<GameGuideSheet> {
  int _currentStep = 0;

  bool get _isLastStep => _currentStep == widget.sections.length - 1;

  @override
  Widget build(BuildContext context) {
    final section = widget.sections[_currentStep];
    final media = MediaQuery.of(context);
    final size = media.size;
    final spotlightRect = _resolveSpotlightRect(section);
    final calloutWidth = math.min(392.0, size.width - 32);
    final calloutLeft = spotlightRect == null
        ? (size.width - calloutWidth) / 2
        : spotlightRect.left.clamp(16.0, size.width - calloutWidth - 16.0);
    final showBelow = spotlightRect == null
        ? false
        : spotlightRect.center.dy < size.height * 0.45;
    final calloutTop = spotlightRect == null
        ? null
        : math.min(
            spotlightRect.bottom + 18,
            size.height - media.padding.bottom - 260,
          );
    final calloutBottom = spotlightRect == null
        ? 24.0 + media.padding.bottom
        : showBelow
        ? null
        : (size.height - spotlightRect.top) + 18;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: const Color(0xFF05080D).withValues(alpha: 0.74),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _GuideScrimPainter(
                  accentColor: widget.accentColor,
                  highlightColor: widget.highlightColor,
                  spotlightRect: spotlightRect,
                  spotlightShape: section.spotlightShape,
                ),
              ),
            ),
          ),
          if (spotlightRect != null)
            Positioned.fromRect(
              rect: spotlightRect,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      section.spotlightShape == GameGuideSpotlightShape.circle
                          ? spotlightRect.shortestSide
                          : 28,
                    ),
                    border: Border.all(
                      color: widget.highlightColor.withValues(alpha: 0.72),
                      width: 1.6,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.highlightColor.withValues(alpha: 0.28),
                        blurRadius: 26,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            left: calloutLeft,
            width: calloutWidth,
            top: spotlightRect == null || showBelow ? calloutTop : null,
            bottom: calloutBottom,
            child: _GuideCalloutCard(
              title: widget.title,
              subtitle: widget.subtitle,
              accentColor: widget.accentColor,
              highlightColor: widget.highlightColor,
              aura: widget.aura,
              section: section,
              currentStep: _currentStep,
              totalSteps: widget.sections.length,
              isLastStep: _isLastStep,
              actionLabel: widget.actionLabel,
              backLabel: widget.backLabel,
              nextLabel: widget.nextLabel,
              skipLabel: widget.skipLabel,
              stepCounterLabel: widget.stepCounterLabelBuilder(
                _currentStep + 1,
                widget.sections.length,
              ),
              onClose: _handleDismiss,
              onBack: _goBack,
              onPrimaryAction: _handlePrimaryAction,
              onJumpToStep: _goToStep,
            ),
          ),
        ],
      ),
    );
  }

  Rect? _resolveSpotlightRect(GameGuideSectionData section) {
    final targetContext = section.targetKey?.currentContext;
    if (targetContext == null) {
      return null;
    }
    final renderObject = targetContext.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return null;
    }
    final offset = renderObject.localToGlobal(Offset.zero);
    final rect = offset & renderObject.size;
    return Rect.fromLTRB(
      rect.left - section.spotlightPadding.left,
      rect.top - section.spotlightPadding.top,
      rect.right + section.spotlightPadding.right,
      rect.bottom + section.spotlightPadding.bottom,
    );
  }

  void _goToStep(int index) {
    if (index == _currentStep || index < 0 || index >= widget.sections.length) {
      return;
    }
    unawaited(AppFeedback.instance.play(AppFeedbackType.guideStep));
    setState(() {
      _currentStep = index;
    });
  }

  void _goBack() {
    if (_currentStep == 0) {
      _handleDismiss();
      return;
    }
    _goToStep(_currentStep - 1);
  }

  void _handlePrimaryAction() {
    if (_isLastStep) {
      unawaited(AppFeedback.instance.play(AppFeedbackType.guideReady));
      Navigator.of(context).pop();
      return;
    }
    _goToStep(_currentStep + 1);
  }

  void _handleDismiss() {
    unawaited(AppFeedback.instance.play(AppFeedbackType.tap));
    Navigator.of(context).pop();
  }
}

class _GuideCalloutCard extends StatelessWidget {
  const _GuideCalloutCard({
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.highlightColor,
    required this.aura,
    required this.section,
    required this.currentStep,
    required this.totalSteps,
    required this.isLastStep,
    required this.actionLabel,
    required this.backLabel,
    required this.nextLabel,
    required this.skipLabel,
    required this.stepCounterLabel,
    required this.onClose,
    required this.onBack,
    required this.onPrimaryAction,
    required this.onJumpToStep,
  });

  final String title;
  final String subtitle;
  final Color accentColor;
  final Color highlightColor;
  final AppOrnateCardAura aura;
  final GameGuideSectionData section;
  final int currentStep;
  final int totalSteps;
  final bool isLastStep;
  final String actionLabel;
  final String backLabel;
  final String nextLabel;
  final String skipLabel;
  final String stepCounterLabel;
  final VoidCallback onClose;
  final VoidCallback onBack;
  final VoidCallback onPrimaryAction;
  final ValueChanged<int> onJumpToStep;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: AppOrnateCard(
        accentColor: accentColor,
        highlightColor: highlightColor,
        aura: aura,
        borderRadius: 30,
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        subtitle,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    stepCounterLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  key: const ValueKey('game-guide-close'),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: highlightColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: highlightColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(section.icon, color: accentColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.title,
                        style: theme.textTheme.titleLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(section.body, style: theme.textTheme.bodyLarge),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(totalSteps, (index) {
                final isActive = index == currentStep;
                final isComplete = index < currentStep;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == totalSteps - 1 ? 0 : 6,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () => onJumpToStep(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        height: 10,
                        decoration: BoxDecoration(
                          color: isActive || isComplete
                              ? accentColor
                              : accentColor.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: highlightColor.withValues(
                                      alpha: 0.24,
                                    ),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: currentStep == 0 ? onClose : onBack,
                    child: Text(currentStep == 0 ? skipLabel : backLabel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: onPrimaryAction,
                    child: Text(isLastStep ? actionLabel : nextLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideScrimPainter extends CustomPainter {
  const _GuideScrimPainter({
    required this.accentColor,
    required this.highlightColor,
    required this.spotlightRect,
    required this.spotlightShape,
  });

  final Color accentColor;
  final Color highlightColor;
  final Rect? spotlightRect;
  final GameGuideSpotlightShape spotlightShape;

  @override
  void paint(Canvas canvas, Size size) {
    final fullRect = Offset.zero & size;
    final path = Path()..addRect(fullRect);
    if (spotlightRect != null) {
      switch (spotlightShape) {
        case GameGuideSpotlightShape.roundedRect:
          path.addRRect(
            RRect.fromRectAndRadius(spotlightRect!, const Radius.circular(28)),
          );
        case GameGuideSpotlightShape.circle:
          path.addOval(spotlightRect!);
      }
      path.fillType = PathFillType.evenOdd;
    }

    final scrim = Paint()
      ..color = const Color(0xFF020507).withValues(alpha: 0.72);
    canvas.drawPath(path, scrim);

    if (spotlightRect != null) {
      final halo = Paint()
        ..color = highlightColor.withValues(alpha: 0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);
      switch (spotlightShape) {
        case GameGuideSpotlightShape.roundedRect:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              spotlightRect!.inflate(8),
              const Radius.circular(32),
            ),
            halo,
          );
        case GameGuideSpotlightShape.circle:
          canvas.drawOval(spotlightRect!.inflate(8), halo);
      }
    }

    final ambient = Paint()
      ..shader = LinearGradient(
        colors: [
          accentColor.withValues(alpha: 0.08),
          Colors.transparent,
          highlightColor.withValues(alpha: 0.08),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(fullRect);
    canvas.drawRect(fullRect, ambient);
  }

  @override
  bool shouldRepaint(covariant _GuideScrimPainter oldDelegate) {
    return oldDelegate.accentColor != accentColor ||
        oldDelegate.highlightColor != highlightColor ||
        oldDelegate.spotlightRect != spotlightRect ||
        oldDelegate.spotlightShape != spotlightShape;
  }
}

Future<void> showGameGuideSheet({
  required BuildContext context,
  required String title,
  required String subtitle,
  required Color accentColor,
  required Color highlightColor,
  required AppOrnateCardAura aura,
  required List<GameGuideSectionData> sections,
  required String actionLabel,
  required String backLabel,
  required String nextLabel,
  required String skipLabel,
  required String Function(int current, int total) stepCounterLabelBuilder,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,
    pageBuilder: (_, __, ___) => SafeArea(
      child: GameGuideSheet(
        title: title,
        subtitle: subtitle,
        accentColor: accentColor,
        highlightColor: highlightColor,
        aura: aura,
        sections: sections,
        actionLabel: actionLabel,
        backLabel: backLabel,
        nextLabel: nextLabel,
        skipLabel: skipLabel,
        stepCounterLabelBuilder: stepCounterLabelBuilder,
      ),
    ),
  );
}
