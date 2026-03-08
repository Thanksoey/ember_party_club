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
  String get closeAction => 'Close';

  @override
  String get viewAbilityAction => 'View ability';

  @override
  String get viewPlan => 'View plan';

  @override
  String get playPrototype => 'Play prototype';

  @override
  String get homeHeroTitle => 'Open a room, start the party.';

  @override
  String get homeHeroBody =>
      'Bring friends into one room first, then switch between card, bluff, and party game modes as the vibe changes.';

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
  String get signalHandSubtitle =>
      'Cards fan out in one stacked hand. Tap any buried card to bring it to the top before playing it.';

  @override
  String get signalPileDraw => 'Draw Pile';

  @override
  String get signalPileDiscard => 'Discard';

  @override
  String get signalBattleConsoleTitle => 'Battle Core';

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
  String signalCardAbilityDialogTitle(Object cardTitle) {
    return '$cardTitle ability details';
  }

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
      'This room module is already wired as a local playable prototype. Starting now marks the room in-game and opens the match directly.';

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
      'Theme and language preferences are saved automatically and restored on next launch.';

  @override
  String get launchLoadingBody =>
      'Preparing rooms, modules, and session state...';

  @override
  String get loginBody =>
      'Sign in to create rooms and start matches instantly. New here? Register in one step.';

  @override
  String get profileBody =>
      'Manage account state, visual preferences, and developer-facing controls from one place.';

  @override
  String get loginUsernameLabel => 'Username';

  @override
  String get registerDisplayNameLabel => 'Display name';

  @override
  String get registerConfirmPasswordLabel => 'Confirm password';

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
  String get registerAction => 'Create account';

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
  String get registerUsernameTaken => 'This username is already taken.';

  @override
  String get registerPasswordMismatch => 'The two passwords do not match.';

  @override
  String get logoutAction => 'Log out';

  @override
  String get themeLight => 'Light';

  @override
  String themeModeDescription(Object mode) {
    return 'Current mode: $mode';
  }

  @override
  String get loginHeadline => 'Sign in and join tonight\'s party run';

  @override
  String get authModeSignIn => 'Sign in';

  @override
  String get authModeRegister => 'Register';

  @override
  String get profileTab => 'Profile';

  @override
  String get profileTitle => 'User center';

  @override
  String get profileRoleAdmin => 'Administrator';

  @override
  String get authGuideAction => 'App intro & rules';

  @override
  String get authGuideTitle => 'App Intro & Rules';

  @override
  String get authGuideIntroTitle => 'What is Ember Party Club?';

  @override
  String get authGuideIntroBody =>
      'Ember Party Club is built for group game nights. Enter one shared room, then swap play modes without breaking the session.';

  @override
  String get authGuideRulesTitle => 'Core Rules';

  @override
  String get authGuideRuleSignalTitle => 'Signal Deck Basics';

  @override
  String get authGuideRuleSignalBody =>
      'Each round, both sides pick one card. Higher effective power wins the round. Most points after the match wins.';

  @override
  String get authGuideRuleRoomTitle => 'Room Flow';

  @override
  String get authGuideRuleRoomBody =>
      'Host creates a room, configures seats and voice, then starts the game module. Session state is shared with all participants.';

  @override
  String get authGuideRuleFairTitle => 'Fair Play';

  @override
  String get authGuideRuleFairBody =>
      'Respect other players, avoid abusive language, and keep the game pace moving so everyone can participate.';

  @override
  String get headerSubtitleDiscover => 'Pick tonight\'s game mode';

  @override
  String get headerSubtitleRooms => 'Create rooms and prep the match';

  @override
  String get headerSubtitleProfile => 'Account, preferences, security';

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
  String get gameSessionTimelineTitle => 'Sync timeline';

  @override
  String get gameSessionTimelineEmpty => 'No sync event has arrived yet.';

  @override
  String get gameSessionCommandConnect => 'Connect sync channel';

  @override
  String get gameSessionCommandStartGame => 'Start match';

  @override
  String get gameSessionCommandPlayCard => 'Broadcast play';

  @override
  String get gameSessionCommandResetMatch => 'Reset match';

  @override
  String get gameSessionEventSyncConnected => 'Realtime channel connected.';

  @override
  String get gameSessionEventSyncReady =>
      'Sync ready. The room has entered multiplayer mode.';

  @override
  String gameSessionEventCommandDispatched(Object command) {
    return 'Command dispatched: $command';
  }

  @override
  String gameSessionEventCommandAcknowledged(Object command) {
    return 'Server acknowledged command: $command';
  }

  @override
  String gameSessionEventPhaseChanged(Object phase) {
    return 'Session phase switched to $phase';
  }

  @override
  String gameSessionEventParticipantSynced(int seat) {
    return 'Seat $seat completed sync.';
  }

  @override
  String gameSessionEventSignalCard(Object cardTitle) {
    return 'Round card broadcast: $cardTitle';
  }

  @override
  String get gameSessionEventMatchReset =>
      'Room match reset and ready for the next round.';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackSoundEffects => 'Sound Effects';

  @override
  String get feedbackHaptics => 'Haptics';

  @override
  String get feedbackOn => 'On';

  @override
  String get feedbackOff => 'Off';

  @override
  String get chaosIntro =>
      'Each round gives a random party challenge. Success grants points and streak multipliers.';

  @override
  String get chaosScoreLabel => 'Score';

  @override
  String get chaosStreakLabel => 'Streak';

  @override
  String get chaosBestLabel => 'Best';

  @override
  String get chaosRerollLabel => 'Reroll';

  @override
  String chaosStatusPlaying(int round) {
    return 'Round $round: complete the challenge to keep your streak bonus.';
  }

  @override
  String chaosStatusFinished(int score, int bestStreak) {
    return 'Challenge complete. Score $score, best streak $bestStreak.';
  }

  @override
  String get chaosActionSuccess => 'Success';

  @override
  String get chaosActionFail => 'Fail';

  @override
  String get chaosActionReroll => 'Reroll';

  @override
  String get chaosRoundTimeline => 'Round Timeline';

  @override
  String get chaosRoundEmpty => 'Finish one challenge to populate logs.';

  @override
  String chaosBasePointsLabel(int points) {
    return 'Base +$points';
  }

  @override
  String chaosTimerLabel(int seconds) {
    return 'Timer ${seconds}s';
  }

  @override
  String chaosRoundTitle(int round, Object title) {
    return 'Round $round - $title';
  }

  @override
  String chaosRoundSuccess(int points) {
    return 'Success, +$points points';
  }

  @override
  String get chaosRoundFailed => 'Failed, streak reset';

  @override
  String chaosStreakAfterRound(int streak) {
    return 'Streak after round: $streak';
  }

  @override
  String get chaosSummaryTitle => 'Chaos Summary';

  @override
  String chaosSummaryBody(int score, int bestStreak) {
    return 'Final score $score, best streak $bestStreak.';
  }

  @override
  String get chaosRunAgain => 'Run Again';

  @override
  String get chaosChallengeTitleMimic => 'Mirror Mimic';

  @override
  String get chaosChallengeTitleRapidQa => 'Rapid Triple';

  @override
  String get chaosChallengeTitleRhythm => 'Rhythm Relay';

  @override
  String get chaosChallengeTitleDrawAndGuess => 'Sketch Sprint';

  @override
  String get chaosChallengeTitleSoundOnly => 'Sound Only';

  @override
  String get chaosChallengeTitleFrozenPose => 'Freeze Frame';

  @override
  String get chaosChallengeTitleReverseStory => 'Reverse Story';

  @override
  String get chaosChallengeTitleEmojiSpeak => 'Emoji Translate';

  @override
  String get chaosChallengeDetailMimic =>
      'Mimic a profession for 30 seconds and get one correct guess.';

  @override
  String get chaosChallengeDetailRapidQa =>
      'Answer 3 random prompts, each within 5 seconds.';

  @override
  String get chaosChallengeDetailRhythm =>
      'Follow the clap pattern and chant correctly with no misses.';

  @override
  String get chaosChallengeDetailDrawAndGuess =>
      'Sketch a keyword in 20 seconds and have teammates guess it.';

  @override
  String get chaosChallengeDetailSoundOnly =>
      'No words from the answer, only sound effects are allowed.';

  @override
  String get chaosChallengeDetailFrozenPose =>
      'Hold a pose for 10 seconds and let teammates name the scene.';

  @override
  String get chaosChallengeDetailReverseStory =>
      'Tell the ending first, then the beginning, still making sense.';

  @override
  String get chaosChallengeDetailEmojiSpeak =>
      'Describe a movie or song title using only 3 emojis.';

  @override
  String midnightStatusPlaying(int round) {
    return 'Round $round: vote before the trail goes cold.';
  }

  @override
  String midnightStatusFinished(int playerScore, int aiScore) {
    return 'Case files closed. You $playerScore - Rival $aiScore.';
  }

  @override
  String get midnightInsightLabel => 'Insight';

  @override
  String midnightCaseLabel(Object title) {
    return 'Case: $title';
  }

  @override
  String get midnightRevealClue => 'Reveal clue';

  @override
  String get midnightSuspectsTitle => 'Suspects';

  @override
  String get midnightDossierTitle => 'Suspect Dossiers';

  @override
  String get midnightDossierSubtitle =>
      'Select a target first, then lock the vote from the case board and visible clues.';

  @override
  String midnightEvidenceProgress(Object revealed, Object total) {
    return 'Clues $revealed / $total';
  }

  @override
  String get midnightFocusLabel => 'Active Investigation Target';

  @override
  String get midnightVisibleCluesTitle => 'Visible Clues';

  @override
  String get midnightTimelineTitle => 'Investigation Timeline';

  @override
  String get midnightTimelineEmpty =>
      'No votes yet. Lock a suspect to log this round.';

  @override
  String get midnightSelectSuspect => 'Choose this suspect as your prime lead.';

  @override
  String get midnightLockVote => 'Lock vote';

  @override
  String midnightTimelineRound(int round, Object caseTitle) {
    return 'Round $round - $caseTitle';
  }

  @override
  String midnightTimelineVotes(
    Object playerVote,
    Object aiVote,
    Object culpritVote,
  ) {
    return 'You voted $playerVote; rival voted $aiVote; culprit was $culpritVote.';
  }

  @override
  String midnightTimelineResult(int playerPoints, int aiPoints) {
    return 'Points: you +$playerPoints, rival +$aiPoints.';
  }

  @override
  String get midnightResultWin => 'Investigation Dominance';

  @override
  String get midnightResultLose => 'Rival Takes the Case';

  @override
  String midnightResultScore(int playerScore, int aiScore) {
    return 'Final score: you $playerScore - rival $aiScore.';
  }

  @override
  String get midnightCaseTitleCaseA => 'Echoes in the Lantern Street';

  @override
  String get midnightCaseTitleCaseB => 'Cloud Deck Signal Theft';

  @override
  String get midnightCaseTitleCaseC => 'Harbor District Missing Cargo';

  @override
  String get midnightClueA1 =>
      'Witness heard a silver whistle near the north alley.';

  @override
  String get midnightClueA2 =>
      'A glove with dye marks was found behind the stage.';

  @override
  String get midnightClueA3 =>
      'The culprit knew the lamp schedule to avoid patrols.';

  @override
  String get midnightClueB1 =>
      'Security logs show one forged cargo badge at midnight.';

  @override
  String get midnightClueB2 =>
      'The stolen crate was too heavy for a single courier.';

  @override
  String get midnightClueB3 =>
      'A cracked comms chip points to someone in signal control.';

  @override
  String get midnightClueC1 => 'Wet boot prints came from berth C before dawn.';

  @override
  String get midnightClueC2 =>
      'The lock was opened with an old customs override code.';

  @override
  String get midnightClueC3 =>
      'Only one suspect knew the blind spot of camera seven.';

  @override
  String get midnightSuspectVex => 'Vex';

  @override
  String get midnightSuspectLyra => 'Lyra';

  @override
  String get midnightSuspectKade => 'Kade';

  @override
  String get midnightSuspectMina => 'Mina';

  @override
  String get midnightSuspectNox => 'Nox';

  @override
  String get midnightSuspectSora => 'Sora';

  @override
  String get midnightSuspectDax => 'Dax';

  @override
  String get midnightSuspectYuri => 'Yuri';

  @override
  String orbitStatusFinished(int netWorth) {
    return 'Contract complete. Final net worth: $netWorth.';
  }

  @override
  String get orbitStatusPlaying =>
      'Trade one resource each turn and stay ahead of market swings.';

  @override
  String get orbitMetricCash => 'Cash';

  @override
  String get orbitMetricNetWorth => 'Net Worth';

  @override
  String get orbitMetricCargo => 'Cargo';

  @override
  String get orbitMarketBoardTitle => 'Market Board';

  @override
  String get orbitMarketBoardSubtitle =>
      'Watch quotes and execute trades from the terminal.';

  @override
  String get orbitTerminalTitle => 'Trade Terminal';

  @override
  String get orbitTerminalSubtitle =>
      'Keep one commodity in focus while the full quote list stays ready on the right.';

  @override
  String get orbitPriceLabel => 'Quote';

  @override
  String get orbitHoldingsLabel => 'Holdings';

  @override
  String get orbitSignalHot => 'Overheated';

  @override
  String get orbitSignalStable => 'Stable';

  @override
  String get orbitSignalCool => 'Discount';

  @override
  String get orbitTimelineTitle => 'Trade Timeline';

  @override
  String get orbitTimelineEmpty =>
      'No deals yet. Buy or sell one resource to begin.';

  @override
  String orbitResourceStats(int price, int cargo) {
    return 'Price $price | Cargo $cargo';
  }

  @override
  String get orbitBuy => 'Buy';

  @override
  String get orbitSell => 'Sell';

  @override
  String orbitRoundLogTitle(
    int round,
    Object action,
    Object resource,
    int price,
  ) {
    return 'Round $round - $action $resource @ $price';
  }

  @override
  String orbitRoundLogStats(int cash, int netWorth) {
    return 'Cash $cash | Net $netWorth';
  }

  @override
  String get orbitResultTitle => 'Trade Settlement';

  @override
  String orbitResultBody(int netWorth) {
    return 'Final net worth: $netWorth';
  }

  @override
  String get orbitTradeAgain => 'Trade Again';

  @override
  String get orbitActionBuy => 'BUY';

  @override
  String get orbitActionSell => 'SELL';

  @override
  String get orbitResourceOre => 'Ore';

  @override
  String get orbitResourceCrystal => 'Crystal';

  @override
  String get orbitResourceGas => 'Gas';

  @override
  String get signalMetricBattlefield => 'Battlefield';

  @override
  String get signalMetricMomentum => 'Momentum';

  @override
  String signalFieldChip(Object suit) {
    return 'Field: $suit';
  }

  @override
  String signalMomentumChip(int playerMomentum, int rivalMomentum) {
    return 'Momentum $playerMomentum-$rivalMomentum';
  }

  @override
  String get signalBattleBonus => 'Battle +1';

  @override
  String signalMomentumBonus(int bonus) {
    return 'Momentum +$bonus';
  }

  @override
  String get howToPlayAction => 'How to play';

  @override
  String get guideReadyAction => 'Start match';

  @override
  String get guideBackAction => 'Back';

  @override
  String get guideNextAction => 'Next';

  @override
  String get guideSkipAction => 'Skip for now';

  @override
  String guideStepCounter(int current, int total) {
    return 'Step $current/$total';
  }

  @override
  String get guideSectionGoalTitle => 'Core goal';

  @override
  String get guideSectionTurnTitle => 'Turn flow';

  @override
  String get guideSectionTipsTitle => 'Winning tips';

  @override
  String get guideSectionReopenTitle => 'Open Again';

  @override
  String get guideReopenBody =>
      'If you skip now, this guide will not auto-open for the same game next time. Use the top guide icon whenever you want to reopen it.';

  @override
  String get signalGuideGoalBody =>
      'Win rounds with higher effective power. The higher total score takes the match.';

  @override
  String get signalGuideTurnBody =>
      'Play 1 card each round. Matching the battlefield suit grants +1, momentum stacks after winning rounds, and abilities resolve from the card trait.';

  @override
  String get signalGuideTipsBody =>
      'Watch the active field and your momentum. Save chain cards for same-suit turns and use counter or anchor cards to swing key rounds.';

  @override
  String get midnightGuideGoalBody =>
      'Identify the culprit before the rival does. Correct votes award points over the full case sequence.';

  @override
  String get midnightGuideTurnBody =>
      'Review revealed clues, spend insight to expose more evidence, then lock one suspect as your vote for the round.';

  @override
  String get midnightGuideTipsBody =>
      'Do not burn all insight early. Cross-check alibis, motive, and map access before committing your last vote.';

  @override
  String get orbitGuideGoalBody =>
      'Finish the contract with the highest net worth by balancing cash flow, holdings, and price swings.';

  @override
  String get orbitGuideTurnBody =>
      'Each turn you buy or sell exactly one resource. The market reprices after the action, so tempo matters as much as value.';

  @override
  String get orbitGuideTipsBody =>
      'Keep enough cash for reversals, do not overstack one commodity, and sell into peaks instead of waiting for perfect prices.';

  @override
  String get chaosGuideGoalBody =>
      'String together party challenges for score and streak bonuses before the round set ends.';

  @override
  String get chaosGuideTurnBody =>
      'Each challenge has a timer and base score. Clear it to grow streak value or fail and reset momentum.';

  @override
  String get chaosGuideTipsBody =>
      'Use rerolls on low-confidence prompts, protect an existing streak, and prioritize fast-completion tasks late in the run.';

  @override
  String get moduleReadinessLabel => 'Readiness';

  @override
  String get expandDetails => 'Expand details';

  @override
  String get collapseDetails => 'Hide details';

  @override
  String get enterAction => 'Enter';

  @override
  String shortDateTime(int year, int month, int day, int hour, int minute) {
    return '$year-$month-$day $hour:$minute';
  }
}
