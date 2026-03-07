import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/widgets/app_backdrop.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../auth/presentation/widgets/auth_gate.dart';

class AdminConsolePage extends StatelessWidget {
  const AdminConsolePage({
    super.key,
    required this.authController,
  });

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return AuthGate(
      authController: authController,
      requireAdmin: true,
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.adminConsoleTitle)),
        body: AppBackdrop(
          primaryAlignment: const Alignment(-0.8, -0.8),
          secondaryAlignment: const Alignment(0.9, 0.9),
          child: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Text(l10n.adminConsoleTitle, style: theme.textTheme.displaySmall),
                const SizedBox(height: 10),
                Text(l10n.adminConsoleBody, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _AdminMetricCard(
                        label: l10n.adminMetricUsers,
                        value: '2',
                        accent: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _AdminMetricCard(
                        label: l10n.adminMetricRooms,
                        value: '3',
                        accent: theme.colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _AdminMetricCard(
                        label: l10n.adminMetricIncidents,
                        value: '0',
                        accent: theme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _AdminSection(
                  title: l10n.adminUsersSection,
                  body: l10n.adminUsersBody,
                  items: [
                    l10n.adminUsersItemModeration,
                    l10n.adminUsersItemBan,
                    l10n.adminUsersItemSearch,
                  ],
                ),
                const SizedBox(height: 18),
                _AdminSection(
                  title: l10n.adminRoomsSection,
                  body: l10n.adminRoomsBody,
                  items: [
                    l10n.adminRoomsItemQueue,
                    l10n.adminRoomsItemHealth,
                    l10n.adminRoomsItemCapacity,
                  ],
                ),
                const SizedBox(height: 18),
                _AdminSection(
                  title: l10n.adminOpsSection,
                  body: l10n.adminOpsBody,
                  items: [
                    l10n.adminOpsItemConfig,
                    l10n.adminOpsItemBanner,
                    l10n.adminOpsItemFeatureFlag,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminMetricCard extends StatelessWidget {
  const _AdminMetricCard({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(color: accent),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminSection extends StatelessWidget {
  const _AdminSection({
    required this.title,
    required this.body,
    required this.items,
  });

  final String title;
  final String body;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(body, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(Icons.fiber_manual_record, size: 10),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(item, style: theme.textTheme.bodyLarge)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
