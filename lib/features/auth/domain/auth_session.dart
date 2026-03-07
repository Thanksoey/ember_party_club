import 'app_user.dart';
import 'auth_token_bundle.dart';

class AuthSession {
  const AuthSession({
    required this.user,
    required this.tokens,
    required this.signedInAt,
  });

  final AppUser user;
  final AuthTokenBundle tokens;
  final DateTime signedInAt;

  bool get isExpired => tokens.isExpired;

  AuthSession copyWith({
    AppUser? user,
    AuthTokenBundle? tokens,
    DateTime? signedInAt,
  }) {
    return AuthSession(
      user: user ?? this.user,
      tokens: tokens ?? this.tokens,
      signedInAt: signedInAt ?? this.signedInAt,
    );
  }
}
