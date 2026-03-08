import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/services/app_feedback.dart';
import '../../../../app/widgets/app_ornate_card.dart';
import '../../../../app/widgets/app_panel.dart';

class GameGuideSectionData {
  const GameGuideSectionData({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
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
    final theme = Theme.of(context);
    final section = widget.sections[_currentStep];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.88,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: theme.textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  widget.subtitle,
                                  style: theme.textTheme.bodyLarge,
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
                              color: widget.accentColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: widget.accentColor.withValues(
                                  alpha: 0.22,
                                ),
                              ),
                            ),
                            child: Text(
                              widget.stepCounterLabelBuilder(
                                _currentStep + 1,
                                widget.sections.length,
                              ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: widget.accentColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            key: const ValueKey('game-guide-close'),
                            tooltip: MaterialLocalizations.of(
                              context,
                            ).closeButtonTooltip,
                            onPressed: _handleDismiss,
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: (_currentStep + 1) / widget.sections.length,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(999),
                        backgroundColor: widget.accentColor.withValues(
                          alpha: 0.12,
                        ),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.accentColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _GuideStepRail(
                        currentStep: _currentStep,
                        sections: widget.sections,
                        accentColor: widget.accentColor,
                        highlightColor: widget.highlightColor,
                        onTap: _goToStep,
                      ),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        child: AppOrnateCard(
                          key: ValueKey('guide-card-$_currentStep'),
                          accentColor: widget.accentColor,
                          highlightColor: widget.highlightColor,
                          aura: widget.aura,
                          borderRadius: 30,
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: widget.highlightColor.withValues(
                                    alpha: 0.18,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: widget.highlightColor.withValues(
                                      alpha: 0.24,
                                    ),
                                  ),
                                ),
                                child: Icon(
                                  section.icon,
                                  size: 26,
                                  color: widget.accentColor,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      section.title,
                                      style: theme.textTheme.headlineSmall,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      section.body,
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      AppPanel(
                        tint: widget.accentColor,
                        borderOpacity: 0.16,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: widget.accentColor.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: widget.accentColor.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                              child: Icon(
                                Icons.auto_awesome_rounded,
                                size: 20,
                                color: widget.accentColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.sections
                                    .map((item) => item.title)
                                    .join('  ·  '),
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _currentStep == 0 ? _handleDismiss : _goBack,
                      child: Text(
                        _currentStep == 0 ? widget.skipLabel : widget.backLabel,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _handlePrimaryAction,
                      child: Text(
                        _isLastStep ? widget.actionLabel : widget.nextLabel,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

class _GuideStepRail extends StatelessWidget {
  const _GuideStepRail({
    required this.currentStep,
    required this.sections,
    required this.accentColor,
    required this.highlightColor,
    required this.onTap,
  });

  final int currentStep;
  final List<GameGuideSectionData> sections;
  final Color accentColor;
  final Color highlightColor;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: sections
          .asMap()
          .entries
          .map((entry) {
            final index = entry.key;
            final section = entry.value;
            final isActive = index == currentStep;
            final isComplete = index < currentStep;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == sections.length - 1 ? 0 : 8,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? accentColor.withValues(alpha: 0.16)
                          : theme.colorScheme.surface.withValues(alpha: 0.84),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive
                            ? accentColor.withValues(alpha: 0.28)
                            : accentColor.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: (isActive || isComplete)
                                ? highlightColor.withValues(alpha: 0.2)
                                : accentColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isComplete ? Icons.check_rounded : section.icon,
                            size: 18,
                            color: isComplete ? accentColor : accentColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          section.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isActive
                                ? accentColor
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.78,
                                  ),
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          })
          .toList(growable: false),
    );
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
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => GameGuideSheet(
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
  );
}
