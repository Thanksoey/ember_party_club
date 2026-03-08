import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/widgets/app_backdrop.dart';
import '../../../../app/widgets/app_panel.dart';
import '../../../../app/widgets/brand_lockup.dart';

class AuthGuidePage extends StatelessWidget {
  const AuthGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.authGuideTitle)),
      body: AppBackdrop(
        primaryAlignment: const Alignment(-0.9, -0.8),
        secondaryAlignment: const Alignment(0.9, 0.8),
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              const BrandLockup(
                badgeSize: 64,
                compact: false,
                caption: 'ROOMS, RULES, AND PARTY ETIQUETTE',
              ),
              const SizedBox(height: 16),
              AppPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.authGuideIntroTitle,
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.authGuideIntroBody,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.authGuideRulesTitle,
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    _RuleTile(
                      icon: Icons.videogame_asset_outlined,
                      title: l10n.authGuideRuleSignalTitle,
                      body: l10n.authGuideRuleSignalBody,
                    ),
                    const SizedBox(height: 12),
                    _RuleTile(
                      icon: Icons.meeting_room_outlined,
                      title: l10n.authGuideRuleRoomTitle,
                      body: l10n.authGuideRuleRoomBody,
                    ),
                    const SizedBox(height: 12),
                    _RuleTile(
                      icon: Icons.groups_2_outlined,
                      title: l10n.authGuideRuleFairTitle,
                      body: l10n.authGuideRuleFairBody,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RuleTile extends StatelessWidget {
  const _RuleTile({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          foregroundColor: theme.colorScheme.primary,
          child: Icon(icon, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(body, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
