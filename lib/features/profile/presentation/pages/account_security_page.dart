import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/widgets/app_backdrop.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../auth/domain/auth_failure.dart';
import '../../../auth/presentation/widgets/auth_gate.dart';

class AccountSecurityPage extends StatefulWidget {
  const AccountSecurityPage({
    super.key,
    required this.authController,
  });

  final AuthController authController;

  @override
  State<AccountSecurityPage> createState() => _AccountSecurityPageState();
}

class _AccountSecurityPageState extends State<AccountSecurityPage> {
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _nextPasswordController;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _nextPasswordController = TextEditingController();
    widget.authController.refreshSecuritySnapshot();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _nextPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.authController,
      builder: (context, _) {
        final theme = Theme.of(context);
        final l10n = context.l10n;
        final session = widget.authController.currentSession;

        return AuthGate(
          authController: widget.authController,
          child: Scaffold(
            appBar: AppBar(title: Text(l10n.securityTitle)),
            body: AppBackdrop(
              primaryAlignment: const Alignment(0.8, -0.8),
              secondaryAlignment: const Alignment(-0.8, 0.9),
              child: SafeArea(
                top: false,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.securitySessionCardTitle, style: theme.textTheme.headlineSmall),
                            const SizedBox(height: 8),
                            Text(l10n.securityBody, style: theme.textTheme.bodyLarge),
                            const SizedBox(height: 16),
                            _SecurityInfoRow(
                              label: l10n.securitySessionId,
                              value: session?.tokens.sessionId ?? '--',
                            ),
                            _SecurityInfoRow(
                              label: l10n.securitySessionExpiry,
                              value: session == null
                                  ? '--'
                                  : l10n.shortDateTime(session.tokens.expiresAt.year, session.tokens.expiresAt.month, session.tokens.expiresAt.day, session.tokens.expiresAt.hour, session.tokens.expiresAt.minute),
                            ),
                            _SecurityInfoRow(
                              label: l10n.securityStorageMode,
                              value: l10n.securityStorageModeValue,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.securityPasswordTitle, style: theme.textTheme.headlineSmall),
                            const SizedBox(height: 8),
                            Text(l10n.securityPasswordBody, style: theme.textTheme.bodyLarge),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _currentPasswordController,
                              decoration: InputDecoration(labelText: l10n.securityCurrentPassword),
                              obscureText: true,
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: _nextPasswordController,
                              decoration: InputDecoration(labelText: l10n.securityNextPassword),
                              obscureText: true,
                            ),
                            if (widget.authController.securityError != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                _securityErrorText(l10n, widget.authController.securityError!),
                                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.secondary),
                              ),
                            ],
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                key: const ValueKey('change-password'),
                                onPressed: widget.authController.isSecurityBusy
                                    ? null
                                    : () async {
                                        final success = await widget.authController.changePassword(
                                          currentPassword: _currentPasswordController.text,
                                          nextPassword: _nextPasswordController.text,
                                        );
                                        if (!context.mounted || !success) {
                                          return;
                                        }
                                        _currentPasswordController.clear();
                                        _nextPasswordController.clear();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(l10n.securityPasswordUpdated)),
                                        );
                                      },
                                child: Text(l10n.securityPasswordAction),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(l10n.securityDevicesTitle, style: theme.textTheme.headlineSmall),
                                ),
                                IconButton(
                                  onPressed: widget.authController.isSecurityBusy
                                      ? null
                                      : widget.authController.refreshSecuritySnapshot,
                                  icon: const Icon(Icons.refresh_outlined),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(l10n.securityDevicesBody, style: theme.textTheme.bodyLarge),
                            const SizedBox(height: 16),
                            for (final device in widget.authController.deviceSessions)
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                                  foregroundColor: theme.colorScheme.primary,
                                  child: Icon(device.isCurrent ? Icons.laptop_chromebook_outlined : Icons.devices_outlined),
                                ),
                                title: Text(device.deviceName),
                                subtitle: Text(
                                  '${device.platformLabel} · ${l10n.shortDateTime(device.lastActiveAt.year, device.lastActiveAt.month, device.lastActiveAt.day, device.lastActiveAt.hour, device.lastActiveAt.minute)}',
                                ),
                                trailing: device.isCurrent
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.tertiary.withValues(alpha: 0.14),
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: Text(
                                          l10n.securityCurrentDevice,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.tertiary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      )
                                    : TextButton(
                                        onPressed: widget.authController.isSecurityBusy
                                            ? null
                                            : () => widget.authController.signOutDevice(device.id),
                                        child: Text(l10n.securitySignOutDevice),
                                      ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _securityErrorText(AppLocalizations l10n, AuthFailure failure) {
    switch (failure) {
      case AuthFailure.incorrectPassword:
        return l10n.securityIncorrectPassword;
      case AuthFailure.weakPassword:
        return l10n.securityWeakPassword;
      case AuthFailure.invalidCredentials:
      case AuthFailure.sessionExpired:
      case AuthFailure.unauthorized:
        return l10n.guardLoginBody;
    }
  }
}

class _SecurityInfoRow extends StatelessWidget {
  const _SecurityInfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
