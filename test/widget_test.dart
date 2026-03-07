import 'package:ember_party_club/app/app.dart';
import 'package:ember_party_club/core/data/game_seed_data.dart';
import 'package:ember_party_club/core/data/room_seed_data.dart';
import 'package:ember_party_club/features/auth/application/auth_controller.dart';
import 'package:ember_party_club/features/auth/data/dev_seed_auth_repository.dart';
import 'package:ember_party_club/features/auth/domain/auth_session.dart';
import 'package:ember_party_club/features/auth/domain/auth_token_bundle.dart';
import 'package:ember_party_club/features/home/application/game_hub_controller.dart';
import 'package:ember_party_club/features/modules/application/game_module_registry.dart';
import 'package:ember_party_club/features/rooms/application/room_lounge_controller.dart';
import 'package:ember_party_club/features/settings/application/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  PartyForgeApp buildApp({
    ThemeMode themeMode = ThemeMode.system,
    AppLocaleMode localeMode = AppLocaleMode.system,
    AuthController? authController,
    Locale? locale = const Locale('zh'),
  }) {
    final registry = GameModuleRegistry.seeded(GameSeedData.modules);
    return PartyForgeApp(
      gameHubController: GameHubController(registry: registry),
      roomLoungeController: RoomLoungeController.seeded(
        rooms: RoomSeedData.rooms,
        registry: registry,
      ),
      authController: authController ?? AuthController.test(),
      settingsController: SettingsController.test(
        themeMode: themeMode,
        localeMode: localeMode,
      ),
      locale: locale,
    );
  }

  Future<void> pumpPartyApp(
    WidgetTester tester, {
    ThemeMode themeMode = ThemeMode.system,
    AppLocaleMode localeMode = AppLocaleMode.system,
    AuthController? authController,
    Locale? locale = const Locale('zh'),
  }) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        themeMode: themeMode,
        localeMode: localeMode,
        authController: authController,
        locale: locale,
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 1800));
  }

  testWidgets('shows login page and can sign in', (tester) async {
    await pumpPartyApp(
      tester,
      authController: AuthController.unauthenticatedTest(),
    );

    expect(find.text('登录你的派对中枢'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('login-submit')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle(const Duration(milliseconds: 1600));

    expect(find.text('余烬派对社'), findsWidgets);
    expect(find.text('我的'), findsWidgets);
  });

  testWidgets('renders discover and rooms shell content in Chinese', (tester) async {
    await pumpPartyApp(tester);

    expect(find.text('余烬派对社'), findsWidgets);
    expect(find.text('发现'), findsWidgets);
    expect(find.text('房间'), findsWidgets);
    expect(find.text('我的'), findsWidgets);

    await tester.tap(find.text('房间').last);
    await tester.pumpAndSettle();

    expect(find.text('房间大厅'), findsWidgets);
    expect(find.text('快速匹配'), findsOneWidget);
    expect(find.text('活跃房间'), findsWidgets);
  });

  testWidgets('opens Signal Deck prototype with Chinese copy', (tester) async {
    await pumpPartyApp(tester);

    final button = find.byKey(const ValueKey('open-signal-deck'));
    await tester.scrollUntilVisible(
      button,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('信号牌局'), findsOneWidget);
    expect(find.text('你的手牌'), findsOneWidget);
    expect(find.text('出牌'), findsWidgets);
  });

  testWidgets('creates a Signal Deck room and advances room session phase from room flow', (tester) async {
    await pumpPartyApp(tester);

    await tester.tap(find.text('房间').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('open-create-room')));
    await tester.pumpAndSettle();

    expect(find.text('创建房间'), findsWidgets);
    expect(find.text('信号牌局 房间'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('submit-create-room')));
    await tester.pumpAndSettle();

    expect(find.text('房间详情'), findsOneWidget);
    expect(find.text('开始游戏'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('start-room-game')));
    await tester.pumpAndSettle();

    expect(find.text('房间会话'), findsOneWidget);
    expect(find.text('准备阶段'), findsOneWidget);
    expect(find.textContaining('已绑定房间'), findsOneWidget);

    await tester.tap(find.text('出牌').first);
    await tester.pumpAndSettle();

    expect(find.text('对局进行中'), findsOneWidget);
    expect(find.text('你的手牌'), findsOneWidget);
  });

  testWidgets('can switch theme and locale from profile settings', (tester) async {
    await pumpPartyApp(tester, locale: null);

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    expect(find.text('User center'), findsOneWidget);
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);
    expect(materialApp.locale, const Locale('en'));
  });

  testWidgets('can edit profile and reflect changes in shell header', (tester) async {
    await pumpPartyApp(tester);

    await tester.tap(find.text('我的').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('编辑资料'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('profile-display-name')), '星舰队长');
    await tester.enterText(find.byKey(const ValueKey('profile-bio')), '负责好友局的首轮试玩。');
    await tester.tap(find.byKey(const ValueKey('avatar-seed-3')));
    await tester.tap(find.byKey(const ValueKey('save-profile')));
    await tester.pumpAndSettle();

    expect(find.text('星舰队长'), findsWidgets);
  });

  testWidgets('admin account can open admin console', (tester) async {
    final session = AuthSession(
      user: DevSeedAuthRepository.seededUsers.first,
      signedInAt: DateTime(2026, 3, 7, 12),
      tokens: AuthTokenBundle(
        accessToken: 'admin-access',
        refreshToken: 'admin-refresh',
        expiresAt: DateTime(2026, 3, 7, 20),
        sessionId: 'admin-session',
      ),
    );

    await pumpPartyApp(tester, authController: AuthController.test(session: session));

    await tester.tap(find.text('我的').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('管理员控制台'));
    await tester.pumpAndSettle();

    expect(find.text('管理员控制台'), findsWidgets);
    expect(find.text('用户治理'), findsOneWidget);
    expect(find.text('房间治理'), findsOneWidget);
  });
}
