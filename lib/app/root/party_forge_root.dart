import 'dart:async';

import 'package:flutter/material.dart';

import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/application/game_hub_controller.dart';
import '../../features/rooms/application/room_lounge_controller.dart';
import '../../features/settings/application/settings_controller.dart';
import '../localization/app_localizations.dart';
import '../shell/party_forge_shell.dart';
import '../widgets/app_startup_stage.dart';
import '../widgets/party_launch_stage.dart';

class PartyForgeRoot extends StatefulWidget {
  const PartyForgeRoot({
    super.key,
    required this.authController,
    required this.settingsController,
    required this.gameHubController,
    required this.roomLoungeController,
  });

  final AuthController authController;
  final SettingsController settingsController;
  final GameHubController gameHubController;
  final RoomLoungeController roomLoungeController;

  @override
  State<PartyForgeRoot> createState() => _PartyForgeRootState();
}

class _PartyForgeRootState extends State<PartyForgeRoot> {
  static const Duration _startupStageDuration = Duration(milliseconds: 2200);
  static const Duration _startupExitDelay = Duration(milliseconds: 280);
  static const Duration _entryStageDuration = Duration(milliseconds: 1650);
  static const Duration _entryExitDelay = Duration(milliseconds: 180);

  bool _showStartupIntro = true;
  bool _showTransition = false;
  bool _lastAuthenticated = false;
  Timer? _startupTimer;
  Timer? _transitionTimer;

  @override
  void initState() {
    super.initState();
    _lastAuthenticated = widget.authController.isAuthenticated;
    _scheduleStartupIntro();
    widget.authController.addListener(_handleAuthChanged);
  }

  @override
  void dispose() {
    widget.authController.removeListener(_handleAuthChanged);
    _startupTimer?.cancel();
    _transitionTimer?.cancel();
    super.dispose();
  }

  void _scheduleStartupIntro() {
    _startupTimer?.cancel();
    _startupTimer = Timer(_startupStageDuration + _startupExitDelay, () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showStartupIntro = false;
      });
    });
  }

  void _handleAuthChanged() {
    final isAuthenticated = widget.authController.isAuthenticated;
    if (!_lastAuthenticated && isAuthenticated && !_showStartupIntro) {
      _triggerTransition();
    }
    if (!isAuthenticated) {
      _transitionTimer?.cancel();
      if (_showTransition) {
        setState(() {
          _showTransition = false;
        });
      }
    }
    _lastAuthenticated = isAuthenticated;
  }

  void _triggerTransition() {
    _transitionTimer?.cancel();
    setState(() {
      _showTransition = true;
    });
    _transitionTimer = Timer(_entryStageDuration + _entryExitDelay, () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showTransition = false;
      });
    });
  }

  String _localizedText(
    BuildContext context, {
    required String zh,
    required String en,
  }) {
    return Localizations.localeOf(context).languageCode == 'en' ? en : zh;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.authController,
      builder: (context, _) {
        final l10n = context.l10n;
        final authenticated = widget.authController.isAuthenticated;
        final openingOverline = _localizedText(
          context,
          zh: '余烬派对社',
          en: 'EMBER PARTY CLUB',
        );
        final openingCaption = _localizedText(
          context,
          zh: '余烬与灯光正在点亮今夜会所舞池。',
          en: 'Ember light is warming up tonight\'s party floor.',
        );
        final openingStatus = _localizedText(
          context,
          zh: '正在校准房间、玩法模块与现场节奏',
          en: 'Preparing rooms, modules and ambiance cadence',
        );
        final openingDetails = _localizedText(
          context,
          zh: '徽记、房间中枢与开场灯效已就位。',
          en: 'Syncing badge, room hub and opening lights.',
        );
        final entryOverline = _localizedText(
          context,
          zh: '会员入场通道',
          en: 'MEMBERS ROOM ACCESS',
        );
        final entryTitle = _localizedText(
          context,
          zh: '入场门已开启',
          en: 'Doors Are Open',
        );
        final entryCaption = _localizedText(
          context,
          zh: '正在同步座位、房间与会话状态，马上带你入场。',
          en: 'Linking seats, rooms and session state before you step in.',
        );
        final entryStatus = _localizedText(
          context,
          zh: '私人房间即将开放',
          en: 'Private room opening',
        );
        final entryDetails = _localizedText(
          context,
          zh: '门禁、席位与派对流程已完成联动。',
          en: 'Access, seats and party flow are now aligned.',
        );

        if (_showStartupIntro) {
          return AppStartupStage(
            key: const ValueKey('startup-intro'),
            overline: openingOverline,
            title: l10n.appTitle,
            caption: openingCaption,
            statusLabel: openingStatus,
            detailsLabel: openingDetails,
            stageDuration: _startupStageDuration,
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final fade = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            final offset = Tween<Offset>(
              begin: const Offset(0, 0.02),
              end: Offset.zero,
            ).animate(fade);
            final scale = Tween<double>(begin: 0.99, end: 1.0).animate(fade);
            return FadeTransition(
              opacity: fade,
              child: SlideTransition(
                position: offset,
                child: ScaleTransition(scale: scale, child: child),
              ),
            );
          },
          child: authenticated
              ? _showTransition
                    ? PartyLaunchStage(
                        key: const ValueKey('launch-transition'),
                        variant: PartyLaunchStageVariant.entry,
                        overline: entryOverline,
                        title: entryTitle,
                        caption: entryCaption,
                        statusLabel: entryStatus,
                        detailsLabel: entryDetails,
                        stageDuration: _entryStageDuration,
                      )
                    : PartyForgeShell(
                        key: const ValueKey('app-shell'),
                        authController: widget.authController,
                        settingsController: widget.settingsController,
                        gameHubController: widget.gameHubController,
                        roomLoungeController: widget.roomLoungeController,
                      )
              : LoginPage(
                  key: const ValueKey('login-page'),
                  authController: widget.authController,
                ),
        );
      },
    );
  }
}
