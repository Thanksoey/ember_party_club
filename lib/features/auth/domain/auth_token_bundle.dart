class AuthTokenBundle {
  const AuthTokenBundle({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.sessionId,
  });

  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String sessionId;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
