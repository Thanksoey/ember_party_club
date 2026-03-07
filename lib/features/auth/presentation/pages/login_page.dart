import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/widgets/app_backdrop.dart';
import '../../../../app/widgets/brand_mark.dart';
import '../../application/auth_controller.dart';
import '../../domain/auth_failure.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.authController,
  });

  final AuthController authController;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: 'captain_demo');
    _passwordController = TextEditingController(text: 'Captain#2026!');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return AnimatedBuilder(
      animation: widget.authController,
      builder: (context, _) {
        final error = _errorText(l10n, widget.authController.loginError);

        return Scaffold(
          body: AppBackdrop(
            primaryAlignment: const Alignment(-1, -0.8),
            secondaryAlignment: const Alignment(1, 0.8),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1080),
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              SizedBox(
                                width: 460,
                                child: _HeroPanel(
                                  onFillDemo: () => _fillAccount('captain_demo', 'Captain#2026!'),
                                  onFillAdmin: () => _fillAccount('ember_admin', 'Ember#2026!'),
                                ),
                              ),
                              SizedBox(
                                width: 460,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(l10n.loginHeadline, style: theme.textTheme.displaySmall),
                                        const SizedBox(height: 10),
                                        Text(l10n.loginBody, style: theme.textTheme.bodyLarge),
                                        const SizedBox(height: 22),
                                        TextField(
                                          key: const ValueKey('login-username'),
                                          controller: _usernameController,
                                          decoration: InputDecoration(
                                            labelText: l10n.loginUsernameLabel,
                                            prefixIcon: const Icon(Icons.person_outline),
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        TextField(
                                          key: const ValueKey('login-password'),
                                          controller: _passwordController,
                                          obscureText: _obscurePassword,
                                          decoration: InputDecoration(
                                            labelText: l10n.loginPasswordLabel,
                                            prefixIcon: const Icon(Icons.lock_outline),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _obscurePassword = !_obscurePassword;
                                                });
                                              },
                                              icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                            ),
                                          ),
                                        ),
                                        if (error != null) ...[
                                          const SizedBox(height: 12),
                                          Text(
                                            error,
                                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.secondary),
                                          ),
                                        ],
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: double.infinity,
                                          child: FilledButton(
                                            key: const ValueKey('login-submit'),
                                            onPressed: widget.authController.isSubmitting
                                                ? null
                                                : () {
                                                    widget.authController.login(
                                                      username: _usernameController.text.trim(),
                                                      password: _passwordController.text,
                                                    );
                                                  },
                                            child: widget.authController.isSubmitting
                                                ? const SizedBox(
                                                    width: 22,
                                                    height: 22,
                                                    child: CircularProgressIndicator(strokeWidth: 2),
                                                  )
                                                : Text(l10n.loginAction),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _QuickSeedButton(
                                                label: l10n.loginFillDemo,
                                                onTap: () => _fillAccount('captain_demo', 'Captain#2026!'),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: _QuickSeedButton(
                                                label: l10n.loginFillAdmin,
                                                onTap: () => _fillAccount('ember_admin', 'Ember#2026!'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.secondary.withValues(alpha: 0.08),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(l10n.loginDemoHint, style: theme.textTheme.bodyMedium),
                                        ),
                                      ],
                                    ),
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
              ),
            ),
          ),
        );
      },
    );
  }

  void _fillAccount(String username, String password) {
    _usernameController.text = username;
    _passwordController.text = password;
  }

  String? _errorText(AppLocalizations l10n, AuthFailure? failure) {
    switch (failure) {
      case null:
        return null;
      case AuthFailure.invalidCredentials:
        return l10n.loginInvalidCredentials;
      case AuthFailure.sessionExpired:
        return l10n.loginSessionExpired;
      case AuthFailure.unauthorized:
      case AuthFailure.weakPassword:
      case AuthFailure.incorrectPassword:
        return l10n.guardLoginBody;
    }
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.onFillDemo,
    required this.onFillAdmin,
  });

  final VoidCallback onFillDemo;
  final VoidCallback onFillAdmin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
              theme.colorScheme.tertiary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BrandMark(size: 88, showWordmark: true),
            const SizedBox(height: 28),
            Text(
              l10n.loginHeroTitle,
              style: theme.textTheme.displaySmall?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.loginHeroBody,
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.92)),
            ),
            const SizedBox(height: 20),
            _SeedAccountCard(
              title: l10n.loginSeedPlayerTitle,
              subtitle: 'captain_demo',
              onTap: onFillDemo,
            ),
            const SizedBox(height: 12),
            _SeedAccountCard(
              title: l10n.loginSeedAdminTitle,
              subtitle: 'ember_admin',
              onTap: onFillAdmin,
            ),
          ],
        ),
      ),
    );
  }
}

class _SeedAccountCard extends StatelessWidget {
  const _SeedAccountCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.vpn_key_outlined, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.88))),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _QuickSeedButton extends StatelessWidget {
  const _QuickSeedButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      child: Text(label),
    );
  }
}
