import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/widgets/app_backdrop.dart';
import '../../../../app/widgets/avatar_badge.dart';
import '../../../auth/application/auth_controller.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.authController,
  });

  final AuthController authController;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _displayNameController;
  late final TextEditingController _bioController;
  late int _avatarSeed;

  @override
  void initState() {
    super.initState();
    final user = widget.authController.currentUser!;
    _displayNameController = TextEditingController(text: user.displayName);
    _bioController = TextEditingController(text: user.bio);
    _avatarSeed = user.avatarSeed;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.authController.currentUser!;
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return AnimatedBuilder(
      animation: widget.authController,
      builder: (context, _) {
        final previewUser = user.copyWith(
          displayName: _displayNameController.text.trim().isEmpty
              ? user.displayName
              : _displayNameController.text.trim(),
          bio: _bioController.text.trim().isEmpty ? user.bio : _bioController.text.trim(),
          avatarSeed: _avatarSeed,
        );

        return Scaffold(
          appBar: AppBar(title: Text(l10n.profileEditTitle)),
          body: AppBackdrop(
            primaryAlignment: const Alignment(-1, -0.7),
            secondaryAlignment: const Alignment(1, 0.8),
            child: SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Row(
                        children: [
                          AvatarBadge(user: previewUser, size: 84),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(previewUser.displayName, style: theme.textTheme.headlineSmall),
                                const SizedBox(height: 6),
                                Text(previewUser.bio, style: theme.textTheme.bodyLarge),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.profileEditTitle, style: theme.textTheme.headlineSmall),
                          const SizedBox(height: 8),
                          Text(l10n.profileEditBody, style: theme.textTheme.bodyLarge),
                          const SizedBox(height: 18),
                          TextField(
                            key: const ValueKey('profile-display-name'),
                            controller: _displayNameController,
                            decoration: InputDecoration(labelText: l10n.profileDisplayNameField),
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            key: const ValueKey('profile-bio'),
                            controller: _bioController,
                            maxLines: 3,
                            decoration: InputDecoration(labelText: l10n.profileBioField),
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 18),
                          Text(l10n.profileAvatarField, style: theme.textTheme.titleLarge),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List<Widget>.generate(8, (index) {
                              final candidate = user.copyWith(
                                avatarSeed: index,
                                displayName: _displayNameController.text.trim().isEmpty
                                    ? user.displayName
                                    : _displayNameController.text.trim(),
                              );
                              return InkWell(
                                key: ValueKey('avatar-seed-$index'),
                                borderRadius: BorderRadius.circular(18),
                                onTap: () {
                                  setState(() {
                                    _avatarSeed = index;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: _avatarSeed == index
                                          ? theme.colorScheme.secondary
                                          : theme.colorScheme.outline,
                                      width: _avatarSeed == index ? 2 : 1,
                                    ),
                                  ),
                                  child: AvatarBadge(user: candidate, size: 52),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              key: const ValueKey('save-profile'),
                              onPressed: widget.authController.isUpdatingProfile
                                  ? null
                                  : () async {
                                      final success = await widget.authController.updateProfile(
                                        displayName: _displayNameController.text.trim(),
                                        bio: _bioController.text.trim(),
                                        avatarSeed: _avatarSeed,
                                      );
                                      if (!context.mounted || !success) {
                                        return;
                                      }
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(l10n.profileSavedMessage)),
                                      );
                                      Navigator.of(context).pop();
                                    },
                              child: widget.authController.isUpdatingProfile
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : Text(l10n.profileSaveAction),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
