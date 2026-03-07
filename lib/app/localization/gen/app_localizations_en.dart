// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ember Party Club';

  @override
  String get discoverTab => 'Discover';

  @override
  String get roomsTab => 'Rooms';

  @override
  String get reset => 'Reset';

  @override
  String get play => 'Play';

  @override
  String get playAgain => 'Play again';

  @override
  String get viewPlan => 'View plan';

  @override
  String get playPrototype => 'Play prototype';

  @override
  String get homeHeroTitle =>
      'A mobile game hub designed for friend groups, not solo play.';

  @override
  String get homeHeroBody =>
      'The product focuses on low-latency rooms, pluggable game modules, stable voice interaction, and an enterprise-ready codebase.';

  @override
  String get modulesLabel => 'Modules';

  @override
  String get featuredLabel => 'Featured';

  @override
  String get launchStrategy => 'Launch Strategy';

  @override
  String get launchBannerTitle =>
      'Build the room layer first, then ship game modules on top.';

  @override
  String get launchBannerBody =>
      'Once accounts, friends, team-up, voice, realtime sync, and settlement are unified, every new game becomes cheaper to ship.';

  @override
  String get moduleFilterTitle => 'Module filter';

  @override
  String get moduleFilterSubtitle =>
      'Anchor new games to the shared room layer, then expand into card, social deduction, and party play.';

  @override
  String candidateGamesTitle(int count) {
    return 'Candidate games';
  }

  @override
  String candidateGamesSubtitle(int count) {
    return 'Showing $count modules suitable for the first release wave.';
  }

  @override
  String planningQueue(Object moduleName) {
    return '$moduleName is still in the planning queue.';
  }

  @override
  String get roomLoungeTitle => 'Room Lounge';

  @override
  String get roomLoungeHero =>
      'Keep room creation, invites, parties, and voice inside one shared room layer.';

  @override
  String get roomLoungeBody =>
      'New games then only need rules and rendering instead of rebuilding multiplayer infrastructure.';

  @override
  String get activeRoomsMetric => 'Active rooms';

  @override
  String get onlinePlayersMetric => 'Players online';

  @override
  String get quickMatch => 'Quick Match';

  @override
  String get quickMatchBody => 'Auto room find + smart fill';

  @override
  String get createRoom => 'Create Room';

  @override
  String get createRoomBody => 'Pick a module, then configure seats and voice';

  @override
  String get hottestRoom => 'Hottest room';

  @override
  String get activeRoomList => 'Active rooms';

  @override
  String hostLabel(Object nickname) {
    return 'Host $nickname';
  }

  @override
  String playersLabel(int current, int capacity) {
    return '$current/$capacity players';
  }

  @override
  String get voiceOn => 'Voice on';

  @override
  String get ranked => 'Ranked';

  @override
  String get casual => 'Casual';

  @override
  String get signalDeckTitle => 'Signal Deck';

  @override
  String get signalDeckSubtitle => 'First playable card battle';

  @override
  String get signalDeckIntro =>
      'This build already has card abilities, fixed-round rules, and a replay loop ready to plug into multiplayer rooms.';

  @override
  String get yourHand => 'Your hand';

  @override
  String get roundLog => 'Round log';

  @override
  String get noRoundsPlayed => 'No rounds played yet.';

  @override
  String signalRoundLabel(int round) {
    return 'Round $round';
  }

  @override
  String signalPowerCheck(int playerPower, int rivalPower) {
    return 'Power check: you $playerPower / rival $rivalPower';
  }

  @override
  String get youLabel => 'You';

  @override
  String get rivalLabel => 'Pulse AI';

  @override
  String get roundsWon => 'Rounds won';

  @override
  String get matchLabel => 'Match';

  @override
  String get youNotPlayed => 'You have not played yet.';

  @override
  String youPlayed(Object title) {
    return 'You played $title';
  }

  @override
  String get rivalWaiting => 'Pulse AI is waiting.';

  @override
  String rivalPlayed(Object title) {
    return 'Pulse AI played $title';
  }

  @override
  String get drawGame => 'Draw game';

  @override
  String winnerTakesMatch(Object winner) {
    return '$winner takes the match';
  }

  @override
  String get matchOver => 'The match is over.';

  @override
  String get signalPowerLabel => 'Power';

  @override
  String signalPoints(int score) {
    return '$score pts';
  }

  @override
  String signalStatus(int round, int maxRounds) {
    return 'Pick a card to open round $round of $maxRounds.';
  }

  @override
  String signalFinishReason(
    int rounds,
    int playerScore,
    int rivalScore,
    int playerRoundsWon,
    int rivalRoundsWon,
  ) {
    return 'Finished after $rounds rounds. Score $playerScore-$rivalScore, rounds $playerRoundsWon-$rivalRoundsWon.';
  }

  @override
  String signalRoundPlayerWinConnector(Object rivalCardTitle, int rivalPower) {
    return 'defeats $rivalCardTitle ($rivalPower). You gain 3 points.';
  }

  @override
  String signalRoundRivalWinConnector(Object playerCardTitle, int playerPower) {
    return 'defeats $playerCardTitle ($playerPower). Pulse AI gains 3 points.';
  }

  @override
  String signalRoundDrawSummary(
    Object playerCardTitle,
    Object rivalCardTitle,
    int power,
  ) {
    return '$playerCardTitle and $rivalCardTitle tie at $power. Both sides gain 1 point.';
  }

  @override
  String get moduleNameSignalDeck => 'Signal Deck';

  @override
  String get moduleNameMidnightVote => 'Midnight Vote';

  @override
  String get moduleNameOrbitMerchant => 'Orbit Merchant';

  @override
  String get moduleNameChaosMixer => 'Chaos Mixer';

  @override
  String get moduleTaglineSignalDeck => 'Fast-paced tactical card play';

  @override
  String get moduleTaglineMidnightVote => 'Social deduction with brisk votes';

  @override
  String get moduleTaglineOrbitMerchant => 'Mid-weight strategy trading';

  @override
  String get moduleTaglineChaosMixer => 'Party minigame collection';

  @override
  String get moduleSummarySignalDeck =>
      'A turn-based card game built around hand combos and table chemistry, designed to open party sessions fast.';

  @override
  String get moduleSummaryMidnightVote =>
      'A ten-minute hidden-role loop focused on voice interaction and vote pacing.';

  @override
  String get moduleSummaryOrbitMerchant =>
      'Combines resource trading with deckbuilding for long-running rooms and seasonal ladders.';

  @override
  String get moduleSummaryChaosMixer =>
      'Bundles trivia, acting, drawing, and punishment wheels into one party room.';

  @override
  String get roomTitleSignalRanked => 'Signal Deck ranked room';

  @override
  String get roomTitleChaosFriday => 'Chaos Mixer Friday party';

  @override
  String get roomTitleVoteFriends => 'Midnight Vote friends room';

  @override
  String get gameCategoryCard => 'Card';

  @override
  String get gameCategoryParty => 'Party';

  @override
  String get gameCategoryBluff => 'Bluff';

  @override
  String get gameCategoryStrategy => 'Strategy';

  @override
  String get matchTempoQuick => '15 min';

  @override
  String get matchTempoStandard => '30 min';

  @override
  String get matchTempoDeep => '45+ min';

  @override
  String get roomStatusWaiting => 'Waiting';

  @override
  String get roomStatusInGame => 'In Game';

  @override
  String get roomStatusSettling => 'Settling';

  @override
  String get signalSuitEmber => 'Ember';

  @override
  String get signalSuitTide => 'Tide';

  @override
  String get signalSuitSpark => 'Spark';

  @override
  String get signalAbilityChain => 'Chain';

  @override
  String get signalAbilityCounter => 'Counter';

  @override
  String get signalAbilitySurge => 'Surge';

  @override
  String get signalAbilityAnchor => 'Anchor';

  @override
  String get signalCardTitleE1 => 'Flare Link';

  @override
  String get signalCardTitleE2 => 'Ash Pulse';

  @override
  String get signalCardTitleE3 => 'Solar Call';

  @override
  String get signalCardTitleE4 => 'Crimson Sync';

  @override
  String get signalCardTitleT1 => 'Ripple Mark';

  @override
  String get signalCardTitleT2 => 'Deep Current';

  @override
  String get signalCardTitleT3 => 'Blue Echo';

  @override
  String get signalCardTitleT4 => 'Mist Veil';

  @override
  String get signalCardTitleS1 => 'Volt Tap';

  @override
  String get signalCardTitleS2 => 'Quick Circuit';

  @override
  String get signalCardTitleS3 => 'Static Crown';

  @override
  String get signalCardTitleS4 => 'Signal Needle';

  @override
  String get signalCardNoteE1 => 'Chain: +2 after another Ember card.';

  @override
  String get signalCardNoteE2 => 'Surge: +1 while trailing.';

  @override
  String get signalCardNoteE3 => 'Chain: powerful finisher in Ember streaks.';

  @override
  String get signalCardNoteE4 => 'Anchor: +2 into heavy rival cards.';

  @override
  String get signalCardNoteT1 => 'Counter: +2 against Ember.';

  @override
  String get signalCardNoteT2 => 'Anchor: +2 when absorbing stronger cards.';

  @override
  String get signalCardNoteT3 => 'Counter: wins tempo against Ember lines.';

  @override
  String get signalCardNoteT4 => 'Surge: +1 while trailing.';

  @override
  String get signalCardNoteS1 => 'Surge: +1 while trailing.';

  @override
  String get signalCardNoteS2 => 'Chain: +2 after another Spark card.';

  @override
  String get signalCardNoteS3 => 'Surge: late-round closer when behind.';

  @override
  String get signalCardNoteS4 => 'Anchor: +2 into heavy rival cards.';

  @override
  String get roomDetailBody =>
      'This page is the bridge between room setup and the actual game session. Start with Signal Deck, then reuse the shell for other games.';

  @override
  String get roomCapacityFieldLabel => 'Seat count';

  @override
  String get roomVoiceToggle => 'Enable voice';

  @override
  String get roomCreateAndEnter => 'Create and enter';

  @override
  String get roomInfoSection => 'Room info';

  @override
  String get roomUnsupportedBody =>
      'This module is listed in the room layer already, but the playable session has not been wired yet.';

  @override
  String get roomDetailTitle => 'Room details';

  @override
  String get roomSelectModuleLabel => 'Game module';

  @override
  String get roomModuleLabel => 'Module';

  @override
  String roomCreateDefaultName(Object moduleName) {
    return '$moduleName room';
  }

  @override
  String get roomSettingsSection => 'Room settings';

  @override
  String get roomStartGame => 'Start game';

  @override
  String get roomVoiceOff => 'Voice off';

  @override
  String get roomNotFound => 'Room not found.';

  @override
  String get roomCreateSheetBody =>
      'Pick a module, set seats, and jump straight into a room flow that can later plug into realtime sync.';

  @override
  String get roomCodeLabel => 'Room ID';

  @override
  String get roomRankedToggle => 'Ranked room';

  @override
  String get roomStartGameBody =>
      'Signal Deck is already wired as a local playable prototype. Starting now will mark the room in-game and open the match.';

  @override
  String get roomNameFieldLabel => 'Room name';

  @override
  String get roomCreateSheetTitle => 'Create room';

  @override
  String get quickMatchEmpty => 'No room is available for quick match yet.';

  @override
  String get roomHostNameLabel => 'Host';

  @override
  String get gameSessionParticipantsLabel => 'Participants';

  @override
  String get gameSessionLocalPlayerName => 'You';

  @override
  String get gameSessionLocalTag => 'Local';

  @override
  String get gameSessionPhaseBriefing => 'Briefing';

  @override
  String get gameSessionSyncMultiplayerReady => 'Ready for sync';

  @override
  String get gameSessionSyncRoomBound => 'Room-bound';

  @override
  String roomSessionTitle(Object roomTitle, Object moduleName) {
    return '$roomTitle · $moduleName';
  }

  @override
  String get gameSessionPhaseFinished => 'Finished';

  @override
  String get gameSessionRoomLabel => 'Room session';

  @override
  String get gameSessionPhasePlaying => 'Playing';

  @override
  String get gameSessionSyncLocalPreview => 'Local preview';

  @override
  String gameSessionGuestSeatName(int seat) {
    return 'Seat $seat';
  }

  @override
  String get gameSessionHostTag => 'Host';

  @override
  String gameSessionParticipantLabel(int seat, Object name) {
    return '$name · Seat $seat';
  }

  @override
  String get signalDeckRoomSubtitle => 'Room-bound card battle session';

  @override
  String get gameSessionSyncLabel => 'Sync';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get settingsBody =>
      'Theme mode is already wired globally and persists across launches.';

  @override
  String get launchLoadingBody =>
      'Preparing rooms, modules, and session state...';

  @override
  String get loginBody =>
      'Use a seeded local account first. Once the auth shell is stable, replacing it with a real backend becomes straightforward.';

  @override
  String get profileBody =>
      'Manage account state, visual preferences, and developer-facing controls from one place.';

  @override
  String get loginUsernameLabel => 'Username';

  @override
  String get themeTitle => 'Theme';

  @override
  String get profileRolePlayer => 'Player';

  @override
  String get localeBody =>
      'Default is Chinese. If the system language is English, the app switches automatically.';

  @override
  String get loginAction => 'Sign in';

  @override
  String get themeDark => 'Dark';

  @override
  String get loginDemoHint =>
      'Default demo account is pre-filled for quick development. Admin account is seeded separately and kept for delivery notes.';

  @override
  String get settingsTitle => 'System settings';

  @override
  String get profileGuest => 'Guest';

  @override
  String get localeTitle => 'Language';

  @override
  String get themeSystem => 'System';

  @override
  String get loginInvalidCredentials => 'Username or password is incorrect.';

  @override
  String get logoutAction => 'Log out';

  @override
  String get themeLight => 'Light';

  @override
  String themeModeDescription(Object mode) {
    return 'Current mode: $mode';
  }

  @override
  String get loginHeadline => 'Sign in to your party hub';

  @override
  String get profileTab => 'Profile';

  @override
  String get profileTitle => 'User center';

  @override
  String get profileRoleAdmin => 'Administrator';

  @override
  String get localeModeSystem => 'System';

  @override
  String get localeModeChinese => 'Chinese';

  @override
  String get localeModeEnglish => 'English';

  @override
  String localeModeDescription(Object mode) {
    return 'Current language mode: $mode';
  }

  @override
  String get loginSessionExpired => 'Your session expired. Sign in again.';

  @override
  String get loginFillDemo => 'Use demo account';

  @override
  String get loginFillAdmin => 'Use admin account';

  @override
  String get loginHeroTitle =>
      'Keep accounts, rooms, and game sessions inside one shell.';

  @override
  String get loginHeroBody =>
      'The login flow now has session models, device inventory, and profile-edit boundaries, so swapping to a real backend later does not require rewriting the UI.';

  @override
  String get loginSeedPlayerTitle => 'Demo player account';

  @override
  String get loginSeedAdminTitle => 'Administrator account';

  @override
  String get guardLoginTitle => 'Login required';

  @override
  String get guardLoginBody =>
      'This page is protected by authentication. Sign in before opening it.';

  @override
  String get guardAdminTitle => 'Admin access required';

  @override
  String get guardAdminBody =>
      'This entry point is restricted to administrators. The current account does not have enough permission.';

  @override
  String get profileEditTitle => 'Edit profile';

  @override
  String get profileEditBody =>
      'Update name, bio, and avatar style. Changes write back to the active session immediately.';

  @override
  String get profileDisplayNameField => 'Display name';

  @override
  String get profileBioField => 'Bio';

  @override
  String get profileAvatarField => 'Avatar style';

  @override
  String get profileSaveAction => 'Save profile';

  @override
  String get profileSavedMessage => 'Profile updated.';

  @override
  String get profileSignedInAt => 'Signed in';

  @override
  String get profileSessionExpiry => 'Session expires';

  @override
  String profileLevel(int level) {
    return 'Lv.$level';
  }

  @override
  String get securityTitle => 'Account security';

  @override
  String get securityBody =>
      'Manage passwords, devices, and session boundaries. Sensitive values already flow through a separate storage interface so secure platform storage can replace it later.';

  @override
  String get securitySessionCardTitle => 'Current session';

  @override
  String get securitySessionId => 'Session ID';

  @override
  String get securitySessionExpiry => 'Expires at';

  @override
  String get securityStorageMode => 'Storage strategy';

  @override
  String get securityStorageModeValue =>
      'Local secret interface (dev mode), ready to swap to Keychain / Keystore';

  @override
  String get securityPasswordTitle => 'Change password';

  @override
  String get securityPasswordBody =>
      'This is still a development auth shell, but the password-change contract and error handling are already in place.';

  @override
  String get securityCurrentPassword => 'Current password';

  @override
  String get securityNextPassword => 'New password';

  @override
  String get securityPasswordAction => 'Update password';

  @override
  String get securityPasswordUpdated =>
      'Password validation passed and the dev account contract has been updated.';

  @override
  String get securityDevicesTitle => 'Signed-in devices';

  @override
  String get securityDevicesBody =>
      'The device list comes from the session repository abstraction and can later plug straight into a real risk-control backend.';

  @override
  String get securityCurrentDevice => 'Current device';

  @override
  String get securitySignOutDevice => 'Remove';

  @override
  String get securityIncorrectPassword => 'Current password is incorrect.';

  @override
  String get securityWeakPassword =>
      'New password must be at least 8 characters.';

  @override
  String get adminConsoleTitle => 'Admin console';

  @override
  String get adminConsoleBody =>
      'This is the enterprise shell for user governance, room governance, and operations configuration. Realtime admin data can replace the seeded data source later.';

  @override
  String get adminMetricUsers => 'Managed users';

  @override
  String get adminMetricRooms => 'Room pool';

  @override
  String get adminMetricIncidents => 'Open incidents';

  @override
  String get adminUsersSection => 'User governance';

  @override
  String get adminUsersBody =>
      'Handle moderation, appeals, and high-value player profiles from one place.';

  @override
  String get adminUsersItemModeration =>
      'Review recent high-risk sign-ins and suspicious nickname changes.';

  @override
  String get adminUsersItemBan =>
      'Reserve ban, unban, and audit-note workflows.';

  @override
  String get adminUsersItemSearch =>
      'Search users by UID, nickname, or device source.';

  @override
  String get adminRoomsSection => 'Room governance';

  @override
  String get adminRoomsBody =>
      'Track waiting rooms, active sessions, and abnormal rooms together.';

  @override
  String get adminRoomsItemQueue =>
      'Inspect room creation and matchmaking congestion by module.';

  @override
  String get adminRoomsItemHealth =>
      'Monitor room session sync state and successful start rate.';

  @override
  String get adminRoomsItemCapacity =>
      'Reserve capacity controls for holiday events and spikes.';

  @override
  String get adminOpsSection => 'Operations config';

  @override
  String get adminOpsBody =>
      'Centralize banners, featured slots, and feature flags in a single operations panel.';

  @override
  String get adminOpsItemConfig =>
      'Support staged rollout windows for ops configuration.';

  @override
  String get adminOpsItemBanner =>
      'Drive homepage banners and module ordering from config.';

  @override
  String get adminOpsItemFeatureFlag =>
      'Reserve entry points for module toggles and experiments.';

  @override
  String get authProviderUsernamePassword => 'Username & password';

  @override
  String shortDateTime(int year, int month, int day, int hour, int minute) {
    return '$year-$month-$day $hour:$minute';
  }
}
