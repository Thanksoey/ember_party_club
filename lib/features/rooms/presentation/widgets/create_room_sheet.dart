import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../core/models/game_module.dart';
import '../../application/room_lounge_controller.dart';

class CreateRoomSheet extends StatefulWidget {
  const CreateRoomSheet({super.key, required this.controller});

  final RoomLoungeController controller;

  @override
  State<CreateRoomSheet> createState() => _CreateRoomSheetState();
}

class _CreateRoomSheetState extends State<CreateRoomSheet> {
  late GameModule _selectedModule;
  late int _capacity;
  late TextEditingController _titleController;
  bool _voiceEnabled = true;
  bool _ranked = false;

  @override
  void initState() {
    super.initState();
    _selectedModule = widget.controller.availableModules.firstWhere(
      (module) => module.id == 'signal-deck',
      orElse: () => widget.controller.availableModules.first,
    );
    _capacity = _defaultCapacityFor(_selectedModule);
    _titleController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_titleController.text.isEmpty) {
      _titleController.text = context.l10n.roomCreateDefaultName(
        context.l10n.moduleName(_selectedModule),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final capacities = [
      for (
        var seat = _selectedModule.minPlayers;
        seat <= _selectedModule.maxPlayers;
        seat++
      )
        seat,
    ];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.roomCreateSheetTitle,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(l10n.roomCreateSheetBody, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 20),
              TextField(
                key: const ValueKey('room-name-field'),
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: l10n.roomNameFieldLabel,
                  hintText: l10n.roomCreateDefaultName(
                    l10n.moduleName(_selectedModule),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<GameModule>(
                key: ValueKey('room-module-field-${_selectedModule.id}'),
                initialValue: _selectedModule,
                decoration: InputDecoration(
                  labelText: l10n.roomSelectModuleLabel,
                ),
                items: widget.controller.availableModules
                    .map(
                      (module) => DropdownMenuItem<GameModule>(
                        value: module,
                        child: Text(l10n.moduleName(module)),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (module) {
                  if (module == null) {
                    return;
                  }
                  setState(() {
                    final previousDefault = l10n.roomCreateDefaultName(
                      l10n.moduleName(_selectedModule),
                    );
                    _selectedModule = module;
                    if (_capacity < module.minPlayers ||
                        _capacity > module.maxPlayers) {
                      _capacity = _defaultCapacityFor(module);
                    }
                    if (_titleController.text.trim().isEmpty ||
                        _titleController.text == previousDefault) {
                      _titleController.text = l10n.roomCreateDefaultName(
                        l10n.moduleName(module),
                      );
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                key: ValueKey('room-capacity-field-${_capacity}'),
                initialValue: _capacity,
                decoration: InputDecoration(
                  labelText: l10n.roomCapacityFieldLabel,
                ),
                items: capacities
                    .map(
                      (seat) => DropdownMenuItem<int>(
                        value: seat,
                        child: Text(l10n.playersLabel(seat, seat)),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _capacity = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                value: _voiceEnabled,
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.roomVoiceToggle),
                onChanged: (value) {
                  setState(() {
                    _voiceEnabled = value;
                  });
                },
              ),
              SwitchListTile.adaptive(
                value: _ranked,
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.roomRankedToggle),
                onChanged: (value) {
                  setState(() {
                    _ranked = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  key: const ValueKey('submit-create-room'),
                  onPressed: () {
                    final title = _titleController.text.trim().isEmpty
                        ? l10n.roomCreateDefaultName(
                            l10n.moduleName(_selectedModule),
                          )
                        : _titleController.text.trim();
                    final room = widget.controller.createRoom(
                      title: title,
                      module: _selectedModule,
                      capacity: _capacity,
                      isVoiceEnabled: _voiceEnabled,
                      isRanked: _ranked,
                    );
                    Navigator.of(context).pop(room.id);
                  },
                  child: Text(l10n.roomCreateAndEnter),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _defaultCapacityFor(GameModule module) {
    final base = module.minPlayers + 1;
    if (base > module.maxPlayers) {
      return module.maxPlayers;
    }
    return base;
  }
}
