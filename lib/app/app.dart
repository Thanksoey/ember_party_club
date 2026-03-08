import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/data/game_seed_data.dart';
import '../core/data/room_seed_data.dart';
import '../core/storage/app_preference_store_factory.dart';
import '../features/auth/application/auth_controller.dart';
import '../features/auth/data/remote/mock_auth_api_client.dart';
import '../features/auth/data/remote/remote_auth_repository.dart';
import '../features/home/application/game_hub_controller.dart';
import '../features/modules/application/game_module_registry.dart';
import '../features/rooms/application/room_lounge_controller.dart';
import '../features/settings/application/settings_controller.dart';
import 'localization/app_localizations.dart';
import 'root/party_forge_root.dart';
import 'services/app_feedback.dart';
import 'theme/app_theme.dart';

class PartyForgeApp extends StatelessWidget {
  const PartyForgeApp({
    super.key,
    required this.gameHubController,
    required this.roomLoungeController,
    required this.authController,
    required this.settingsController,
    this.locale,
  });

  final GameHubController gameHubController;
  final RoomLoungeController roomLoungeController;
  final AuthController authController;
  final SettingsController settingsController;
  final Locale? locale;

  static Future<void> bootstrap() async {
    WidgetsFlutterBinding.ensureInitialized();
    final store = createPreferenceStore();
    final authController = await AuthController.bootstrap(
      RemoteAuthRepository(client: MockAuthApiClient(), store: store),
    );
    final settingsController = await SettingsController.bootstrap(store);
    final registry = GameModuleRegistry.seeded(GameSeedData.modules);
    final gameHubController = GameHubController(registry: registry);
    final roomLoungeController = RoomLoungeController.seeded(
      rooms: RoomSeedData.rooms,
      registry: registry,
    );

    runApp(
      PartyForgeApp(
        gameHubController: gameHubController,
        roomLoungeController: roomLoungeController,
        authController: authController,
        settingsController: settingsController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (context, _) {
        AppFeedback.instance.configure(
          soundEnabled: settingsController.soundEffectsEnabled,
          hapticsEnabled: settingsController.hapticsEnabled,
        );
        return MaterialApp(
          onGenerateTitle: (context) => context.l10n.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: settingsController.themeMode,
          locale: locale ?? settingsController.localeOverride,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale == null) {
              return const Locale('zh');
            }
            for (final supported in supportedLocales) {
              if (supported.languageCode == locale.languageCode) {
                return supported;
              }
            }
            return const Locale('zh');
          },
          home: PartyForgeRoot(
            authController: authController,
            settingsController: settingsController,
            gameHubController: gameHubController,
            roomLoungeController: roomLoungeController,
          ),
        );
      },
    );
  }
}
