import 'package:flutter/material.dart';

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
        final featured = controller.featuredModules;
        final visible = controller.visibleModules;

        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ember Party Club',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '给朋友局而不是单机局设计的移动游戏中心',
                          style: theme.textTheme.displaySmall,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '核心方向是低延迟房间、可插拔游戏模块、稳定语音互动，以及能长期演进的企业级代码结构。',
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        FeaturedBanner(modules: featured),
                        const SizedBox(height: 28),
                        const SectionTitle(
                          title: '模块筛选',
                          subtitle: '先用统一房间层承接，再逐步扩展到卡牌、推理和派对小游戏。',
                        ),
                        const SizedBox(height: 16),
                        CategoryFilterRow(
                          categories: controller.categories,
                          selectedCategory: controller.selectedCategory,
                          onCategoryTap: controller.toggleCategory,
                        ),
                        const SizedBox(height: 28),
                        SectionTitle(
                          title: '候选游戏',
                          subtitle: '当前展示 ${visible.length} 个适合首期版本立项的模块。',
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
                      return GameModuleCard(module: visible[index]);
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
}

