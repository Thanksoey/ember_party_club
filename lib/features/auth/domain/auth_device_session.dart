class AuthDeviceSession {
  const AuthDeviceSession({
    required this.id,
    required this.deviceName,
    required this.platformLabel,
    required this.lastActiveAt,
    required this.isCurrent,
  });

  final String id;
  final String deviceName;
  final String platformLabel;
  final DateTime lastActiveAt;
  final bool isCurrent;
}
