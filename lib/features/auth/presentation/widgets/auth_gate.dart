import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../application/auth_controller.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
    required this.authController,
    required this.child,
    this.requireAdmin = false,
  });

  final AuthController authController;
  final Widget child;
  final bool requireAdmin;

  @override
  Widget build(BuildContext context) {
    final user = authController.currentUser;
    if (user == null) {
      return _BlockedState(
        icon: Icons.lock_outline,
        title: context.l10n.guardLoginTitle,
        body: context.l10n.guardLoginBody,
      );
    }
    if (requireAdmin && !user.isAdmin) {
      return _BlockedState(
        icon: Icons.admin_panel_settings_outlined,
        title: context.l10n.guardAdminTitle,
        body: context.l10n.guardAdminBody,
      );
    }
    return child;
  }
}

class _BlockedState extends StatelessWidget {
  const _BlockedState({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 40, color: theme.colorScheme.secondary),
                  const SizedBox(height: 14),
                  Text(title, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(body, style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
