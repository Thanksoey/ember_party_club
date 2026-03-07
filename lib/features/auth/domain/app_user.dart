enum AppUserRole {
  admin,
  player,
}

enum AuthProvider {
  usernamePassword,
}

class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.role,
    required this.uid,
    required this.level,
    required this.bio,
    required this.avatarSeed,
    required this.email,
    required this.provider,
  });

  final String id;
  final String username;
  final String displayName;
  final AppUserRole role;
  final String uid;
  final int level;
  final String bio;
  final int avatarSeed;
  final String email;
  final AuthProvider provider;

  bool get isAdmin => role == AppUserRole.admin;

  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) {
      return username.substring(0, 1).toUpperCase();
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  AppUser copyWith({
    String? displayName,
    String? bio,
    int? avatarSeed,
    String? email,
    int? level,
  }) {
    return AppUser(
      id: id,
      username: username,
      displayName: displayName ?? this.displayName,
      role: role,
      uid: uid,
      level: level ?? this.level,
      bio: bio ?? this.bio,
      avatarSeed: avatarSeed ?? this.avatarSeed,
      email: email ?? this.email,
      provider: provider,
    );
  }
}
