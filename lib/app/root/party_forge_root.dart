import 'dart:async';

import 'package:flutter/material.dart';

import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/application/game_hub_controller.dart';
import '../../features/rooms/application/room_lounge_controller.dart';
import '../../features/settings/application/settings_controller.dart';
import '../localization/app_localizations.dart';
import '../shell/party_forge_shell.dart';
import '../widgets/brand_mark.dart';

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
  bool _showTransition = false;
  bool _lastAuthenticated = false;
  Timer? _transitionTimer;

  @override
  void initState() {
    super.initState();
    _lastAuthenticated = widget.authController.isAuthenticated;
    if (_lastAuthenticated) {
      _triggerTransition();
    }
    widget.authController.addListener(_handleAuthChanged);
  }

  @override
  void dispose() {
    widget.authController.removeListener(_handleAuthChanged);
    _transitionTimer?.cancel();
    super.dispose();
  }

  void _handleAuthChanged() {
    final isAuthenticated = widget.authController.isAuthenticated;
    if (!_lastAuthenticated && isAuthenticated) {
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
    _transitionTimer = Timer(const Duration(milliseconds: 1300), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showTransition = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.authController,
      builder: (context, _) {
        final authenticated = widget.authController.isAuthenticated;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 420),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: authenticated
              ? _showTransition
                  ? const _LaunchTransitionView()
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

class _LaunchTransitionView extends StatefulWidget {
  const _LaunchTransitionView();

  @override
  State<_LaunchTransitionView> createState() => _LaunchTransitionViewState();
}

class _LaunchTransitionViewState extends State<_LaunchTransitionView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.scaffoldBackgroundColor,
              theme.colorScheme.primary.withValues(alpha: 0.16),
              theme.colorScheme.secondary.withValues(alpha: 0.16),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.88, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BrandMark(size: 96),
                  const SizedBox(height: 22),
                  Text(l10n.appTitle, style: theme.textTheme.displaySmall),
                  const SizedBox(height: 8),
                  Text(l10n.launchLoadingBody, style: theme.textTheme.bodyLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
