import 'package:flutter/material.dart';

import '../../features/auth/domain/app_user.dart';

class AvatarBadge extends StatelessWidget {
  const AvatarBadge({super.key, required this.user, this.size = 72});

  final AppUser user;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = _palettes[user.avatarSeed % _palettes.length];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.34),
        gradient: LinearGradient(
          colors: palette,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: palette.last.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        user.initials,
        style: theme.textTheme.headlineSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

const _palettes = <List<Color>>[
  [Color(0xFF0D3B66), Color(0xFF3D8D7A)],
  [Color(0xFF7A3E65), Color(0xFFED7D3A)],
  [Color(0xFF274C77), Color(0xFF6096BA)],
  [Color(0xFF8A5A44), Color(0xFFD08C60)],
  [Color(0xFF224870), Color(0xFF31A2AC)],
  [Color(0xFF7B2CBF), Color(0xFFEF476F)],
  [Color(0xFF0B6E4F), Color(0xFFFF6B35)],
  [Color(0xFF283618), Color(0xFFB56576)],
];
