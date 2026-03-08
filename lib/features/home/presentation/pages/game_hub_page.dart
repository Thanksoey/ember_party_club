import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/widgets/app_expandable_panel.dart';
import '../../../../app/widgets/app_fade_in_up.dart';
import '../../../../app/widgets/app_panel.dart';
import '../../../../app/widgets/app_skeleton.dart';
import '../../../../core/models/game_module.dart';
import '../../../modules/chaos_mixer/application/chaos_mixer_controller.dart';
import '../../../modules/chaos_mixer/presentation/pages/chaos_mixer_page.dart';
import '../../../modules/midnight_vote/application/midnight_vote_controller.dart';
import '../../../modules/midnight_vote/presentation/pages/midnight_vote_page.dart';
import '../../../modules/orbit_merchant/application/orbit_merchant_controller.dart';
import '../../../modules/orbit_merchant/presentation/pages/orbit_merchant_page.dart';
import '../../../modules/signal_deck/application/signal_deck_controller.dart';
import '../../../modules/signal_deck/presentation/pages/signal_deck_page.dart';
import '../../application/game_hub_controller.dart';
import '../widgets/category_filter_row.dart';
import '../widgets/featured_banner.dart';
import '../widgets/game_module_card.dart';
import '../widgets/section_title.dart';

class GameHubPage extends StatelessWidget {
  const GameHubPage({super.key, required this.controller});

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
        final isHydrating = controller.isHydrating;

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
                        AppFadeInUp(
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary.withValues(
                                      alpha: 0.94,
                                    ),
                                    theme.colorScheme.secondary.withValues(
                                      alpha: 0.88,
                                    ),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.onPrimary
                                          .withValues(alpha: 0.16),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      l10n.discoverTab,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    l10n.homeHeroTitle,
                                    style: theme.textTheme.displaySmall
                                        ?.copyWith(
                                          color: theme.colorScheme.onPrimary,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    l10n.homeHeroBody,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onPrimary
                                          .withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        AppFadeInUp(
                          order: 1,
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _InsightCard(
                                label: l10n.modulesLabel,
                                value: '${controller.totalModuleCount}',
                                color: theme.colorScheme.primary,
                                icon: Icons.dashboard_customize_rounded,
                              ),
                              _InsightCard(
                                label: l10n.featuredLabel,
                                value: '${controller.featuredCount}',
                                color: theme.colorScheme.secondary,
                                icon: Icons.local_fire_department_rounded,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        AppFadeInUp(
                          order: 2,
                          child: isHydrating
                              ? const _FeaturedBannerSkeleton()
                              : FeaturedBanner(modules: featured),
                        ),
                        const SizedBox(height: 28),
                        AppFadeInUp(
                          order: 3,
                          child: isHydrating
                              ? const _FilterRowSkeleton()
                              : AppExpandablePanel(
                                  icon: Icons.tune_rounded,
                                  title: l10n.moduleFilterTitle,
                                  subtitle: controller.selectedCategory == null
                                      ? l10n.moduleFilterSubtitle
                                      : l10n.gameCategoryLabel(
                                          controller.selectedCategory!,
                                        ),
                                  accentColor: theme.colorScheme.secondary,
                                  child: CategoryFilterRow(
                                    categories: controller.categories,
                                    selectedCategory:
                                        controller.selectedCategory,
                                    onCategoryTap: controller.toggleCategory,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 28),
                        AppFadeInUp(
                          order: 4,
                          child: SectionTitle(
                            title: l10n.candidateGamesTitle(visible.length),
                            subtitle: l10n.candidateGamesSubtitle(
                              visible.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: isHydrating
                      ? SliverList.separated(
                          itemCount: 3,
                          itemBuilder: (context, index) => AppFadeInUp(
                            order: index,
                            child: const _GameModuleCardSkeleton(),
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                        )
                      : SliverList.separated(
                          itemCount: visible.length,
                          itemBuilder: (context, index) {
                            final module = visible[index];
                            return AppFadeInUp(
                              order: index,
                              child: GameModuleCard(
                                module: module,
                                isPlayable: true,
                                onOpen: () => _openModule(context, module),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
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
    if (module.id == 'chaos-mixer') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ChaosMixerPage(controller: ChaosMixerController()),
        ),
      );
      return;
    }
    if (module.id == 'midnight-vote') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              MidnightVotePage(controller: MidnightVoteController()),
        ),
      );
      return;
    }
    if (module.id == 'orbit-merchant') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              OrbitMerchantPage(controller: OrbitMerchantController()),
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

class _FeaturedBannerSkeleton extends StatelessWidget {
  const _FeaturedBannerSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppPanel(
      borderRadius: 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeletonBlock(width: 120, height: 30, radius: 999),
          SizedBox(height: 16),
          AppSkeletonBlock(width: 260, height: 30),
          SizedBox(height: 10),
          AppSkeletonBlock(height: 16),
          SizedBox(height: 8),
          AppSkeletonBlock(width: 300, height: 16),
        ],
      ),
    );
  }
}

class _FilterRowSkeleton extends StatelessWidget {
  const _FilterRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppPanel(
      borderRadius: 24,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          AppSkeletonBlock(width: 90, height: 32, radius: 999),
          AppSkeletonBlock(width: 120, height: 32, radius: 999),
          AppSkeletonBlock(width: 100, height: 32, radius: 999),
          AppSkeletonBlock(width: 86, height: 32, radius: 999),
        ],
      ),
    );
  }
}

class _GameModuleCardSkeleton extends StatelessWidget {
  const _GameModuleCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppPanel(
      padding: EdgeInsets.all(20),
      borderRadius: 28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppSkeletonBlock(width: 60, height: 72, radius: 22),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSkeletonBlock(height: 22, width: 220),
                    SizedBox(height: 8),
                    AppSkeletonBlock(height: 14, width: 180),
                  ],
                ),
              ),
              SizedBox(width: 12),
              AppSkeletonBlock(width: 70, height: 28, radius: 18),
            ],
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AppSkeletonBlock(width: 104, height: 34, radius: 999),
              AppSkeletonBlock(width: 110, height: 34, radius: 999),
              AppSkeletonBlock(width: 92, height: 34, radius: 999),
            ],
          ),
          SizedBox(height: 18),
          Row(
            children: [
              AppSkeletonBlock(width: 108, height: 40, radius: 16),
              Spacer(),
              AppSkeletonBlock(width: 120, height: 44, radius: 18),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppPanel(
      tint: color,
      borderOpacity: 0.18,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 156),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
