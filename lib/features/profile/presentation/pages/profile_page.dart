import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/widgets/app_backdrop.dart';
import '../../../../app/widgets/app_fade_in_up.dart';
import '../../../../app/widgets/avatar_badge.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../auth/domain/app_user.dart';
import '../../../settings/application/settings_controller.dart';
import 'account_security_page.dart';
import 'admin_console_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.authController,
    required this.settingsController,
  });

  final AuthController authController;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([authController, settingsController]),
      builder: (context, _) {
        final theme = Theme.of(context);
        final l10n = context.l10n;
        final user = authController.currentUser;

        return Scaffold(
          body: AppBackdrop(
            primaryAlignment: const Alignment(1, -0.9),
            secondaryAlignment: const Alignment(-0.8, 0.9),
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                children: [
                  AppFadeInUp(
                    child: Text(
                      l10n.profileTitle,
                      style: theme.textTheme.displaySmall,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppFadeInUp(
                    order: 1,
                    child: Text(
                      l10n.profileBody,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (user != null)
                    AppFadeInUp(
                      order: 2,
                      child: _ProfileHero(
                        user: user,
                        authController: authController,
                      ),
                    ),
                  const SizedBox(height: 18),
                  AppFadeInUp(
                    order: 3,
                    child: _SettingsPanel(
                      settingsController: settingsController,
                    ),
                  ),
                  const SizedBox(height: 18),
                  AppFadeInUp(
                    order: 4,
                    child: _ActionPanel(
                      authController: authController,
                      onEditProfile: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              EditProfilePage(authController: authController),
                        ),
                      ),
                      onSecurity: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => AccountSecurityPage(
                            authController: authController,
                          ),
                        ),
                      ),
                      onAdmin: authController.canAccessAdmin
                          ? () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => AdminConsolePage(
                                  authController: authController,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 18),
                  AppFadeInUp(
                    order: 5,
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        key: const ValueKey('logout-action'),
                        onPressed: user == null ? null : authController.logout,
                        icon: const Icon(Icons.logout_outlined),
                        label: Text(l10n.logoutAction),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.user, required this.authController});

  final AppUser user;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final session = authController.currentSession;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.92),
              theme.colorScheme.tertiary.withValues(alpha: 0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvatarBadge(user: user, size: 78),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '@${user.username} / ${user.uid}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onPrimary.withValues(
                            alpha: 0.88,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _HeroPill(
                            label: user.isAdmin
                                ? l10n.profileRoleAdmin
                                : l10n.profileRolePlayer,
                          ),
                          _HeroPill(label: l10n.profileLevel(user.level)),
                          _HeroPill(
                            label: l10n.authProviderLabel(user.provider),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              user.bio,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    label: l10n.profileSignedInAt,
                    value: session == null
                        ? '--'
                        : l10n.shortDateTime(
                            session.signedInAt.year,
                            session.signedInAt.month,
                            session.signedInAt.day,
                            session.signedInAt.hour,
                            session.signedInAt.minute,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricTile(
                    label: l10n.profileSessionExpiry,
                    value: session == null
                        ? '--'
                        : l10n.shortDateTime(
                            session.tokens.expiresAt.year,
                            session.tokens.expiresAt.month,
                            session.tokens.expiresAt.day,
                            session.tokens.expiresAt.hour,
                            session.tokens.expiresAt.minute,
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onPrimary = theme.colorScheme.onPrimary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: onPrimary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: onPrimary.withValues(alpha: 0.72),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(color: onPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onPrimary = theme.colorScheme.onPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: onPrimary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: onPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({required this.settingsController});

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.settingsTitle, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(l10n.settingsBody, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 18),
            Text(l10n.themeTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(l10n.themeSystem),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(l10n.themeLight),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(l10n.themeDark),
                ),
              ],
              selected: {settingsController.themeMode},
              onSelectionChanged: (selection) {
                settingsController.updateThemeMode(selection.first);
              },
            ),
            const SizedBox(height: 18),
            Text(l10n.localeTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            SegmentedButton<AppLocaleMode>(
              segments: [
                ButtonSegment(
                  value: AppLocaleMode.system,
                  label: Text(l10n.localeModeSystem),
                ),
                ButtonSegment(
                  value: AppLocaleMode.chinese,
                  label: Text(l10n.localeModeChinese),
                ),
                ButtonSegment(
                  value: AppLocaleMode.english,
                  label: Text(l10n.localeModeEnglish),
                ),
              ],
              selected: {settingsController.localeMode},
              onSelectionChanged: (selection) {
                settingsController.updateLocaleMode(selection.first);
              },
            ),
            const SizedBox(height: 18),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.language_outlined),
              title: Text(l10n.localeTitle),
              subtitle: Text(
                l10n.localeModeDescriptionValue(settingsController.localeMode),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.brightness_6_outlined),
              title: Text(l10n.themeTitle),
              subtitle: Text(
                l10n.themeModeDescriptionValue(settingsController.themeMode),
              ),
            ),
            const SizedBox(height: 8),
            Text(l10n.feedbackTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.volume_up_outlined),
              title: Text(l10n.feedbackSoundEffects),
              subtitle: Text(
                settingsController.soundEffectsEnabled
                    ? l10n.feedbackOn
                    : l10n.feedbackOff,
              ),
              value: settingsController.soundEffectsEnabled,
              onChanged: settingsController.updateSoundEffectsEnabled,
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.vibration_outlined),
              title: Text(l10n.feedbackHaptics),
              subtitle: Text(
                settingsController.hapticsEnabled
                    ? l10n.feedbackOn
                    : l10n.feedbackOff,
              ),
              value: settingsController.hapticsEnabled,
              onChanged: settingsController.updateHapticsEnabled,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionPanel extends StatelessWidget {
  const _ActionPanel({
    required this.authController,
    required this.onEditProfile,
    required this.onSecurity,
    this.onAdmin,
  });

  final AuthController authController;
  final VoidCallback onEditProfile;
  final VoidCallback onSecurity;
  final VoidCallback? onAdmin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _ActionTile(
              icon: Icons.edit_outlined,
              title: l10n.profileEditTitle,
              subtitle: l10n.profileEditBody,
              onTap: onEditProfile,
            ),
            _ActionTile(
              icon: Icons.lock_person_outlined,
              title: l10n.securityTitle,
              subtitle: l10n.securityBody,
              onTap: onSecurity,
            ),
            if (onAdmin != null)
              _ActionTile(
                icon: Icons.admin_panel_settings_outlined,
                title: l10n.adminConsoleTitle,
                subtitle: l10n.adminConsoleBody,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.profileRoleAdmin,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                onTap: onAdmin!,
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        foregroundColor: theme.colorScheme.primary,
        child: Icon(icon),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: theme.textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
