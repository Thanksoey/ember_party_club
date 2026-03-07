import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../core/models/game_module.dart';

class GameModuleCard extends StatelessWidget {
  const GameModuleCard({
    super.key,
    required this.module,
    required this.onOpen,
    required this.isPlayable,
  });

  final GameModule module;
  final VoidCallback onOpen;
  final bool isPlayable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final readinessPercent = (module.readiness * 100).round();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withValues(alpha: 0.88),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.moduleName(module), style: theme.textTheme.titleLarge),
                        const SizedBox(height: 6),
                        Text(l10n.moduleTagline(module), style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$readinessPercent%',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: module.readiness,
                  minHeight: 8,
                  backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.18),
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.moduleSummary(module), style: theme.textTheme.bodyLarge),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _MetaPill(label: l10n.gameCategoryLabel(module.category)),
                  _MetaPill(label: l10n.playersLabel(module.minPlayers, module.maxPlayers)),
                  _MetaPill(label: l10n.matchTempoLabel(module.tempo)),
                ],
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  key: ValueKey('open-${module.id}'),
                  onPressed: onOpen,
                  child: Text(isPlayable ? l10n.playPrototype : l10n.viewPlan),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
