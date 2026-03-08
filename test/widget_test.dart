import 'package:ember_party_club/app/app.dart';
import 'package:ember_party_club/core/data/game_seed_data.dart';
import 'package:ember_party_club/core/data/room_seed_data.dart';
import 'package:ember_party_club/features/auth/application/auth_controller.dart';
import 'package:ember_party_club/features/auth/data/dev_seed_auth_repository.dart';
import 'package:ember_party_club/features/auth/domain/auth_session.dart';
import 'package:ember_party_club/features/auth/domain/auth_token_bundle.dart';
import 'package:ember_party_club/features/game_session/presentation/widgets/game_session_scaffold.dart';
import 'package:ember_party_club/features/home/application/game_hub_controller.dart';
import 'package:ember_party_club/features/home/presentation/pages/game_hub_page.dart';
import 'package:ember_party_club/features/modules/application/game_module_registry.dart';
import 'package:ember_party_club/features/modules/signal_deck/application/signal_deck_controller.dart';
import 'package:ember_party_club/features/rooms/application/room_lounge_controller.dart';
import 'package:ember_party_club/features/rooms/presentation/pages/room_detail_page.dart';
import 'package:ember_party_club/features/rooms/presentation/pages/room_lounge_page.dart';
import 'package:ember_party_club/features/rooms/presentation/widgets/room_summary_card.dart';
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
    Size physicalSize = const Size(1200, 2400),
  }) async {
    tester.view.physicalSize = physicalSize;
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

  Future<void> pumpAnimatedUi(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
  }

  Finder verticalScrollableIn(Finder ancestor) {
    return find
        .descendant(
          of: ancestor,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Scrollable &&
                widget.axisDirection == AxisDirection.down,
          ),
        )
        .first;
  }

  Future<void> revealInScrollable(
    WidgetTester tester, {
    required Finder target,
    required Finder scrollable,
    double delta = 240,
  }) async {
    await tester.scrollUntilVisible(target, delta, scrollable: scrollable);
    await tester.ensureVisible(target);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
  }

  Future<void> dismissGameGuideIfVisible(WidgetTester tester) async {
    final closeButton = find.byKey(const ValueKey('game-guide-close'));
    if (closeButton.evaluate().isEmpty) {
      return;
    }

    await tester.tap(closeButton);
    await pumpAnimatedUi(tester);
  }

  Future<void> openModule(
    WidgetTester tester,
    String moduleId, {
    Locale locale = const Locale('en'),
    Size physicalSize = const Size(390, 844),
  }) async {
    await pumpPartyApp(tester, locale: locale, physicalSize: physicalSize);

    final button = find.byKey(ValueKey('open-$moduleId'));
    await tester.scrollUntilVisible(
      button,
      260,
      scrollable: verticalScrollableIn(find.byType(GameHubPage)),
    );
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await pumpAnimatedUi(tester);
    await dismissGameGuideIfVisible(tester);
  }

  Future<void> createRoomAndOpenGame(
    WidgetTester tester, {
    required String moduleName,
    Locale locale = const Locale('en'),
    Size physicalSize = const Size(390, 844),
  }) async {
    await pumpPartyApp(tester, locale: locale, physicalSize: physicalSize);

    await tester.tap(find.text('Rooms').last);
    await tester.pumpAndSettle();
    final createRoomButton = find.byKey(const ValueKey('open-create-room'));
    await tester.scrollUntilVisible(
      createRoomButton,
      220,
      scrollable: verticalScrollableIn(find.byType(RoomLoungePage)),
    );
    await tester.ensureVisible(createRoomButton);
    await tester.pumpAndSettle();
    await tester.tap(createRoomButton);
    await tester.pumpAndSettle();

    final moduleField = find.byWidgetPredicate(
      (widget) =>
          widget.key is ValueKey<String> &&
          (widget.key as ValueKey<String>).value.startsWith(
            'room-module-field-',
          ),
    );
    await tester.ensureVisible(moduleField);
    await tester.tap(moduleField);
    await tester.pumpAndSettle();
    await tester.tap(find.text(moduleName).last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('submit-create-room')));
    await tester.pump();
    await tester.pumpAndSettle();

    if (find.byType(RoomDetailPage).evaluate().isEmpty) {
      final roomCard = find.byType(RoomSummaryCard).first;
      await tester.ensureVisible(roomCard);
      await tester.tap(roomCard);
      await tester.pumpAndSettle();
    }
    final startButton = find.byKey(const ValueKey('start-room-game'));
    await revealInScrollable(
      tester,
      target: startButton,
      scrollable: verticalScrollableIn(find.byType(RoomDetailPage)),
    );
    await tester.tap(startButton);
    await pumpAnimatedUi(tester);
    await dismissGameGuideIfVisible(tester);
  }

  testWidgets('shows login page and can sign in', (tester) async {
    await pumpPartyApp(
      tester,
      authController: AuthController.unauthenticatedTest(),
    );

    expect(find.text('登录后加入今晚的派对局'), findsWidgets);
    await tester.tap(find.byKey(const ValueKey('login-submit')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle(const Duration(milliseconds: 1600));

    expect(find.text('余烬派对社'), findsWidgets);
    expect(find.text('我的'), findsWidgets);
  });

  testWidgets('renders discover and rooms shell content in Chinese', (
    tester,
  ) async {
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
    await pumpAnimatedUi(tester);
    await dismissGameGuideIfVisible(tester);

    expect(find.text('信号牌局'), findsOneWidget);
    expect(find.text('你的手牌'), findsOneWidget);
    expect(find.text('出牌'), findsWidgets);
  });

  testWidgets(
    'creates a Signal Deck room and advances room session phase from room flow',
    (tester) async {
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
      await pumpAnimatedUi(tester);
      await dismissGameGuideIfVisible(tester);

      expect(find.text('房间会话'), findsOneWidget);
      expect(find.text('准备阶段'), findsOneWidget);
      expect(find.textContaining('已绑定房间'), findsOneWidget);

      final playButton = find
          .byWidgetPredicate(
            (widget) =>
                widget is FilledButton &&
                widget.key is ValueKey<String> &&
                (widget.key as ValueKey<String>).value.startsWith(
                  'signal-play-',
                ),
          )
          .hitTestable();
      await tester.tap(playButton.first);
      await pumpAnimatedUi(tester);

      expect(find.text('对局进行中'), findsOneWidget);
      expect(find.text('你的手牌'), findsOneWidget);
    },
  );

  testWidgets('can switch theme and locale from profile settings', (
    tester,
  ) async {
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

  testWidgets('can edit profile and reflect changes in shell header', (
    tester,
  ) async {
    await pumpPartyApp(tester);

    await tester.tap(find.text('我的').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('编辑资料'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('profile-display-name')),
      '星舰队长',
    );
    await tester.enterText(
      find.byKey(const ValueKey('profile-bio')),
      '负责好友局的首轮试玩。',
    );
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

    await pumpPartyApp(
      tester,
      authController: AuthController.test(session: session),
    );

    await tester.tap(find.text('我的').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('管理员控制台'));
    await tester.pumpAndSettle();

    expect(find.text('管理员控制台'), findsWidgets);
    expect(find.text('用户治理'), findsOneWidget);
    expect(find.text('房间治理'), findsOneWidget);
  });
  testWidgets('walks through Midnight Vote on mobile viewport', (tester) async {
    await openModule(tester, 'midnight-vote');

    expect(find.text('Midnight Vote'), findsOneWidget);
    final voteButton = find.byKey(const ValueKey('midnight-lock-vote'));
    await revealInScrollable(
      tester,
      target: voteButton,
      scrollable: verticalScrollableIn(find.byType(GameSessionScaffold)),
    );
    await tester.tap(voteButton);
    await pumpAnimatedUi(tester);

    expect(find.text('Investigation Timeline'), findsOneWidget);
  });

  testWidgets('walks through Signal Deck on mobile viewport', (tester) async {
    await openModule(tester, 'signal-deck');

    expect(find.text('Signal Deck'), findsOneWidget);
    final topCardId = SignalDeckController().state.player.hand.last.id;
    final playButton = find.byKey(ValueKey('signal-play-$topCardId'));
    await revealInScrollable(
      tester,
      target: playButton,
      scrollable: verticalScrollableIn(find.byType(GameSessionScaffold)),
    );
    await tester.tap(playButton);
    await pumpAnimatedUi(tester);

    expect(find.text('Round log'), findsOneWidget);
  });

  testWidgets('walks through Orbit Merchant on mobile viewport', (
    tester,
  ) async {
    await openModule(tester, 'orbit-merchant');

    expect(find.text('Orbit Merchant'), findsOneWidget);
    final buyButton = find.byKey(const ValueKey('orbit-buy'));
    await revealInScrollable(
      tester,
      target: buyButton,
      scrollable: verticalScrollableIn(find.byType(GameSessionScaffold)),
    );
    await tester.tap(buyButton);
    await pumpAnimatedUi(tester);

    expect(find.text('Trade Timeline'), findsOneWidget);
  });

  testWidgets('walks through Chaos Mixer on mobile viewport', (tester) async {
    await openModule(tester, 'chaos-mixer');

    expect(find.text('Chaos Mixer'), findsOneWidget);
    final successButton = find.byKey(const ValueKey('chaos-success'));
    await revealInScrollable(
      tester,
      target: successButton,
      scrollable: verticalScrollableIn(find.byType(GameSessionScaffold)),
    );
    await tester.tap(successButton);
    await pumpAnimatedUi(tester);

    expect(find.textContaining('Round 2'), findsOneWidget);
  });

  testWidgets('starts Midnight Vote from room flow on mobile viewport', (
    tester,
  ) async {
    await createRoomAndOpenGame(tester, moduleName: 'Midnight Vote');

    expect(find.text('Room session'), findsOneWidget);
    final voteButton = find.byKey(const ValueKey('midnight-lock-vote'));
    await revealInScrollable(
      tester,
      target: voteButton,
      scrollable: verticalScrollableIn(find.byType(GameSessionScaffold)),
    );
    await tester.tap(voteButton);
    await pumpAnimatedUi(tester);

    expect(find.text('Investigation Timeline'), findsOneWidget);
  });

  testWidgets('starts Orbit Merchant from room flow on mobile viewport', (
    tester,
  ) async {
    await createRoomAndOpenGame(tester, moduleName: 'Orbit Merchant');

    expect(find.text('Room session'), findsOneWidget);
    final buyButton = find.byKey(const ValueKey('orbit-buy'));
    await revealInScrollable(
      tester,
      target: buyButton,
      scrollable: verticalScrollableIn(find.byType(GameSessionScaffold)),
    );
    await tester.tap(buyButton);
    await pumpAnimatedUi(tester);

    expect(find.text('Trade Timeline'), findsOneWidget);
  });

  testWidgets('starts Chaos Mixer from room flow on mobile viewport', (
    tester,
  ) async {
    await createRoomAndOpenGame(tester, moduleName: 'Chaos Mixer');

    expect(find.text('Room session'), findsOneWidget);
    final successButton = find.byKey(const ValueKey('chaos-success'));
    await revealInScrollable(
      tester,
      target: successButton,
      scrollable: verticalScrollableIn(find.byType(GameSessionScaffold)),
    );
    await tester.tap(successButton);
    await pumpAnimatedUi(tester);

    expect(find.textContaining('Success, +'), findsOneWidget);
  });
}
