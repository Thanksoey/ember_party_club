import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/widgets/app_backdrop.dart';
import '../../../../app/widgets/app_fade_in_up.dart';
import '../../../../app/widgets/app_panel.dart';

class GameSessionScaffold extends StatelessWidget {
  const GameSessionScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.statusText,
    required this.metrics,
    required this.primaryPanel,
    required this.content,
    this.contextPanel,
    this.resultPanel,
    this.onReset,
    this.appBarActions = const [],
  });

  final String title;
  final String subtitle;
  final String statusText;
  final List<Widget> metrics;
  final Widget primaryPanel;
  final List<Widget> content;
  final Widget? contextPanel;
  final Widget? resultPanel;
  final VoidCallback? onReset;
  final List<Widget> appBarActions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          ...appBarActions,
          if (onReset != null)
            TextButton(onPressed: onReset, child: Text(context.l10n.reset)),
        ],
      ),
      body: AppBackdrop(
        showGrid: false,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              AppFadeInUp(
                order: 0,
                child: AppPanel(
                  tint: theme.colorScheme.secondary,
                  borderOpacity: 0.18,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        statusText,
                        style: theme.textTheme.bodyLarge,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              if (contextPanel != null) ...[
                const SizedBox(height: 20),
                AppFadeInUp(order: 1, child: contextPanel!),
              ],
              const SizedBox(height: 20),
              AppFadeInUp(
                order: 2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: metrics
                        .map(
                          (metric) => Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: metric,
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AppFadeInUp(order: 3, child: primaryPanel),
              if (resultPanel != null) ...[
                const SizedBox(height: 20),
                AppFadeInUp(order: 4, child: resultPanel!),
              ],
              const SizedBox(height: 20),
              ...content,
            ],
          ),
        ),
      ),
    );
  }
}

class GameSessionMetric extends StatelessWidget {
  const GameSessionMetric({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.accentColor,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.colorScheme.primary;

    return Container(
      constraints: const BoxConstraints(minWidth: 128, maxWidth: 164),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface.withValues(alpha: 0.96),
            accent.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: accent),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: theme.textTheme.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
