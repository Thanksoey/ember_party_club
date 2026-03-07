import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';

class GameSessionScaffold extends StatelessWidget {
  const GameSessionScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.statusText,
    required this.metrics,
    required this.primaryPanel,
    required this.content,
    this.contextPanel,
    this.resultPanel,
    this.onReset,
  });

  final String title;
  final String subtitle;
  final String statusText;
  final List<Widget> metrics;
  final Widget primaryPanel;
  final List<Widget> content;
  final Widget? contextPanel;
  final Widget? resultPanel;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (onReset != null)
            TextButton(
              onPressed: onReset,
              child: Text(context.l10n.reset),
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              subtitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 10),
            Text(statusText, style: theme.textTheme.bodyLarge),
            if (contextPanel != null) ...[
              const SizedBox(height: 20),
              contextPanel!,
            ],
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Wrap(
                spacing: 20,
                runSpacing: 14,
                children: metrics,
              ),
            ),
            const SizedBox(height: 20),
            primaryPanel,
            if (resultPanel != null) ...[
              const SizedBox(height: 20),
              resultPanel!,
            ],
            const SizedBox(height: 20),
            ...content,
          ],
        ),
      ),
    );
  }
}

class GameSessionMetric extends StatelessWidget {
  const GameSessionMetric({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text(value, style: theme.textTheme.headlineSmall),
        ],
      ),
    );
  }
}
