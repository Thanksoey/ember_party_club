import 'dart:ui';

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
import '../widgets/brand_lockup.dart';

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
  late final PageController _pageController;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pages = <Widget>[
      GameHubPage(controller: widget.gameHubController),
      RoomLoungePage(controller: widget.roomLoungeController),
      ProfilePage(
        authController: widget.authController,
        settingsController: widget.settingsController,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final wideBrand = screenWidth > 760;
    final compactHeader = screenWidth < 440;

    return Scaffold(
      extendBody: true,
      body: AppBackdrop(
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(
                          alpha: theme.brightness == Brightness.dark
                              ? 0.94
                              : 0.97,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.72,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.08,
                            ),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: wideBrand
                                  ? 280
                                  : compactHeader
                                  ? 132
                                  : 168,
                            ),
                            child: BrandLockup(
                              badgeSize: 42,
                              compact: true,
                              caption: wideBrand ? _headerSubtitle(l10n) : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: wideBrand || compactHeader
                                ? const SizedBox.shrink()
                                : AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 220),
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                    child: Text(
                                      _headerSubtitle(l10n),
                                      key: ValueKey(
                                        '${_currentIndex}_$wideBrand',
                                      ),
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.84),
                                            fontWeight: FontWeight.w700,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                          ),
                          if (widget.authController.currentUser
                              case final user?)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AvatarBadge(user: user, size: 40),
                                if (!compactHeader) ...[
                                  const SizedBox(width: 10),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 128,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          user.displayName,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                color:
                                                    theme.colorScheme.onSurface,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (screenWidth > 620)
                                          Text(
                                            user.isAdmin
                                                ? l10n.profileRoleAdmin
                                                : l10n.profileRolePlayer,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.76),
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: _pages,
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
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 340),
                curve: Curves.easeOutCubic,
              );
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
        return l10n.headerSubtitleDiscover;
      case 1:
        return l10n.headerSubtitleRooms;
      case 2:
        return l10n.headerSubtitleProfile;
    }
    return l10n.headerSubtitleDiscover;
  }
}
