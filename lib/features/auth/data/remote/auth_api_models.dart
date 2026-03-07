import '../../domain/app_user.dart';
import '../../domain/auth_device_session.dart';

class AuthApiTokenPayload {
  const AuthApiTokenPayload({
    required this.accessToken,
    required this.refreshToken,
    required this.sessionId,
    required this.expiresAt,
  });

  final String accessToken;
  final String refreshToken;
  final String sessionId;
  final DateTime expiresAt;
}

class AuthApiSessionPayload {
  const AuthApiSessionPayload({
    required this.user,
    required this.tokens,
    required this.signedInAt,
  });

  final AppUser user;
  final AuthApiTokenPayload tokens;
  final DateTime signedInAt;
}

class AuthApiProfileUpdatePayload {
  const AuthApiProfileUpdatePayload({
    required this.displayName,
    required this.bio,
    required this.avatarSeed,
  });

  final String displayName;
  final String bio;
  final int avatarSeed;
}

class AuthApiChangePasswordPayload {
  const AuthApiChangePasswordPayload({
    required this.currentPassword,
    required this.nextPassword,
  });

  final String currentPassword;
  final String nextPassword;
}

class AuthApiDeviceListPayload {
  const AuthApiDeviceListPayload({
    required this.devices,
  });

  final List<AuthDeviceSession> devices;
}
