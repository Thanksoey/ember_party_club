class PlayerProfile {
  const PlayerProfile({
    required this.id,
    required this.nickname,
    required this.level,
    required this.isOnline,
  });

  final String id;
  final String nickname;
  final int level;
  final bool isOnline;
}
