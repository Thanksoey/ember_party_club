import 'package:flutter/material.dart';

import '../core/data/game_seed_data.dart';
import '../features/home/application/game_hub_controller.dart';
import '../features/home/presentation/pages/game_hub_page.dart';
import 'theme/app_theme.dart';

class PartyForgeApp extends StatelessWidget {
  const PartyForgeApp({
    super.key,
    required this.controller,
  });

  final GameHubController controller;

  static void bootstrap() {
    final controller = GameHubController.seeded(GameSeedData.modules);
    runApp(PartyForgeApp(controller: controller));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ember Party Club',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: GameHubPage(controller: controller),
    );
  }
}

