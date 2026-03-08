import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/widgets/app_backdrop.dart';
import '../../../../app/widgets/app_fade_in_up.dart';
import '../../../../app/widgets/app_loading_indicator.dart';
import '../../../../app/widgets/brand_lockup.dart';
import '../../application/auth_controller.dart';
import '../../domain/auth_failure.dart';
import 'auth_guide_page.dart';

enum _AuthMode { signIn, register }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.authController});

  final AuthController authController;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _loginUsernameController;
  late final TextEditingController _loginPasswordController;
  late final TextEditingController _registerDisplayNameController;
  late final TextEditingController _registerUsernameController;
  late final TextEditingController _registerPasswordController;
  late final TextEditingController _registerConfirmPasswordController;

  _AuthMode _mode = _AuthMode.signIn;
  bool _obscureLoginPassword = true;
  bool _obscureRegisterPassword = true;
  bool _obscureRegisterConfirmPassword = true;
  String? _registerLocalError;

  @override
  void initState() {
    super.initState();
    _loginUsernameController = TextEditingController(text: 'captain_demo');
    _loginPasswordController = TextEditingController(text: 'Captain#2026!');
    _registerDisplayNameController = TextEditingController();
    _registerUsernameController = TextEditingController();
    _registerPasswordController = TextEditingController();
    _registerConfirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _loginUsernameController.dispose();
    _loginPasswordController.dispose();
    _registerDisplayNameController.dispose();
    _registerUsernameController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final compactHeader = MediaQuery.of(context).size.width < 460;

    return AnimatedBuilder(
      animation: widget.authController,
      builder: (context, _) {
        final authError = _authErrorText(
          l10n,
          widget.authController.loginError,
        );
        final shownError = _mode == _AuthMode.register
            ? (_registerLocalError ?? authError)
            : authError;

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
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 48,
                      ),
                      child: Center(
                        child: AppFadeInUp(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: BrandLockup(
                                            badgeSize: 50,
                                            compact: compactHeader,
                                            caption: compactHeader
                                                ? null
                                                : l10n.loginHeadline,
                                          ),
                                        ),
                                        IconButton(
                                          key: const ValueKey(
                                            'open-auth-guide',
                                          ),
                                          tooltip: l10n.authGuideAction,
                                          icon: const Icon(Icons.info_outline),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute<void>(
                                                builder: (_) =>
                                                    const AuthGuidePage(),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary
                                            .withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: theme.colorScheme.primary
                                              .withValues(alpha: 0.14),
                                        ),
                                      ),
                                      child: Text(
                                        l10n.loginHeadline,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.82),
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      l10n.loginBody,
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 18),
                                    SegmentedButton<_AuthMode>(
                                      segments: [
                                        ButtonSegment(
                                          value: _AuthMode.signIn,
                                          label: Text(l10n.authModeSignIn),
                                          icon: const Icon(
                                            Icons.login_outlined,
                                          ),
                                        ),
                                        ButtonSegment(
                                          value: _AuthMode.register,
                                          label: Text(l10n.authModeRegister),
                                          icon: const Icon(
                                            Icons.person_add_alt_1_outlined,
                                          ),
                                        ),
                                      ],
                                      selected: {_mode},
                                      onSelectionChanged: (value) {
                                        setState(() {
                                          _mode = value.first;
                                          _registerLocalError = null;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 18),
                                    AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 220,
                                      ),
                                      child: _mode == _AuthMode.signIn
                                          ? _SignInForm(
                                              usernameController:
                                                  _loginUsernameController,
                                              passwordController:
                                                  _loginPasswordController,
                                              obscurePassword:
                                                  _obscureLoginPassword,
                                              isSubmitting: widget
                                                  .authController
                                                  .isSubmitting,
                                              onTogglePassword: () {
                                                setState(() {
                                                  _obscureLoginPassword =
                                                      !_obscureLoginPassword;
                                                });
                                              },
                                              onSubmit: () {
                                                widget.authController.login(
                                                  username:
                                                      _loginUsernameController
                                                          .text
                                                          .trim(),
                                                  password:
                                                      _loginPasswordController
                                                          .text,
                                                );
                                              },
                                            )
                                          : _RegisterForm(
                                              displayNameController:
                                                  _registerDisplayNameController,
                                              usernameController:
                                                  _registerUsernameController,
                                              passwordController:
                                                  _registerPasswordController,
                                              confirmPasswordController:
                                                  _registerConfirmPasswordController,
                                              obscurePassword:
                                                  _obscureRegisterPassword,
                                              obscureConfirmPassword:
                                                  _obscureRegisterConfirmPassword,
                                              isSubmitting: widget
                                                  .authController
                                                  .isSubmitting,
                                              onTogglePassword: () {
                                                setState(() {
                                                  _obscureRegisterPassword =
                                                      !_obscureRegisterPassword;
                                                });
                                              },
                                              onToggleConfirmPassword: () {
                                                setState(() {
                                                  _obscureRegisterConfirmPassword =
                                                      !_obscureRegisterConfirmPassword;
                                                });
                                              },
                                              onSubmit: () async {
                                                final password =
                                                    _registerPasswordController
                                                        .text;
                                                if (password !=
                                                    _registerConfirmPasswordController
                                                        .text) {
                                                  setState(() {
                                                    _registerLocalError = l10n
                                                        .registerPasswordMismatch;
                                                  });
                                                  return;
                                                }
                                                setState(() {
                                                  _registerLocalError = null;
                                                });
                                                await widget.authController.register(
                                                  username:
                                                      _registerUsernameController
                                                          .text
                                                          .trim(),
                                                  password: password,
                                                  displayName:
                                                      _registerDisplayNameController
                                                          .text
                                                          .trim(),
                                                );
                                              },
                                            ),
                                    ),
                                    if (shownError != null) ...[
                                      const SizedBox(height: 12),
                                      Text(
                                        shownError,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color:
                                                  theme.colorScheme.secondary,
                                            ),
                                      ),
                                    ],
                                    const SizedBox(height: 8),
                                    TextButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                            builder: (_) =>
                                                const AuthGuidePage(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.menu_book_outlined,
                                      ),
                                      label: Text(l10n.authGuideAction),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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

  String? _authErrorText(AppLocalizations l10n, AuthFailure? failure) {
    switch (failure) {
      case null:
        return null;
      case AuthFailure.invalidCredentials:
        return l10n.loginInvalidCredentials;
      case AuthFailure.usernameTaken:
        return l10n.registerUsernameTaken;
      case AuthFailure.sessionExpired:
        return l10n.loginSessionExpired;
      case AuthFailure.weakPassword:
        return l10n.securityWeakPassword;
      case AuthFailure.unauthorized:
      case AuthFailure.incorrectPassword:
        return l10n.guardLoginBody;
    }
  }
}

class _SignInForm extends StatelessWidget {
  const _SignInForm({
    required this.usernameController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isSubmitting,
    required this.onTogglePassword,
    required this.onSubmit,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isSubmitting;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      key: const ValueKey('sign-in-form'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const ValueKey('login-username'),
          controller: usernameController,
          decoration: InputDecoration(
            labelText: l10n.loginUsernameLabel,
            prefixIcon: const Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          key: const ValueKey('login-password'),
          controller: passwordController,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            labelText: l10n.loginPasswordLabel,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              onPressed: onTogglePassword,
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            key: const ValueKey('login-submit'),
            onPressed: isSubmitting ? null : onSubmit,
            child: isSubmitting
                ? const AppLoadingIndicator(size: 22, strokeWidth: 2.2)
                : Text(l10n.loginAction),
          ),
        ),
      ],
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({
    required this.displayNameController,
    required this.usernameController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.isSubmitting,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onSubmit,
  });

  final TextEditingController displayNameController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isSubmitting;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      key: const ValueKey('register-form'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const ValueKey('register-display-name'),
          controller: displayNameController,
          decoration: InputDecoration(
            labelText: l10n.registerDisplayNameLabel,
            prefixIcon: const Icon(Icons.badge_outlined),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const ValueKey('register-username'),
          controller: usernameController,
          decoration: InputDecoration(
            labelText: l10n.loginUsernameLabel,
            prefixIcon: const Icon(Icons.alternate_email_outlined),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const ValueKey('register-password'),
          controller: passwordController,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            labelText: l10n.loginPasswordLabel,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              onPressed: onTogglePassword,
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const ValueKey('register-confirm-password'),
          controller: confirmPasswordController,
          obscureText: obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: l10n.registerConfirmPasswordLabel,
            prefixIcon: const Icon(Icons.verified_user_outlined),
            suffixIcon: IconButton(
              onPressed: onToggleConfirmPassword,
              icon: Icon(
                obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton.tonal(
            key: const ValueKey('register-submit'),
            onPressed: isSubmitting ? null : onSubmit,
            child: isSubmitting
                ? const AppLoadingIndicator(size: 22, strokeWidth: 2.2)
                : Text(l10n.registerAction),
          ),
        ),
      ],
    );
  }
}
