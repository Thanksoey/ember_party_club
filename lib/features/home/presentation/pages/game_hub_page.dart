import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../core/models/game_module.dart';
import '../../../modules/signal_deck/application/signal_deck_controller.dart';
import '../../../modules/signal_deck/presentation/pages/signal_deck_page.dart';
import '../../application/game_hub_controller.dart';
import '../widgets/category_filter_row.dart';
import '../widgets/featured_banner.dart';
import '../widgets/game_module_card.dart';
import '../widgets/section_title.dart';

class GameHubPage extends StatelessWidget {
  const GameHubPage({
    super.key,
    required this.controller,
  });

  final GameHubController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final theme = Theme.of(context);
        final l10n = context.l10n;
        final featured = controller.featuredModules;
        final visible = controller.visibleModules;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary.withValues(alpha: 0.94),
                                  theme.colorScheme.secondary.withValues(alpha: 0.88),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.14),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    l10n.discoverTab,
                                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  l10n.homeHeroTitle,
                                  style: theme.textTheme.displaySmall?.copyWith(color: Colors.white),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l10n.homeHeroBody,
                                  style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _InsightCard(
                                label: l10n.modulesLabel,
                                value: '${controller.totalModuleCount}',
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _InsightCard(
                                label: l10n.featuredLabel,
                                value: '${controller.featuredCount}',
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        FeaturedBanner(modules: featured),
                        const SizedBox(height: 28),
                        SectionTitle(
                          title: l10n.moduleFilterTitle,
                          subtitle: l10n.moduleFilterSubtitle,
                        ),
                        const SizedBox(height: 16),
                        CategoryFilterRow(
                          categories: controller.categories,
                          selectedCategory: controller.selectedCategory,
                          onCategoryTap: controller.toggleCategory,
                        ),
                        const SizedBox(height: 28),
                        SectionTitle(
                          title: l10n.candidateGamesTitle(visible.length),
                          subtitle: l10n.candidateGamesSubtitle(visible.length),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: SliverList.separated(
                    itemCount: visible.length,
                    itemBuilder: (context, index) {
                      final module = visible[index];
                      return GameModuleCard(
                        module: module,
                        isPlayable: module.id == 'signal-deck',
                        onOpen: () => _openModule(context, module),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openModule(BuildContext context, GameModule module) {
    if (module.id == 'signal-deck') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => SignalDeckPage(controller: SignalDeckController()),
        ),
      );
      return;
    }

    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.planningQueue(l10n.moduleName(module)))),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
