import 'package:flutter/services.dart';

enum AppFeedbackType {
  tap,
  cardPlay,
  cardDraw,
  investigate,
  tradeFocus,
  tradeBuy,
  tradeSell,
  chaosSpin,
  roundWin,
  roundLose,
  guideStep,
  guideReady,
  success,
  failure,
  reset,
}

class AppFeedback {
  AppFeedback._();

  static final AppFeedback instance = AppFeedback._();

  bool _soundEnabled = true;
  bool _hapticsEnabled = true;

  void configure({required bool soundEnabled, required bool hapticsEnabled}) {
    _soundEnabled = soundEnabled;
    _hapticsEnabled = hapticsEnabled;
  }

  Future<void> play(AppFeedbackType type) async {
    await Future.wait<void>([
      if (_soundEnabled)
        _playSound(type).catchError((_) {
          // Ignore platform-channel failures in tests and unsupported targets.
        }),
      if (_hapticsEnabled)
        _playHaptics(type).catchError((_) {
          // Ignore platform-channel failures in tests and unsupported targets.
        }),
    ]);
  }

  Future<void> _playSound(AppFeedbackType type) async {
    switch (type) {
      case AppFeedbackType.tap:
      case AppFeedbackType.guideStep:
      case AppFeedbackType.reset:
        await SystemSound.play(SystemSoundType.click);
        return;
      case AppFeedbackType.cardPlay:
        await SystemSound.play(SystemSoundType.click);
        await Future<void>.delayed(const Duration(milliseconds: 45));
        await SystemSound.play(SystemSoundType.click);
        return;
      case AppFeedbackType.cardDraw:
        await SystemSound.play(SystemSoundType.click);
        await Future<void>.delayed(const Duration(milliseconds: 40));
        await SystemSound.play(SystemSoundType.alert);
        return;
      case AppFeedbackType.investigate:
        await SystemSound.play(SystemSoundType.alert);
        await Future<void>.delayed(const Duration(milliseconds: 55));
        await SystemSound.play(SystemSoundType.click);
        return;
      case AppFeedbackType.tradeFocus:
        await SystemSound.play(SystemSoundType.click);
        return;
      case AppFeedbackType.tradeBuy:
        await SystemSound.play(SystemSoundType.alert);
        await Future<void>.delayed(const Duration(milliseconds: 45));
        await SystemSound.play(SystemSoundType.click);
        return;
      case AppFeedbackType.tradeSell:
        await SystemSound.play(SystemSoundType.click);
        await Future<void>.delayed(const Duration(milliseconds: 45));
        await SystemSound.play(SystemSoundType.alert);
        return;
      case AppFeedbackType.chaosSpin:
        await SystemSound.play(SystemSoundType.click);
        await Future<void>.delayed(const Duration(milliseconds: 35));
        await SystemSound.play(SystemSoundType.click);
        await Future<void>.delayed(const Duration(milliseconds: 35));
        await SystemSound.play(SystemSoundType.alert);
        return;
      case AppFeedbackType.roundWin:
        await SystemSound.play(SystemSoundType.click);
        await Future<void>.delayed(const Duration(milliseconds: 65));
        await SystemSound.play(SystemSoundType.alert);
        return;
      case AppFeedbackType.roundLose:
        await SystemSound.play(SystemSoundType.click);
        await Future<void>.delayed(const Duration(milliseconds: 40));
        await SystemSound.play(SystemSoundType.click);
        return;
      case AppFeedbackType.guideReady:
        await SystemSound.play(SystemSoundType.click);
        await Future<void>.delayed(const Duration(milliseconds: 60));
        await SystemSound.play(SystemSoundType.alert);
        return;
      case AppFeedbackType.success:
        await SystemSound.play(SystemSoundType.alert);
        await Future<void>.delayed(const Duration(milliseconds: 70));
        await SystemSound.play(SystemSoundType.click);
        return;
      case AppFeedbackType.failure:
        await SystemSound.play(SystemSoundType.click);
        await Future<void>.delayed(const Duration(milliseconds: 85));
        await SystemSound.play(SystemSoundType.click);
        return;
    }
  }

  Future<void> _playHaptics(AppFeedbackType type) {
    switch (type) {
      case AppFeedbackType.tap:
      case AppFeedbackType.guideStep:
      case AppFeedbackType.reset:
      case AppFeedbackType.tradeFocus:
        return HapticFeedback.selectionClick();
      case AppFeedbackType.cardPlay:
      case AppFeedbackType.cardDraw:
      case AppFeedbackType.investigate:
      case AppFeedbackType.tradeBuy:
      case AppFeedbackType.tradeSell:
      case AppFeedbackType.chaosSpin:
      case AppFeedbackType.roundWin:
      case AppFeedbackType.guideReady:
        return HapticFeedback.lightImpact();
      case AppFeedbackType.success:
        return HapticFeedback.heavyImpact();
      case AppFeedbackType.roundLose:
      case AppFeedbackType.failure:
        return HapticFeedback.mediumImpact();
    }
  }
}
