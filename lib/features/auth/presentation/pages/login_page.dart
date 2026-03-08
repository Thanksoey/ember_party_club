import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/widgets/app_backdrop.dart';
import '../../../../app/widgets/app_fade_in_up.dart';
import '../../../../app/widgets/app_loading_indicator.dart';
import '../../../../app/widgets/app_ornate_card.dart';
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
  double _signInFormHeight = 0;
  double _registerFormHeight = 0;

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
        final reservedFormHeight = _computedReservedFormHeight;

        return Scaffold(
          body: AppBackdrop(
            primaryAlignment: const Alignment(-1, -0.8),
            secondaryAlignment: const Alignment(1, 0.8),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 54,
                      ),
                      child: Center(
                        child: AppFadeInUp(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520),
                            child: AppOrnateCard(
                              accentColor: theme.colorScheme.secondary,
                              highlightColor: theme.colorScheme.tertiary,
                              aura: AppOrnateCardAura.noir,
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BrandLockup(
                                    badgeSize: 50,
                                    compact: compactHeader,
                                    caption: compactHeader
                                        ? null
                                        : l10n.loginHeadline,
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
                                            .withValues(alpha: 0.18),
                                      ),
                                    ),
                                    child: Text(
                                      l10n.loginHeadline,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.84),
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    l10n.loginBody,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 18),
                                  _AuthModeToggle(
                                    mode: _mode,
                                    onChanged: (mode) {
                                      setState(() {
                                        _mode = mode;
                                        _registerLocalError = null;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 18),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: reservedFormHeight,
                                    ),
                                    child: AnimatedSize(
                                      duration: const Duration(
                                        milliseconds: 320,
                                      ),
                                      curve: Curves.easeInOutCubic,
                                      alignment: Alignment.topCenter,
                                      clipBehavior: Clip.none,
                                      child: AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 280,
                                        ),
                                        switchInCurve: Curves.easeOutCubic,
                                        switchOutCurve: Curves.easeInCubic,
                                        layoutBuilder:
                                            (currentChild, previousChildren) =>
                                                currentChild ??
                                                const SizedBox.shrink(),
                                        transitionBuilder: (child, animation) {
                                          final fade = CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeOutCubic,
                                          );
                                          final slide = Tween<Offset>(
                                            begin: const Offset(0, 0.03),
                                            end: Offset.zero,
                                          ).animate(fade);
                                          return FadeTransition(
                                            opacity: fade,
                                            child: SlideTransition(
                                              position: slide,
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: _mode == _AuthMode.signIn
                                            ? _buildSignInForm(
                                                key: const ValueKey(
                                                  'sign-in-form',
                                                ),
                                              )
                                            : _buildRegisterForm(
                                                key: const ValueKey(
                                                  'register-form',
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  Offstage(
                                    offstage: true,
                                    child: IgnorePointer(
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _MeasureSize(
                                              onChange: _cacheSignInFormHeight,
                                              child: _buildSignInForm(),
                                            ),
                                            _MeasureSize(
                                              onChange:
                                                  _cacheRegisterFormHeight,
                                              child: _buildRegisterForm(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (shownError != null) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      shownError,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.secondary,
                                          ),
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
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
                                      style: TextButton.styleFrom(
                                        alignment: Alignment.centerRight,
                                      ),
                                    ),
                                  ),
                                ],
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

  double get _computedReservedFormHeight {
    final measuredHeight = math.max(_signInFormHeight, _registerFormHeight);
    if (measuredHeight > 0) {
      return measuredHeight + 2;
    }
    return 360;
  }

  void _cacheSignInFormHeight(Size size) {
    if ((size.height - _signInFormHeight).abs() < 0.5) {
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _signInFormHeight = size.height;
    });
  }

  void _cacheRegisterFormHeight(Size size) {
    if ((size.height - _registerFormHeight).abs() < 0.5) {
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _registerFormHeight = size.height;
    });
  }

  _SignInForm _buildSignInForm({Key? key}) {
    return _SignInForm(
      key: key,
      usernameController: _loginUsernameController,
      passwordController: _loginPasswordController,
      obscurePassword: _obscureLoginPassword,
      isSubmitting: widget.authController.isSubmitting,
      onTogglePassword: () {
        setState(() {
          _obscureLoginPassword = !_obscureLoginPassword;
        });
      },
      onSubmit: () {
        widget.authController.login(
          username: _loginUsernameController.text.trim(),
          password: _loginPasswordController.text,
        );
      },
    );
  }

  _RegisterForm _buildRegisterForm({Key? key}) {
    return _RegisterForm(
      key: key,
      displayNameController: _registerDisplayNameController,
      usernameController: _registerUsernameController,
      passwordController: _registerPasswordController,
      confirmPasswordController: _registerConfirmPasswordController,
      obscurePassword: _obscureRegisterPassword,
      obscureConfirmPassword: _obscureRegisterConfirmPassword,
      isSubmitting: widget.authController.isSubmitting,
      onTogglePassword: () {
        setState(() {
          _obscureRegisterPassword = !_obscureRegisterPassword;
        });
      },
      onToggleConfirmPassword: () {
        setState(() {
          _obscureRegisterConfirmPassword = !_obscureRegisterConfirmPassword;
        });
      },
      onSubmit: () async {
        final l10n = context.l10n;
        final password = _registerPasswordController.text;
        if (password != _registerConfirmPasswordController.text) {
          setState(() {
            _registerLocalError = l10n.registerPasswordMismatch;
          });
          return;
        }
        setState(() {
          _registerLocalError = null;
        });
        await widget.authController.register(
          username: _registerUsernameController.text.trim(),
          password: password,
          displayName: _registerDisplayNameController.text.trim(),
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

class _AuthModeToggle extends StatelessWidget {
  const _AuthModeToggle({required this.mode, required this.onChanged});

  final _AuthMode mode;
  final ValueChanged<_AuthMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: theme.colorScheme.surface.withValues(alpha: 0.74),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.72),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _AuthModeToggleButton(
                  label: l10n.authModeSignIn,
                  icon: Icons.login_outlined,
                  selected: mode == _AuthMode.signIn,
                  onTap: () => onChanged(_AuthMode.signIn),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _AuthModeToggleButton(
                  label: l10n.authModeRegister,
                  icon: Icons.person_add_alt_1_outlined,
                  selected: mode == _AuthMode.register,
                  onTap: () => onChanged(_AuthMode.register),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthModeToggleButton extends StatelessWidget {
  const _AuthModeToggleButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: selected
                ? scheme.primary.withValues(alpha: 0.2)
                : Colors.transparent,
            border: Border.all(
              color: selected
                  ? scheme.primary.withValues(alpha: 0.34)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected
                    ? scheme.primary
                    : scheme.onSurface.withValues(alpha: 0.74),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: selected
                        ? scheme.primary
                        : scheme.onSurface.withValues(alpha: 0.8),
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignInForm extends StatelessWidget {
  const _SignInForm({
    super.key,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
    super.key,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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

class _MeasureSize extends SingleChildRenderObjectWidget {
  const _MeasureSize({required this.onChange, required super.child});

  final ValueChanged<Size> onChange;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMeasureSize(onChange);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMeasureSize renderObject,
  ) {
    renderObject.onChange = onChange;
  }
}

class _RenderMeasureSize extends RenderProxyBox {
  _RenderMeasureSize(this.onChange);

  ValueChanged<Size> onChange;
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    final childSize = child?.size;
    if (childSize == null || childSize == _oldSize) {
      return;
    }
    _oldSize = childSize;
    WidgetsBinding.instance.addPostFrameCallback((_) => onChange(childSize));
  }
}
