import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Ember Party Club'**
  String get appTitle;

  /// No description provided for @discoverTab.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discoverTab;

  /// No description provided for @roomsTab.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get roomsTab;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get playAgain;

  /// No description provided for @viewPlan.
  ///
  /// In en, this message translates to:
  /// **'View plan'**
  String get viewPlan;

  /// No description provided for @playPrototype.
  ///
  /// In en, this message translates to:
  /// **'Play prototype'**
  String get playPrototype;

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'A mobile game hub designed for friend groups, not solo play.'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroBody.
  ///
  /// In en, this message translates to:
  /// **'The product focuses on low-latency rooms, pluggable game modules, stable voice interaction, and an enterprise-ready codebase.'**
  String get homeHeroBody;

  /// No description provided for @modulesLabel.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get modulesLabel;

  /// No description provided for @featuredLabel.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featuredLabel;

  /// No description provided for @launchStrategy.
  ///
  /// In en, this message translates to:
  /// **'Launch Strategy'**
  String get launchStrategy;

  /// No description provided for @launchBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Build the room layer first, then ship game modules on top.'**
  String get launchBannerTitle;

  /// No description provided for @launchBannerBody.
  ///
  /// In en, this message translates to:
  /// **'Once accounts, friends, team-up, voice, realtime sync, and settlement are unified, every new game becomes cheaper to ship.'**
  String get launchBannerBody;

  /// No description provided for @moduleFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Module filter'**
  String get moduleFilterTitle;

  /// No description provided for @moduleFilterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Anchor new games to the shared room layer, then expand into card, social deduction, and party play.'**
  String get moduleFilterSubtitle;

  /// No description provided for @candidateGamesTitle.
  ///
  /// In en, this message translates to:
  /// **'Candidate games'**
  String candidateGamesTitle(int count);

  /// No description provided for @candidateGamesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Showing {count} modules suitable for the first release wave.'**
  String candidateGamesSubtitle(int count);

  /// No description provided for @planningQueue.
  ///
  /// In en, this message translates to:
  /// **'{moduleName} is still in the planning queue.'**
  String planningQueue(Object moduleName);

  /// No description provided for @roomLoungeTitle.
  ///
  /// In en, this message translates to:
  /// **'Room Lounge'**
  String get roomLoungeTitle;

  /// No description provided for @roomLoungeHero.
  ///
  /// In en, this message translates to:
  /// **'Keep room creation, invites, parties, and voice inside one shared room layer.'**
  String get roomLoungeHero;

  /// No description provided for @roomLoungeBody.
  ///
  /// In en, this message translates to:
  /// **'New games then only need rules and rendering instead of rebuilding multiplayer infrastructure.'**
  String get roomLoungeBody;

  /// No description provided for @activeRoomsMetric.
  ///
  /// In en, this message translates to:
  /// **'Active rooms'**
  String get activeRoomsMetric;

  /// No description provided for @onlinePlayersMetric.
  ///
  /// In en, this message translates to:
  /// **'Players online'**
  String get onlinePlayersMetric;

  /// No description provided for @quickMatch.
  ///
  /// In en, this message translates to:
  /// **'Quick Match'**
  String get quickMatch;

  /// No description provided for @quickMatchBody.
  ///
  /// In en, this message translates to:
  /// **'Auto room find + smart fill'**
  String get quickMatchBody;

  /// No description provided for @createRoom.
  ///
  /// In en, this message translates to:
  /// **'Create Room'**
  String get createRoom;

  /// No description provided for @createRoomBody.
  ///
  /// In en, this message translates to:
  /// **'Pick a module, then configure seats and voice'**
  String get createRoomBody;

  /// No description provided for @hottestRoom.
  ///
  /// In en, this message translates to:
  /// **'Hottest room'**
  String get hottestRoom;

  /// No description provided for @activeRoomList.
  ///
  /// In en, this message translates to:
  /// **'Active rooms'**
  String get activeRoomList;

  /// No description provided for @hostLabel.
  ///
  /// In en, this message translates to:
  /// **'Host {nickname}'**
  String hostLabel(Object nickname);

  /// No description provided for @playersLabel.
  ///
  /// In en, this message translates to:
  /// **'{current}/{capacity} players'**
  String playersLabel(int current, int capacity);

  /// No description provided for @voiceOn.
  ///
  /// In en, this message translates to:
  /// **'Voice on'**
  String get voiceOn;

  /// No description provided for @ranked.
  ///
  /// In en, this message translates to:
  /// **'Ranked'**
  String get ranked;

  /// No description provided for @casual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get casual;

  /// No description provided for @signalDeckTitle.
  ///
  /// In en, this message translates to:
  /// **'Signal Deck'**
  String get signalDeckTitle;

  /// No description provided for @signalDeckSubtitle.
  ///
  /// In en, this message translates to:
  /// **'First playable card battle'**
  String get signalDeckSubtitle;

  /// No description provided for @signalDeckIntro.
  ///
  /// In en, this message translates to:
  /// **'This build already has card abilities, fixed-round rules, and a replay loop ready to plug into multiplayer rooms.'**
  String get signalDeckIntro;

  /// No description provided for @yourHand.
  ///
  /// In en, this message translates to:
  /// **'Your hand'**
  String get yourHand;

  /// No description provided for @roundLog.
  ///
  /// In en, this message translates to:
  /// **'Round log'**
  String get roundLog;

  /// No description provided for @noRoundsPlayed.
  ///
  /// In en, this message translates to:
  /// **'No rounds played yet.'**
  String get noRoundsPlayed;

  /// No description provided for @signalRoundLabel.
  ///
  /// In en, this message translates to:
  /// **'Round {round}'**
  String signalRoundLabel(int round);

  /// No description provided for @signalPowerCheck.
  ///
  /// In en, this message translates to:
  /// **'Power check: you {playerPower} / rival {rivalPower}'**
  String signalPowerCheck(int playerPower, int rivalPower);

  /// No description provided for @youLabel.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get youLabel;

  /// No description provided for @rivalLabel.
  ///
  /// In en, this message translates to:
  /// **'Pulse AI'**
  String get rivalLabel;

  /// No description provided for @roundsWon.
  ///
  /// In en, this message translates to:
  /// **'Rounds won'**
  String get roundsWon;

  /// No description provided for @matchLabel.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get matchLabel;

  /// No description provided for @youNotPlayed.
  ///
  /// In en, this message translates to:
  /// **'You have not played yet.'**
  String get youNotPlayed;

  /// No description provided for @youPlayed.
  ///
  /// In en, this message translates to:
  /// **'You played {title}'**
  String youPlayed(Object title);

  /// No description provided for @rivalWaiting.
  ///
  /// In en, this message translates to:
  /// **'Pulse AI is waiting.'**
  String get rivalWaiting;

  /// No description provided for @rivalPlayed.
  ///
  /// In en, this message translates to:
  /// **'Pulse AI played {title}'**
  String rivalPlayed(Object title);

  /// No description provided for @drawGame.
  ///
  /// In en, this message translates to:
  /// **'Draw game'**
  String get drawGame;

  /// No description provided for @winnerTakesMatch.
  ///
  /// In en, this message translates to:
  /// **'{winner} takes the match'**
  String winnerTakesMatch(Object winner);

  /// No description provided for @matchOver.
  ///
  /// In en, this message translates to:
  /// **'The match is over.'**
  String get matchOver;

  /// No description provided for @signalPowerLabel.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get signalPowerLabel;

  /// No description provided for @signalPoints.
  ///
  /// In en, this message translates to:
  /// **'{score} pts'**
  String signalPoints(int score);

  /// No description provided for @signalStatus.
  ///
  /// In en, this message translates to:
  /// **'Pick a card to open round {round} of {maxRounds}.'**
  String signalStatus(int round, int maxRounds);

  /// No description provided for @signalFinishReason.
  ///
  /// In en, this message translates to:
  /// **'Finished after {rounds} rounds. Score {playerScore}-{rivalScore}, rounds {playerRoundsWon}-{rivalRoundsWon}.'**
  String signalFinishReason(
    int rounds,
    int playerScore,
    int rivalScore,
    int playerRoundsWon,
    int rivalRoundsWon,
  );

  /// No description provided for @signalRoundPlayerWinConnector.
  ///
  /// In en, this message translates to:
  /// **'defeats {rivalCardTitle} ({rivalPower}). You gain 3 points.'**
  String signalRoundPlayerWinConnector(Object rivalCardTitle, int rivalPower);

  /// No description provided for @signalRoundRivalWinConnector.
  ///
  /// In en, this message translates to:
  /// **'defeats {playerCardTitle} ({playerPower}). Pulse AI gains 3 points.'**
  String signalRoundRivalWinConnector(Object playerCardTitle, int playerPower);

  /// No description provided for @signalRoundDrawSummary.
  ///
  /// In en, this message translates to:
  /// **'{playerCardTitle} and {rivalCardTitle} tie at {power}. Both sides gain 1 point.'**
  String signalRoundDrawSummary(
    Object playerCardTitle,
    Object rivalCardTitle,
    int power,
  );

  /// No description provided for @moduleNameSignalDeck.
  ///
  /// In en, this message translates to:
  /// **'Signal Deck'**
  String get moduleNameSignalDeck;

  /// No description provided for @moduleNameMidnightVote.
  ///
  /// In en, this message translates to:
  /// **'Midnight Vote'**
  String get moduleNameMidnightVote;

  /// No description provided for @moduleNameOrbitMerchant.
  ///
  /// In en, this message translates to:
  /// **'Orbit Merchant'**
  String get moduleNameOrbitMerchant;

  /// No description provided for @moduleNameChaosMixer.
  ///
  /// In en, this message translates to:
  /// **'Chaos Mixer'**
  String get moduleNameChaosMixer;

  /// No description provided for @moduleTaglineSignalDeck.
  ///
  /// In en, this message translates to:
  /// **'Fast-paced tactical card play'**
  String get moduleTaglineSignalDeck;

  /// No description provided for @moduleTaglineMidnightVote.
  ///
  /// In en, this message translates to:
  /// **'Social deduction with brisk votes'**
  String get moduleTaglineMidnightVote;

  /// No description provided for @moduleTaglineOrbitMerchant.
  ///
  /// In en, this message translates to:
  /// **'Mid-weight strategy trading'**
  String get moduleTaglineOrbitMerchant;

  /// No description provided for @moduleTaglineChaosMixer.
  ///
  /// In en, this message translates to:
  /// **'Party minigame collection'**
  String get moduleTaglineChaosMixer;

  /// No description provided for @moduleSummarySignalDeck.
  ///
  /// In en, this message translates to:
  /// **'A turn-based card game built around hand combos and table chemistry, designed to open party sessions fast.'**
  String get moduleSummarySignalDeck;

  /// No description provided for @moduleSummaryMidnightVote.
  ///
  /// In en, this message translates to:
  /// **'A ten-minute hidden-role loop focused on voice interaction and vote pacing.'**
  String get moduleSummaryMidnightVote;

  /// No description provided for @moduleSummaryOrbitMerchant.
  ///
  /// In en, this message translates to:
  /// **'Combines resource trading with deckbuilding for long-running rooms and seasonal ladders.'**
  String get moduleSummaryOrbitMerchant;

  /// No description provided for @moduleSummaryChaosMixer.
  ///
  /// In en, this message translates to:
  /// **'Bundles trivia, acting, drawing, and punishment wheels into one party room.'**
  String get moduleSummaryChaosMixer;

  /// No description provided for @roomTitleSignalRanked.
  ///
  /// In en, this message translates to:
  /// **'Signal Deck ranked room'**
  String get roomTitleSignalRanked;

  /// No description provided for @roomTitleChaosFriday.
  ///
  /// In en, this message translates to:
  /// **'Chaos Mixer Friday party'**
  String get roomTitleChaosFriday;

  /// No description provided for @roomTitleVoteFriends.
  ///
  /// In en, this message translates to:
  /// **'Midnight Vote friends room'**
  String get roomTitleVoteFriends;

  /// No description provided for @gameCategoryCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get gameCategoryCard;

  /// No description provided for @gameCategoryParty.
  ///
  /// In en, this message translates to:
  /// **'Party'**
  String get gameCategoryParty;

  /// No description provided for @gameCategoryBluff.
  ///
  /// In en, this message translates to:
  /// **'Bluff'**
  String get gameCategoryBluff;

  /// No description provided for @gameCategoryStrategy.
  ///
  /// In en, this message translates to:
  /// **'Strategy'**
  String get gameCategoryStrategy;

  /// No description provided for @matchTempoQuick.
  ///
  /// In en, this message translates to:
  /// **'15 min'**
  String get matchTempoQuick;

  /// No description provided for @matchTempoStandard.
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get matchTempoStandard;

  /// No description provided for @matchTempoDeep.
  ///
  /// In en, this message translates to:
  /// **'45+ min'**
  String get matchTempoDeep;

  /// No description provided for @roomStatusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get roomStatusWaiting;

  /// No description provided for @roomStatusInGame.
  ///
  /// In en, this message translates to:
  /// **'In Game'**
  String get roomStatusInGame;

  /// No description provided for @roomStatusSettling.
  ///
  /// In en, this message translates to:
  /// **'Settling'**
  String get roomStatusSettling;

  /// No description provided for @signalSuitEmber.
  ///
  /// In en, this message translates to:
  /// **'Ember'**
  String get signalSuitEmber;

  /// No description provided for @signalSuitTide.
  ///
  /// In en, this message translates to:
  /// **'Tide'**
  String get signalSuitTide;

  /// No description provided for @signalSuitSpark.
  ///
  /// In en, this message translates to:
  /// **'Spark'**
  String get signalSuitSpark;

  /// No description provided for @signalAbilityChain.
  ///
  /// In en, this message translates to:
  /// **'Chain'**
  String get signalAbilityChain;

  /// No description provided for @signalAbilityCounter.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get signalAbilityCounter;

  /// No description provided for @signalAbilitySurge.
  ///
  /// In en, this message translates to:
  /// **'Surge'**
  String get signalAbilitySurge;

  /// No description provided for @signalAbilityAnchor.
  ///
  /// In en, this message translates to:
  /// **'Anchor'**
  String get signalAbilityAnchor;

  /// No description provided for @signalCardTitleE1.
  ///
  /// In en, this message translates to:
  /// **'Flare Link'**
  String get signalCardTitleE1;

  /// No description provided for @signalCardTitleE2.
  ///
  /// In en, this message translates to:
  /// **'Ash Pulse'**
  String get signalCardTitleE2;

  /// No description provided for @signalCardTitleE3.
  ///
  /// In en, this message translates to:
  /// **'Solar Call'**
  String get signalCardTitleE3;

  /// No description provided for @signalCardTitleE4.
  ///
  /// In en, this message translates to:
  /// **'Crimson Sync'**
  String get signalCardTitleE4;

  /// No description provided for @signalCardTitleT1.
  ///
  /// In en, this message translates to:
  /// **'Ripple Mark'**
  String get signalCardTitleT1;

  /// No description provided for @signalCardTitleT2.
  ///
  /// In en, this message translates to:
  /// **'Deep Current'**
  String get signalCardTitleT2;

  /// No description provided for @signalCardTitleT3.
  ///
  /// In en, this message translates to:
  /// **'Blue Echo'**
  String get signalCardTitleT3;

  /// No description provided for @signalCardTitleT4.
  ///
  /// In en, this message translates to:
  /// **'Mist Veil'**
  String get signalCardTitleT4;

  /// No description provided for @signalCardTitleS1.
  ///
  /// In en, this message translates to:
  /// **'Volt Tap'**
  String get signalCardTitleS1;

  /// No description provided for @signalCardTitleS2.
  ///
  /// In en, this message translates to:
  /// **'Quick Circuit'**
  String get signalCardTitleS2;

  /// No description provided for @signalCardTitleS3.
  ///
  /// In en, this message translates to:
  /// **'Static Crown'**
  String get signalCardTitleS3;

  /// No description provided for @signalCardTitleS4.
  ///
  /// In en, this message translates to:
  /// **'Signal Needle'**
  String get signalCardTitleS4;

  /// No description provided for @signalCardNoteE1.
  ///
  /// In en, this message translates to:
  /// **'Chain: +2 after another Ember card.'**
  String get signalCardNoteE1;

  /// No description provided for @signalCardNoteE2.
  ///
  /// In en, this message translates to:
  /// **'Surge: +1 while trailing.'**
  String get signalCardNoteE2;

  /// No description provided for @signalCardNoteE3.
  ///
  /// In en, this message translates to:
  /// **'Chain: powerful finisher in Ember streaks.'**
  String get signalCardNoteE3;

  /// No description provided for @signalCardNoteE4.
  ///
  /// In en, this message translates to:
  /// **'Anchor: +2 into heavy rival cards.'**
  String get signalCardNoteE4;

  /// No description provided for @signalCardNoteT1.
  ///
  /// In en, this message translates to:
  /// **'Counter: +2 against Ember.'**
  String get signalCardNoteT1;

  /// No description provided for @signalCardNoteT2.
  ///
  /// In en, this message translates to:
  /// **'Anchor: +2 when absorbing stronger cards.'**
  String get signalCardNoteT2;

  /// No description provided for @signalCardNoteT3.
  ///
  /// In en, this message translates to:
  /// **'Counter: wins tempo against Ember lines.'**
  String get signalCardNoteT3;

  /// No description provided for @signalCardNoteT4.
  ///
  /// In en, this message translates to:
  /// **'Surge: +1 while trailing.'**
  String get signalCardNoteT4;

  /// No description provided for @signalCardNoteS1.
  ///
  /// In en, this message translates to:
  /// **'Surge: +1 while trailing.'**
  String get signalCardNoteS1;

  /// No description provided for @signalCardNoteS2.
  ///
  /// In en, this message translates to:
  /// **'Chain: +2 after another Spark card.'**
  String get signalCardNoteS2;

  /// No description provided for @signalCardNoteS3.
  ///
  /// In en, this message translates to:
  /// **'Surge: late-round closer when behind.'**
  String get signalCardNoteS3;

  /// No description provided for @signalCardNoteS4.
  ///
  /// In en, this message translates to:
  /// **'Anchor: +2 into heavy rival cards.'**
  String get signalCardNoteS4;

  /// No description provided for @roomDetailBody.
  ///
  /// In en, this message translates to:
  /// **'This page is the bridge between room setup and the actual game session. Start with Signal Deck, then reuse the shell for other games.'**
  String get roomDetailBody;

  /// No description provided for @roomCapacityFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Seat count'**
  String get roomCapacityFieldLabel;

  /// No description provided for @roomVoiceToggle.
  ///
  /// In en, this message translates to:
  /// **'Enable voice'**
  String get roomVoiceToggle;

  /// No description provided for @roomCreateAndEnter.
  ///
  /// In en, this message translates to:
  /// **'Create and enter'**
  String get roomCreateAndEnter;

  /// No description provided for @roomInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Room info'**
  String get roomInfoSection;

  /// No description provided for @roomUnsupportedBody.
  ///
  /// In en, this message translates to:
  /// **'This module is listed in the room layer already, but the playable session has not been wired yet.'**
  String get roomUnsupportedBody;

  /// No description provided for @roomDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Room details'**
  String get roomDetailTitle;

  /// No description provided for @roomSelectModuleLabel.
  ///
  /// In en, this message translates to:
  /// **'Game module'**
  String get roomSelectModuleLabel;

  /// No description provided for @roomModuleLabel.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get roomModuleLabel;

  /// No description provided for @roomCreateDefaultName.
  ///
  /// In en, this message translates to:
  /// **'{moduleName} room'**
  String roomCreateDefaultName(Object moduleName);

  /// No description provided for @roomSettingsSection.
  ///
  /// In en, this message translates to:
  /// **'Room settings'**
  String get roomSettingsSection;

  /// No description provided for @roomStartGame.
  ///
  /// In en, this message translates to:
  /// **'Start game'**
  String get roomStartGame;

  /// No description provided for @roomVoiceOff.
  ///
  /// In en, this message translates to:
  /// **'Voice off'**
  String get roomVoiceOff;

  /// No description provided for @roomNotFound.
  ///
  /// In en, this message translates to:
  /// **'Room not found.'**
  String get roomNotFound;

  /// No description provided for @roomCreateSheetBody.
  ///
  /// In en, this message translates to:
  /// **'Pick a module, set seats, and jump straight into a room flow that can later plug into realtime sync.'**
  String get roomCreateSheetBody;

  /// No description provided for @roomCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Room ID'**
  String get roomCodeLabel;

  /// No description provided for @roomRankedToggle.
  ///
  /// In en, this message translates to:
  /// **'Ranked room'**
  String get roomRankedToggle;

  /// No description provided for @roomStartGameBody.
  ///
  /// In en, this message translates to:
  /// **'Signal Deck is already wired as a local playable prototype. Starting now will mark the room in-game and open the match.'**
  String get roomStartGameBody;

  /// No description provided for @roomNameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Room name'**
  String get roomNameFieldLabel;

  /// No description provided for @roomCreateSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Create room'**
  String get roomCreateSheetTitle;

  /// No description provided for @quickMatchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No room is available for quick match yet.'**
  String get quickMatchEmpty;

  /// No description provided for @roomHostNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get roomHostNameLabel;

  /// No description provided for @gameSessionParticipantsLabel.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get gameSessionParticipantsLabel;

  /// No description provided for @gameSessionLocalPlayerName.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get gameSessionLocalPlayerName;

  /// No description provided for @gameSessionLocalTag.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get gameSessionLocalTag;

  /// No description provided for @gameSessionPhaseBriefing.
  ///
  /// In en, this message translates to:
  /// **'Briefing'**
  String get gameSessionPhaseBriefing;

  /// No description provided for @gameSessionSyncMultiplayerReady.
  ///
  /// In en, this message translates to:
  /// **'Ready for sync'**
  String get gameSessionSyncMultiplayerReady;

  /// No description provided for @gameSessionSyncRoomBound.
  ///
  /// In en, this message translates to:
  /// **'Room-bound'**
  String get gameSessionSyncRoomBound;

  /// No description provided for @roomSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'{roomTitle} · {moduleName}'**
  String roomSessionTitle(Object roomTitle, Object moduleName);

  /// No description provided for @gameSessionPhaseFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get gameSessionPhaseFinished;

  /// No description provided for @gameSessionRoomLabel.
  ///
  /// In en, this message translates to:
  /// **'Room session'**
  String get gameSessionRoomLabel;

  /// No description provided for @gameSessionPhasePlaying.
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get gameSessionPhasePlaying;

  /// No description provided for @gameSessionSyncLocalPreview.
  ///
  /// In en, this message translates to:
  /// **'Local preview'**
  String get gameSessionSyncLocalPreview;

  /// No description provided for @gameSessionGuestSeatName.
  ///
  /// In en, this message translates to:
  /// **'Seat {seat}'**
  String gameSessionGuestSeatName(int seat);

  /// No description provided for @gameSessionHostTag.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get gameSessionHostTag;

  /// No description provided for @gameSessionParticipantLabel.
  ///
  /// In en, this message translates to:
  /// **'{name} · Seat {seat}'**
  String gameSessionParticipantLabel(int seat, Object name);

  /// No description provided for @signalDeckRoomSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Room-bound card battle session'**
  String get signalDeckRoomSubtitle;

  /// No description provided for @gameSessionSyncLabel.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get gameSessionSyncLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @settingsBody.
  ///
  /// In en, this message translates to:
  /// **'Theme mode is already wired globally and persists across launches.'**
  String get settingsBody;

  /// No description provided for @launchLoadingBody.
  ///
  /// In en, this message translates to:
  /// **'Preparing rooms, modules, and session state...'**
  String get launchLoadingBody;

  /// No description provided for @loginBody.
  ///
  /// In en, this message translates to:
  /// **'Use a seeded local account first. Once the auth shell is stable, replacing it with a real backend becomes straightforward.'**
  String get loginBody;

  /// No description provided for @profileBody.
  ///
  /// In en, this message translates to:
  /// **'Manage account state, visual preferences, and developer-facing controls from one place.'**
  String get profileBody;

  /// No description provided for @loginUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get loginUsernameLabel;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeTitle;

  /// No description provided for @profileRolePlayer.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get profileRolePlayer;

  /// No description provided for @localeBody.
  ///
  /// In en, this message translates to:
  /// **'Default is Chinese. If the system language is English, the app switches automatically.'**
  String get localeBody;

  /// No description provided for @loginAction.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginAction;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @loginDemoHint.
  ///
  /// In en, this message translates to:
  /// **'Default demo account is pre-filled for quick development. Admin account is seeded separately and kept for delivery notes.'**
  String get loginDemoHint;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'System settings'**
  String get settingsTitle;

  /// No description provided for @profileGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get profileGuest;

  /// No description provided for @localeTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get localeTitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @loginInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Username or password is incorrect.'**
  String get loginInvalidCredentials;

  /// No description provided for @logoutAction.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutAction;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Current mode: {mode}'**
  String themeModeDescription(Object mode);

  /// No description provided for @loginHeadline.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your party hub'**
  String get loginHeadline;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'User center'**
  String get profileTitle;

  /// No description provided for @profileRoleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get profileRoleAdmin;

  /// No description provided for @localeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get localeModeSystem;

  /// No description provided for @localeModeChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get localeModeChinese;

  /// No description provided for @localeModeEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get localeModeEnglish;

  /// No description provided for @localeModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Current language mode: {mode}'**
  String localeModeDescription(Object mode);

  /// No description provided for @loginSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Sign in again.'**
  String get loginSessionExpired;

  /// No description provided for @loginFillDemo.
  ///
  /// In en, this message translates to:
  /// **'Use demo account'**
  String get loginFillDemo;

  /// No description provided for @loginFillAdmin.
  ///
  /// In en, this message translates to:
  /// **'Use admin account'**
  String get loginFillAdmin;

  /// No description provided for @loginHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep accounts, rooms, and game sessions inside one shell.'**
  String get loginHeroTitle;

  /// No description provided for @loginHeroBody.
  ///
  /// In en, this message translates to:
  /// **'The login flow now has session models, device inventory, and profile-edit boundaries, so swapping to a real backend later does not require rewriting the UI.'**
  String get loginHeroBody;

  /// No description provided for @loginSeedPlayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo player account'**
  String get loginSeedPlayerTitle;

  /// No description provided for @loginSeedAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Administrator account'**
  String get loginSeedAdminTitle;

  /// No description provided for @guardLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login required'**
  String get guardLoginTitle;

  /// No description provided for @guardLoginBody.
  ///
  /// In en, this message translates to:
  /// **'This page is protected by authentication. Sign in before opening it.'**
  String get guardLoginBody;

  /// No description provided for @guardAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin access required'**
  String get guardAdminTitle;

  /// No description provided for @guardAdminBody.
  ///
  /// In en, this message translates to:
  /// **'This entry point is restricted to administrators. The current account does not have enough permission.'**
  String get guardAdminBody;

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEditTitle;

  /// No description provided for @profileEditBody.
  ///
  /// In en, this message translates to:
  /// **'Update name, bio, and avatar style. Changes write back to the active session immediately.'**
  String get profileEditBody;

  /// No description provided for @profileDisplayNameField.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get profileDisplayNameField;

  /// No description provided for @profileBioField.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get profileBioField;

  /// No description provided for @profileAvatarField.
  ///
  /// In en, this message translates to:
  /// **'Avatar style'**
  String get profileAvatarField;

  /// No description provided for @profileSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get profileSaveAction;

  /// No description provided for @profileSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile updated.'**
  String get profileSavedMessage;

  /// No description provided for @profileSignedInAt.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get profileSignedInAt;

  /// No description provided for @profileSessionExpiry.
  ///
  /// In en, this message translates to:
  /// **'Session expires'**
  String get profileSessionExpiry;

  /// No description provided for @profileLevel.
  ///
  /// In en, this message translates to:
  /// **'Lv.{level}'**
  String profileLevel(int level);

  /// No description provided for @securityTitle.
  ///
  /// In en, this message translates to:
  /// **'Account security'**
  String get securityTitle;

  /// No description provided for @securityBody.
  ///
  /// In en, this message translates to:
  /// **'Manage passwords, devices, and session boundaries. Sensitive values already flow through a separate storage interface so secure platform storage can replace it later.'**
  String get securityBody;

  /// No description provided for @securitySessionCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Current session'**
  String get securitySessionCardTitle;

  /// No description provided for @securitySessionId.
  ///
  /// In en, this message translates to:
  /// **'Session ID'**
  String get securitySessionId;

  /// No description provided for @securitySessionExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expires at'**
  String get securitySessionExpiry;

  /// No description provided for @securityStorageMode.
  ///
  /// In en, this message translates to:
  /// **'Storage strategy'**
  String get securityStorageMode;

  /// No description provided for @securityStorageModeValue.
  ///
  /// In en, this message translates to:
  /// **'Local secret interface (dev mode), ready to swap to Keychain / Keystore'**
  String get securityStorageModeValue;

  /// No description provided for @securityPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get securityPasswordTitle;

  /// No description provided for @securityPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'This is still a development auth shell, but the password-change contract and error handling are already in place.'**
  String get securityPasswordBody;

  /// No description provided for @securityCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get securityCurrentPassword;

  /// No description provided for @securityNextPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get securityNextPassword;

  /// No description provided for @securityPasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get securityPasswordAction;

  /// No description provided for @securityPasswordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password validation passed and the dev account contract has been updated.'**
  String get securityPasswordUpdated;

  /// No description provided for @securityDevicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Signed-in devices'**
  String get securityDevicesTitle;

  /// No description provided for @securityDevicesBody.
  ///
  /// In en, this message translates to:
  /// **'The device list comes from the session repository abstraction and can later plug straight into a real risk-control backend.'**
  String get securityDevicesBody;

  /// No description provided for @securityCurrentDevice.
  ///
  /// In en, this message translates to:
  /// **'Current device'**
  String get securityCurrentDevice;

  /// No description provided for @securitySignOutDevice.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get securitySignOutDevice;

  /// No description provided for @securityIncorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect.'**
  String get securityIncorrectPassword;

  /// No description provided for @securityWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'New password must be at least 8 characters.'**
  String get securityWeakPassword;

  /// No description provided for @adminConsoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin console'**
  String get adminConsoleTitle;

  /// No description provided for @adminConsoleBody.
  ///
  /// In en, this message translates to:
  /// **'This is the enterprise shell for user governance, room governance, and operations configuration. Realtime admin data can replace the seeded data source later.'**
  String get adminConsoleBody;

  /// No description provided for @adminMetricUsers.
  ///
  /// In en, this message translates to:
  /// **'Managed users'**
  String get adminMetricUsers;

  /// No description provided for @adminMetricRooms.
  ///
  /// In en, this message translates to:
  /// **'Room pool'**
  String get adminMetricRooms;

  /// No description provided for @adminMetricIncidents.
  ///
  /// In en, this message translates to:
  /// **'Open incidents'**
  String get adminMetricIncidents;

  /// No description provided for @adminUsersSection.
  ///
  /// In en, this message translates to:
  /// **'User governance'**
  String get adminUsersSection;

  /// No description provided for @adminUsersBody.
  ///
  /// In en, this message translates to:
  /// **'Handle moderation, appeals, and high-value player profiles from one place.'**
  String get adminUsersBody;

  /// No description provided for @adminUsersItemModeration.
  ///
  /// In en, this message translates to:
  /// **'Review recent high-risk sign-ins and suspicious nickname changes.'**
  String get adminUsersItemModeration;

  /// No description provided for @adminUsersItemBan.
  ///
  /// In en, this message translates to:
  /// **'Reserve ban, unban, and audit-note workflows.'**
  String get adminUsersItemBan;

  /// No description provided for @adminUsersItemSearch.
  ///
  /// In en, this message translates to:
  /// **'Search users by UID, nickname, or device source.'**
  String get adminUsersItemSearch;

  /// No description provided for @adminRoomsSection.
  ///
  /// In en, this message translates to:
  /// **'Room governance'**
  String get adminRoomsSection;

  /// No description provided for @adminRoomsBody.
  ///
  /// In en, this message translates to:
  /// **'Track waiting rooms, active sessions, and abnormal rooms together.'**
  String get adminRoomsBody;

  /// No description provided for @adminRoomsItemQueue.
  ///
  /// In en, this message translates to:
  /// **'Inspect room creation and matchmaking congestion by module.'**
  String get adminRoomsItemQueue;

  /// No description provided for @adminRoomsItemHealth.
  ///
  /// In en, this message translates to:
  /// **'Monitor room session sync state and successful start rate.'**
  String get adminRoomsItemHealth;

  /// No description provided for @adminRoomsItemCapacity.
  ///
  /// In en, this message translates to:
  /// **'Reserve capacity controls for holiday events and spikes.'**
  String get adminRoomsItemCapacity;

  /// No description provided for @adminOpsSection.
  ///
  /// In en, this message translates to:
  /// **'Operations config'**
  String get adminOpsSection;

  /// No description provided for @adminOpsBody.
  ///
  /// In en, this message translates to:
  /// **'Centralize banners, featured slots, and feature flags in a single operations panel.'**
  String get adminOpsBody;

  /// No description provided for @adminOpsItemConfig.
  ///
  /// In en, this message translates to:
  /// **'Support staged rollout windows for ops configuration.'**
  String get adminOpsItemConfig;

  /// No description provided for @adminOpsItemBanner.
  ///
  /// In en, this message translates to:
  /// **'Drive homepage banners and module ordering from config.'**
  String get adminOpsItemBanner;

  /// No description provided for @adminOpsItemFeatureFlag.
  ///
  /// In en, this message translates to:
  /// **'Reserve entry points for module toggles and experiments.'**
  String get adminOpsItemFeatureFlag;

  /// No description provided for @authProviderUsernamePassword.
  ///
  /// In en, this message translates to:
  /// **'Username & password'**
  String get authProviderUsernamePassword;

  /// No description provided for @shortDateTime.
  ///
  /// In en, this message translates to:
  /// **'{year}-{month}-{day} {hour}:{minute}'**
  String shortDateTime(int year, int month, int day, int hour, int minute);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
