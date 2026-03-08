import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/widgets/app_ornate_card.dart';
import '../../../../core/models/game_module.dart';

class GameModuleCard extends StatefulWidget {
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
  State<GameModuleCard> createState() => _GameModuleCardState();
}

class _GameModuleCardState extends State<GameModuleCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final module = widget.module;
    final readinessPercent = (module.readiness * 100).round();
    final style = _styleFor(module.category);

    return AppOrnateCard(
      aura: style.aura,
      accentColor: style.accent,
      highlightColor: style.highlight,
      borderRadius: 30,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ModuleSigil(
                icon: style.icon,
                accent: style.accent,
                label: l10n.gameCategoryLabel(module.category),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.moduleName(module),
                      style: theme.textTheme.headlineSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.moduleTagline(module),
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _ReadinessBadge(
                percent: readinessPercent,
                accent: style.highlight,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _MetaGlyph(
                icon: Icons.people_alt_outlined,
                label: l10n.playersLabel(module.minPlayers, module.maxPlayers),
                accent: style.accent,
              ),
              _MetaGlyph(
                icon: Icons.schedule_rounded,
                label: l10n.matchTempoLabel(module.tempo),
                accent: style.highlight,
              ),
              _MetaGlyph(
                icon: style.icon,
                label: l10n.gameCategoryLabel(module.category),
                accent: theme.colorScheme.secondary,
              ),
            ],
          ),
          AnimatedCrossFade(
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 240),
            sizeCurve: Curves.easeOutCubic,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.moduleSummary(module),
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        l10n.moduleReadinessLabel,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: style.highlight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: module.readiness,
                            minHeight: 8,
                            backgroundColor: theme.colorScheme.outline
                                .withValues(alpha: 0.18),
                            color: style.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                ),
                label: Text(
                  _expanded ? l10n.collapseDetails : l10n.expandDetails,
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                key: ValueKey('open-${module.id}'),
                onPressed: widget.onOpen,
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(
                  widget.isPlayable ? l10n.playPrototype : l10n.viewPlan,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _ModuleStyle _styleFor(GameCategory category) {
    return switch (category) {
      GameCategory.card => const _ModuleStyle(
        accent: Color(0xFFD45C37),
        highlight: Color(0xFFFFC36D),
        aura: AppOrnateCardAura.ember,
        icon: Icons.style_rounded,
      ),
      GameCategory.party => const _ModuleStyle(
        accent: Color(0xFFB85E29),
        highlight: Color(0xFFFFC86F),
        aura: AppOrnateCardAura.aurora,
        icon: Icons.celebration_rounded,
      ),
      GameCategory.bluff => const _ModuleStyle(
        accent: Color(0xFF6B4A71),
        highlight: Color(0xFFBDA1D4),
        aura: AppOrnateCardAura.noir,
        icon: Icons.visibility_rounded,
      ),
      GameCategory.strategy => const _ModuleStyle(
        accent: Color(0xFF2E6E7C),
        highlight: Color(0xFF8EE0D7),
        aura: AppOrnateCardAura.solar,
        icon: Icons.hub_rounded,
      ),
    };
  }
}

class _ModuleStyle {
  const _ModuleStyle({
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

class _ModuleSigil extends StatelessWidget {
  const _ModuleSigil({
    required this.icon,
    required this.accent,
    required this.label,
  });

  final IconData icon;
  final Color accent;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 60,
      height: 72,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0.24),
            Colors.white.withValues(alpha: 0.06),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent),
          const SizedBox(height: 8),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadinessBadge extends StatelessWidget {
  const _ReadinessBadge({required this.percent, required this.accent});

  final int percent;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Text(
        '$percent%',
        style: theme.textTheme.titleMedium?.copyWith(
          color: accent,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MetaGlyph extends StatelessWidget {
  const _MetaGlyph({
    required this.icon,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
