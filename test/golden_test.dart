import 'package:ember_party_club/app/app.dart';
import 'package:ember_party_club/core/data/game_seed_data.dart';
import 'package:ember_party_club/core/data/room_seed_data.dart';
import 'package:ember_party_club/features/auth/application/auth_controller.dart';
import 'package:ember_party_club/features/home/application/game_hub_controller.dart';
import 'package:ember_party_club/features/modules/application/game_module_registry.dart';
import 'package:ember_party_club/features/rooms/application/room_lounge_controller.dart';
import 'package:ember_party_club/features/settings/application/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  PartyForgeApp buildApp({required AuthController authController}) {
    final registry = GameModuleRegistry.seeded(GameSeedData.modules);
    return PartyForgeApp(
      gameHubController: GameHubController(registry: registry),
      roomLoungeController: RoomLoungeController.seeded(
        rooms: RoomSeedData.rooms,
        registry: registry,
      ),
      authController: authController,
      settingsController: SettingsController.test(themeMode: ThemeMode.light),
      locale: const Locale('zh'),
    );
  }

  Future<void> pumpGoldenApp(
    WidgetTester tester, {
    required AuthController authController,
  }) async {
    tester.view.physicalSize = const Size(1280, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildApp(authController: authController));
    await tester.pumpAndSettle(const Duration(milliseconds: 1800));
  }

  testWidgets('login page golden', (tester) async {
    await pumpGoldenApp(
      tester,
      authController: AuthController.unauthenticatedTest(),
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/login_page.png'),
    );
  });

  testWidgets('profile page golden', (tester) async {
    await pumpGoldenApp(
      tester,
      authController: AuthController.test(),
    );

    await tester.tap(find.text('我的').last);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/profile_page.png'),
    );
  });
}
