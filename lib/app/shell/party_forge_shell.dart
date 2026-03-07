import 'package:flutter/material.dart';

import '../../app/localization/app_localizations.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../features/home/application/game_hub_controller.dart';
import '../../features/home/presentation/pages/game_hub_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/rooms/application/room_lounge_controller.dart';
import '../../features/rooms/presentation/pages/room_lounge_page.dart';
import '../../features/settings/application/settings_controller.dart';
import '../widgets/app_backdrop.dart';
import '../widgets/avatar_badge.dart';
import '../widgets/brand_mark.dart';

class PartyForgeShell extends StatefulWidget {
  const PartyForgeShell({
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
  State<PartyForgeShell> createState() => _PartyForgeShellState();
}

class _PartyForgeShellState extends State<PartyForgeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final pages = <Widget>[
      GameHubPage(controller: widget.gameHubController),
      RoomLoungePage(controller: widget.roomLoungeController),
      ProfilePage(
        authController: widget.authController,
        settingsController: widget.settingsController,
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: AppBackdrop(
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      const BrandMark(size: 42),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.appTitle, style: theme.textTheme.titleLarge),
                            Text(
                              _headerSubtitle(l10n),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      if (widget.authController.currentUser case final user?)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AvatarBadge(user: user, size: 40),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(user.displayName, style: theme.textTheme.titleMedium),
                                Text(
                                  user.isAdmin ? l10n.profileRoleAdmin : l10n.profileRolePlayer,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: pages,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.explore_outlined),
                selectedIcon: const Icon(Icons.explore),
                label: l10n.discoverTab,
              ),
              NavigationDestination(
                icon: const Icon(Icons.meeting_room_outlined),
                selectedIcon: const Icon(Icons.meeting_room),
                label: l10n.roomsTab,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: l10n.profileTab,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _headerSubtitle(AppLocalizations l10n) {
    switch (_currentIndex) {
      case 0:
        return l10n.homeHeroBody;
      case 1:
        return l10n.roomLoungeBody;
      case 2:
        return l10n.profileBody;
    }
    return l10n.homeHeroBody;
  }
}
