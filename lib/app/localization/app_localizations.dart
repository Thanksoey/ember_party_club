import 'package:flutter/material.dart';

import '../../core/models/game_module.dart';
import '../../features/auth/domain/app_user.dart';
import '../../features/game_session/domain/game_room_session.dart';
import '../../features/modules/signal_deck/domain/signal_card.dart';
import '../../features/modules/signal_deck/domain/signal_deck_state.dart';
import '../../features/rooms/domain/room_summary.dart';
import '../../features/settings/application/settings_controller.dart';
import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart' show AppLocalizations;

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension AppLocalizationsX on AppLocalizations {
  String signalCardMeta(SignalCard card) =>
      '${signalSuitLabel(card.suit)}  |  $signalPowerLabel ${card.power}  |  ${signalAbilityLabel(card.ability)}';

  String signalWinnerName(SignalMatchWinner winner) {
    switch (winner) {
      case SignalMatchWinner.player:
        return youLabel;
      case SignalMatchWinner.rival:
        return rivalLabel;
      case SignalMatchWinner.draw:
        return drawGame;
    }
  }

  String signalResultHeadline(SignalMatchWinner? winner) {
    if (winner == null || winner == SignalMatchWinner.draw) {
      return drawGame;
    }
    return winnerTakesMatch(signalWinnerName(winner));
  }

  String signalRoundSummary(SignalRoundLog log) {
    final playerCardTitle = signalCardTitle(log.playerCard.id);
    final rivalCardTitle = signalCardTitle(log.rivalCard.id);

    switch (log.outcome) {
      case SignalRoundOutcome.playerWin:
        return '$playerCardTitle (${log.playerPower}) ${signalRoundPlayerWinConnector(rivalCardTitle, log.rivalPower)}';
      case SignalRoundOutcome.rivalWin:
        return '$rivalCardTitle (${log.rivalPower}) ${signalRoundRivalWinConnector(playerCardTitle, log.playerPower)}';
      case SignalRoundOutcome.draw:
        return signalRoundDrawSummary(
          playerCardTitle,
          rivalCardTitle,
          log.playerPower,
        );
    }
  }

  String themeModeDescriptionValue(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return themeModeDescription(themeSystem);
      case ThemeMode.light:
        return themeModeDescription(themeLight);
      case ThemeMode.dark:
        return themeModeDescription(themeDark);
    }
  }

  String localeModeDescriptionValue(AppLocaleMode localeMode) {
    switch (localeMode) {
      case AppLocaleMode.system:
        return localeModeDescription(localeModeSystem);
      case AppLocaleMode.chinese:
        return localeModeDescription(localeModeChinese);
      case AppLocaleMode.english:
        return localeModeDescription(localeModeEnglish);
    }
  }

  String authProviderLabel(AuthProvider provider) {
    switch (provider) {
      case AuthProvider.usernamePassword:
        return authProviderUsernamePassword;
    }
  }

  String moduleName(GameModule module) {
    switch (module.id) {
      case 'signal-deck':
        return moduleNameSignalDeck;
      case 'midnight-vote':
        return moduleNameMidnightVote;
      case 'orbit-merchant':
        return moduleNameOrbitMerchant;
      case 'chaos-mixer':
        return moduleNameChaosMixer;
      default:
        return module.name;
    }
  }

  String moduleTagline(GameModule module) {
    switch (module.id) {
      case 'signal-deck':
        return moduleTaglineSignalDeck;
      case 'midnight-vote':
        return moduleTaglineMidnightVote;
      case 'orbit-merchant':
        return moduleTaglineOrbitMerchant;
      case 'chaos-mixer':
        return moduleTaglineChaosMixer;
      default:
        return module.tagline;
    }
  }

  String moduleSummary(GameModule module) {
    switch (module.id) {
      case 'signal-deck':
        return moduleSummarySignalDeck;
      case 'midnight-vote':
        return moduleSummaryMidnightVote;
      case 'orbit-merchant':
        return moduleSummaryOrbitMerchant;
      case 'chaos-mixer':
        return moduleSummaryChaosMixer;
      default:
        return module.summary;
    }
  }

  String roomTitle(RoomSummary room) {
    switch (room.id) {
      case 'room-signal-01':
        return roomTitleSignalRanked;
      case 'room-chaos-02':
        return roomTitleChaosFriday;
      case 'room-vote-03':
        return roomTitleVoteFriends;
      default:
        return room.title;
    }
  }

  String gameCategoryLabel(GameCategory category) {
    switch (category) {
      case GameCategory.card:
        return gameCategoryCard;
      case GameCategory.party:
        return gameCategoryParty;
      case GameCategory.bluff:
        return gameCategoryBluff;
      case GameCategory.strategy:
        return gameCategoryStrategy;
    }
  }

  String matchTempoLabel(MatchTempo tempo) {
    switch (tempo) {
      case MatchTempo.quick:
        return matchTempoQuick;
      case MatchTempo.standard:
        return matchTempoStandard;
      case MatchTempo.deep:
        return matchTempoDeep;
    }
  }

  String roomStatusLabel(RoomStatus status) {
    switch (status) {
      case RoomStatus.waiting:
        return roomStatusWaiting;
      case RoomStatus.inGame:
        return roomStatusInGame;
      case RoomStatus.settling:
        return roomStatusSettling;
    }
  }

  String gameSessionPhaseLabel(GameSessionPhase phase) {
    switch (phase) {
      case GameSessionPhase.briefing:
        return gameSessionPhaseBriefing;
      case GameSessionPhase.playing:
        return gameSessionPhasePlaying;
      case GameSessionPhase.finished:
        return gameSessionPhaseFinished;
    }
  }

  String gameSessionSyncStateLabel(GameSessionSyncState state) {
    switch (state) {
      case GameSessionSyncState.localPreview:
        return gameSessionSyncLocalPreview;
      case GameSessionSyncState.roomBound:
        return gameSessionSyncRoomBound;
      case GameSessionSyncState.multiplayerReady:
        return gameSessionSyncMultiplayerReady;
    }
  }

  String gameSessionParticipantName(GameSessionParticipant participant) {
    if (participant.id.startsWith('local-seat-')) {
      return gameSessionLocalPlayerName;
    }
    if (participant.id.startsWith('guest-seat-')) {
      return gameSessionGuestSeatName(participant.seat);
    }
    return participant.nickname;
  }

  String signalSuitLabel(SignalSuit suit) {
    switch (suit) {
      case SignalSuit.ember:
        return signalSuitEmber;
      case SignalSuit.tide:
        return signalSuitTide;
      case SignalSuit.spark:
        return signalSuitSpark;
    }
  }

  String signalAbilityLabel(SignalAbility ability) {
    switch (ability) {
      case SignalAbility.chain:
        return signalAbilityChain;
      case SignalAbility.counter:
        return signalAbilityCounter;
      case SignalAbility.surge:
        return signalAbilitySurge;
      case SignalAbility.anchor:
        return signalAbilityAnchor;
    }
  }

  String signalCardTitle(String cardId) {
    switch (cardId) {
      case 'e1':
        return signalCardTitleE1;
      case 'e2':
        return signalCardTitleE2;
      case 'e3':
        return signalCardTitleE3;
      case 'e4':
        return signalCardTitleE4;
      case 't1':
        return signalCardTitleT1;
      case 't2':
        return signalCardTitleT2;
      case 't3':
        return signalCardTitleT3;
      case 't4':
        return signalCardTitleT4;
      case 's1':
        return signalCardTitleS1;
      case 's2':
        return signalCardTitleS2;
      case 's3':
        return signalCardTitleS3;
      case 's4':
        return signalCardTitleS4;
      default:
        return cardId;
    }
  }

  String signalCardNote(String cardId) {
    switch (cardId) {
      case 'e1':
        return signalCardNoteE1;
      case 'e2':
        return signalCardNoteE2;
      case 'e3':
        return signalCardNoteE3;
      case 'e4':
        return signalCardNoteE4;
      case 't1':
        return signalCardNoteT1;
      case 't2':
        return signalCardNoteT2;
      case 't3':
        return signalCardNoteT3;
      case 't4':
        return signalCardNoteT4;
      case 's1':
        return signalCardNoteS1;
      case 's2':
        return signalCardNoteS2;
      case 's3':
        return signalCardNoteS3;
      case 's4':
        return signalCardNoteS4;
      default:
        return cardId;
    }
  }
}
