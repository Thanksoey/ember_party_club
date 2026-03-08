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

  /// No description provided for @closeAction.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeAction;

  /// No description provided for @viewAbilityAction.
  ///
  /// In en, this message translates to:
  /// **'View ability'**
  String get viewAbilityAction;

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
  /// **'Open a room, start the party.'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Bring friends into one room first, then switch between card, bluff, and party game modes as the vibe changes.'**
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

  /// No description provided for @signalHandSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cards fan out in one stacked hand. Tap any buried card to bring it to the top before playing it.'**
  String get signalHandSubtitle;

  /// No description provided for @signalPileDraw.
  ///
  /// In en, this message translates to:
  /// **'Draw Pile'**
  String get signalPileDraw;

  /// No description provided for @signalPileDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get signalPileDiscard;

  /// No description provided for @signalBattleConsoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Battle Core'**
  String get signalBattleConsoleTitle;

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

  /// No description provided for @signalCardAbilityDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'{cardTitle} ability details'**
  String signalCardAbilityDialogTitle(Object cardTitle);

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
  /// **'This room module is already wired as a local playable prototype. Starting now marks the room in-game and opens the match directly.'**
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
  /// **'Theme and language preferences are saved automatically and restored on next launch.'**
  String get settingsBody;

  /// No description provided for @launchLoadingBody.
  ///
  /// In en, this message translates to:
  /// **'Preparing rooms, modules, and session state...'**
  String get launchLoadingBody;

  /// No description provided for @loginBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in to create rooms and start matches instantly. New here? Register in one step.'**
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

  /// No description provided for @registerDisplayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get registerDisplayNameLabel;

  /// No description provided for @registerConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get registerConfirmPasswordLabel;

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

  /// No description provided for @registerAction.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerAction;

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

  /// No description provided for @registerUsernameTaken.
  ///
  /// In en, this message translates to:
  /// **'This username is already taken.'**
  String get registerUsernameTaken;

  /// No description provided for @registerPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'The two passwords do not match.'**
  String get registerPasswordMismatch;

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
  /// **'Sign in and join tonight\'s party run'**
  String get loginHeadline;

  /// No description provided for @authModeSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authModeSignIn;

  /// No description provided for @authModeRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authModeRegister;

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

  /// No description provided for @authGuideAction.
  ///
  /// In en, this message translates to:
  /// **'App intro & rules'**
  String get authGuideAction;

  /// No description provided for @authGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'App Intro & Rules'**
  String get authGuideTitle;

  /// No description provided for @authGuideIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'What is Ember Party Club?'**
  String get authGuideIntroTitle;

  /// No description provided for @authGuideIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Ember Party Club is built for group game nights. Enter one shared room, then swap play modes without breaking the session.'**
  String get authGuideIntroBody;

  /// No description provided for @authGuideRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Core Rules'**
  String get authGuideRulesTitle;

  /// No description provided for @authGuideRuleSignalTitle.
  ///
  /// In en, this message translates to:
  /// **'Signal Deck Basics'**
  String get authGuideRuleSignalTitle;

  /// No description provided for @authGuideRuleSignalBody.
  ///
  /// In en, this message translates to:
  /// **'Each round, both sides pick one card. Higher effective power wins the round. Most points after the match wins.'**
  String get authGuideRuleSignalBody;

  /// No description provided for @authGuideRuleRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Room Flow'**
  String get authGuideRuleRoomTitle;

  /// No description provided for @authGuideRuleRoomBody.
  ///
  /// In en, this message translates to:
  /// **'Host creates a room, configures seats and voice, then starts the game module. Session state is shared with all participants.'**
  String get authGuideRuleRoomBody;

  /// No description provided for @authGuideRuleFairTitle.
  ///
  /// In en, this message translates to:
  /// **'Fair Play'**
  String get authGuideRuleFairTitle;

  /// No description provided for @authGuideRuleFairBody.
  ///
  /// In en, this message translates to:
  /// **'Respect other players, avoid abusive language, and keep the game pace moving so everyone can participate.'**
  String get authGuideRuleFairBody;

  /// No description provided for @headerSubtitleDiscover.
  ///
  /// In en, this message translates to:
  /// **'Pick tonight\'s game mode'**
  String get headerSubtitleDiscover;

  /// No description provided for @headerSubtitleRooms.
  ///
  /// In en, this message translates to:
  /// **'Create rooms and prep the match'**
  String get headerSubtitleRooms;

  /// No description provided for @headerSubtitleProfile.
  ///
  /// In en, this message translates to:
  /// **'Account, preferences, security'**
  String get headerSubtitleProfile;

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

  /// No description provided for @gameSessionTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync timeline'**
  String get gameSessionTimelineTitle;

  /// No description provided for @gameSessionTimelineEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sync event has arrived yet.'**
  String get gameSessionTimelineEmpty;

  /// No description provided for @gameSessionCommandConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect sync channel'**
  String get gameSessionCommandConnect;

  /// No description provided for @gameSessionCommandStartGame.
  ///
  /// In en, this message translates to:
  /// **'Start match'**
  String get gameSessionCommandStartGame;

  /// No description provided for @gameSessionCommandPlayCard.
  ///
  /// In en, this message translates to:
  /// **'Broadcast play'**
  String get gameSessionCommandPlayCard;

  /// No description provided for @gameSessionCommandResetMatch.
  ///
  /// In en, this message translates to:
  /// **'Reset match'**
  String get gameSessionCommandResetMatch;

  /// No description provided for @gameSessionEventSyncConnected.
  ///
  /// In en, this message translates to:
  /// **'Realtime channel connected.'**
  String get gameSessionEventSyncConnected;

  /// No description provided for @gameSessionEventSyncReady.
  ///
  /// In en, this message translates to:
  /// **'Sync ready. The room has entered multiplayer mode.'**
  String get gameSessionEventSyncReady;

  /// No description provided for @gameSessionEventCommandDispatched.
  ///
  /// In en, this message translates to:
  /// **'Command dispatched: {command}'**
  String gameSessionEventCommandDispatched(Object command);

  /// No description provided for @gameSessionEventCommandAcknowledged.
  ///
  /// In en, this message translates to:
  /// **'Server acknowledged command: {command}'**
  String gameSessionEventCommandAcknowledged(Object command);

  /// No description provided for @gameSessionEventPhaseChanged.
  ///
  /// In en, this message translates to:
  /// **'Session phase switched to {phase}'**
  String gameSessionEventPhaseChanged(Object phase);

  /// No description provided for @gameSessionEventParticipantSynced.
  ///
  /// In en, this message translates to:
  /// **'Seat {seat} completed sync.'**
  String gameSessionEventParticipantSynced(int seat);

  /// No description provided for @gameSessionEventSignalCard.
  ///
  /// In en, this message translates to:
  /// **'Round card broadcast: {cardTitle}'**
  String gameSessionEventSignalCard(Object cardTitle);

  /// No description provided for @gameSessionEventMatchReset.
  ///
  /// In en, this message translates to:
  /// **'Room match reset and ready for the next round.'**
  String get gameSessionEventMatchReset;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackTitle;

  /// No description provided for @feedbackSoundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get feedbackSoundEffects;

  /// No description provided for @feedbackHaptics.
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get feedbackHaptics;

  /// No description provided for @feedbackOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get feedbackOn;

  /// No description provided for @feedbackOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get feedbackOff;

  /// No description provided for @chaosIntro.
  ///
  /// In en, this message translates to:
  /// **'Each round gives a random party challenge. Success grants points and streak multipliers.'**
  String get chaosIntro;

  /// No description provided for @chaosScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get chaosScoreLabel;

  /// No description provided for @chaosStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get chaosStreakLabel;

  /// No description provided for @chaosBestLabel.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get chaosBestLabel;

  /// No description provided for @chaosRerollLabel.
  ///
  /// In en, this message translates to:
  /// **'Reroll'**
  String get chaosRerollLabel;

  /// No description provided for @chaosStatusPlaying.
  ///
  /// In en, this message translates to:
  /// **'Round {round}: complete the challenge to keep your streak bonus.'**
  String chaosStatusPlaying(int round);

  /// No description provided for @chaosStatusFinished.
  ///
  /// In en, this message translates to:
  /// **'Challenge complete. Score {score}, best streak {bestStreak}.'**
  String chaosStatusFinished(int score, int bestStreak);

  /// No description provided for @chaosActionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get chaosActionSuccess;

  /// No description provided for @chaosActionFail.
  ///
  /// In en, this message translates to:
  /// **'Fail'**
  String get chaosActionFail;

  /// No description provided for @chaosActionReroll.
  ///
  /// In en, this message translates to:
  /// **'Reroll'**
  String get chaosActionReroll;

  /// No description provided for @chaosRoundTimeline.
  ///
  /// In en, this message translates to:
  /// **'Round Timeline'**
  String get chaosRoundTimeline;

  /// No description provided for @chaosRoundEmpty.
  ///
  /// In en, this message translates to:
  /// **'Finish one challenge to populate logs.'**
  String get chaosRoundEmpty;

  /// No description provided for @chaosBasePointsLabel.
  ///
  /// In en, this message translates to:
  /// **'Base +{points}'**
  String chaosBasePointsLabel(int points);

  /// No description provided for @chaosTimerLabel.
  ///
  /// In en, this message translates to:
  /// **'Timer {seconds}s'**
  String chaosTimerLabel(int seconds);

  /// No description provided for @chaosRoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Round {round} - {title}'**
  String chaosRoundTitle(int round, Object title);

  /// No description provided for @chaosRoundSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success, +{points} points'**
  String chaosRoundSuccess(int points);

  /// No description provided for @chaosRoundFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed, streak reset'**
  String get chaosRoundFailed;

  /// No description provided for @chaosStreakAfterRound.
  ///
  /// In en, this message translates to:
  /// **'Streak after round: {streak}'**
  String chaosStreakAfterRound(int streak);

  /// No description provided for @chaosSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Chaos Summary'**
  String get chaosSummaryTitle;

  /// No description provided for @chaosSummaryBody.
  ///
  /// In en, this message translates to:
  /// **'Final score {score}, best streak {bestStreak}.'**
  String chaosSummaryBody(int score, int bestStreak);

  /// No description provided for @chaosRunAgain.
  ///
  /// In en, this message translates to:
  /// **'Run Again'**
  String get chaosRunAgain;

  /// No description provided for @chaosChallengeTitleMimic.
  ///
  /// In en, this message translates to:
  /// **'Mirror Mimic'**
  String get chaosChallengeTitleMimic;

  /// No description provided for @chaosChallengeTitleRapidQa.
  ///
  /// In en, this message translates to:
  /// **'Rapid Triple'**
  String get chaosChallengeTitleRapidQa;

  /// No description provided for @chaosChallengeTitleRhythm.
  ///
  /// In en, this message translates to:
  /// **'Rhythm Relay'**
  String get chaosChallengeTitleRhythm;

  /// No description provided for @chaosChallengeTitleDrawAndGuess.
  ///
  /// In en, this message translates to:
  /// **'Sketch Sprint'**
  String get chaosChallengeTitleDrawAndGuess;

  /// No description provided for @chaosChallengeTitleSoundOnly.
  ///
  /// In en, this message translates to:
  /// **'Sound Only'**
  String get chaosChallengeTitleSoundOnly;

  /// No description provided for @chaosChallengeTitleFrozenPose.
  ///
  /// In en, this message translates to:
  /// **'Freeze Frame'**
  String get chaosChallengeTitleFrozenPose;

  /// No description provided for @chaosChallengeTitleReverseStory.
  ///
  /// In en, this message translates to:
  /// **'Reverse Story'**
  String get chaosChallengeTitleReverseStory;

  /// No description provided for @chaosChallengeTitleEmojiSpeak.
  ///
  /// In en, this message translates to:
  /// **'Emoji Translate'**
  String get chaosChallengeTitleEmojiSpeak;

  /// No description provided for @chaosChallengeDetailMimic.
  ///
  /// In en, this message translates to:
  /// **'Mimic a profession for 30 seconds and get one correct guess.'**
  String get chaosChallengeDetailMimic;

  /// No description provided for @chaosChallengeDetailRapidQa.
  ///
  /// In en, this message translates to:
  /// **'Answer 3 random prompts, each within 5 seconds.'**
  String get chaosChallengeDetailRapidQa;

  /// No description provided for @chaosChallengeDetailRhythm.
  ///
  /// In en, this message translates to:
  /// **'Follow the clap pattern and chant correctly with no misses.'**
  String get chaosChallengeDetailRhythm;

  /// No description provided for @chaosChallengeDetailDrawAndGuess.
  ///
  /// In en, this message translates to:
  /// **'Sketch a keyword in 20 seconds and have teammates guess it.'**
  String get chaosChallengeDetailDrawAndGuess;

  /// No description provided for @chaosChallengeDetailSoundOnly.
  ///
  /// In en, this message translates to:
  /// **'No words from the answer, only sound effects are allowed.'**
  String get chaosChallengeDetailSoundOnly;

  /// No description provided for @chaosChallengeDetailFrozenPose.
  ///
  /// In en, this message translates to:
  /// **'Hold a pose for 10 seconds and let teammates name the scene.'**
  String get chaosChallengeDetailFrozenPose;

  /// No description provided for @chaosChallengeDetailReverseStory.
  ///
  /// In en, this message translates to:
  /// **'Tell the ending first, then the beginning, still making sense.'**
  String get chaosChallengeDetailReverseStory;

  /// No description provided for @chaosChallengeDetailEmojiSpeak.
  ///
  /// In en, this message translates to:
  /// **'Describe a movie or song title using only 3 emojis.'**
  String get chaosChallengeDetailEmojiSpeak;

  /// No description provided for @midnightStatusPlaying.
  ///
  /// In en, this message translates to:
  /// **'Round {round}: vote before the trail goes cold.'**
  String midnightStatusPlaying(int round);

  /// No description provided for @midnightStatusFinished.
  ///
  /// In en, this message translates to:
  /// **'Case files closed. You {playerScore} - Rival {aiScore}.'**
  String midnightStatusFinished(int playerScore, int aiScore);

  /// No description provided for @midnightInsightLabel.
  ///
  /// In en, this message translates to:
  /// **'Insight'**
  String get midnightInsightLabel;

  /// No description provided for @midnightCaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Case: {title}'**
  String midnightCaseLabel(Object title);

  /// No description provided for @midnightRevealClue.
  ///
  /// In en, this message translates to:
  /// **'Reveal clue'**
  String get midnightRevealClue;

  /// No description provided for @midnightSuspectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Suspects'**
  String get midnightSuspectsTitle;

  /// No description provided for @midnightDossierTitle.
  ///
  /// In en, this message translates to:
  /// **'Suspect Dossiers'**
  String get midnightDossierTitle;

  /// No description provided for @midnightDossierSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select a target first, then lock the vote from the case board and visible clues.'**
  String get midnightDossierSubtitle;

  /// No description provided for @midnightEvidenceProgress.
  ///
  /// In en, this message translates to:
  /// **'Clues {revealed} / {total}'**
  String midnightEvidenceProgress(Object revealed, Object total);

  /// No description provided for @midnightFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'Active Investigation Target'**
  String get midnightFocusLabel;

  /// No description provided for @midnightVisibleCluesTitle.
  ///
  /// In en, this message translates to:
  /// **'Visible Clues'**
  String get midnightVisibleCluesTitle;

  /// No description provided for @midnightTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Investigation Timeline'**
  String get midnightTimelineTitle;

  /// No description provided for @midnightTimelineEmpty.
  ///
  /// In en, this message translates to:
  /// **'No votes yet. Lock a suspect to log this round.'**
  String get midnightTimelineEmpty;

  /// No description provided for @midnightSelectSuspect.
  ///
  /// In en, this message translates to:
  /// **'Choose this suspect as your prime lead.'**
  String get midnightSelectSuspect;

  /// No description provided for @midnightLockVote.
  ///
  /// In en, this message translates to:
  /// **'Lock vote'**
  String get midnightLockVote;

  /// No description provided for @midnightTimelineRound.
  ///
  /// In en, this message translates to:
  /// **'Round {round} - {caseTitle}'**
  String midnightTimelineRound(int round, Object caseTitle);

  /// No description provided for @midnightTimelineVotes.
  ///
  /// In en, this message translates to:
  /// **'You voted {playerVote}; rival voted {aiVote}; culprit was {culpritVote}.'**
  String midnightTimelineVotes(
    Object playerVote,
    Object aiVote,
    Object culpritVote,
  );

  /// No description provided for @midnightTimelineResult.
  ///
  /// In en, this message translates to:
  /// **'Points: you +{playerPoints}, rival +{aiPoints}.'**
  String midnightTimelineResult(int playerPoints, int aiPoints);

  /// No description provided for @midnightResultWin.
  ///
  /// In en, this message translates to:
  /// **'Investigation Dominance'**
  String get midnightResultWin;

  /// No description provided for @midnightResultLose.
  ///
  /// In en, this message translates to:
  /// **'Rival Takes the Case'**
  String get midnightResultLose;

  /// No description provided for @midnightResultScore.
  ///
  /// In en, this message translates to:
  /// **'Final score: you {playerScore} - rival {aiScore}.'**
  String midnightResultScore(int playerScore, int aiScore);

  /// No description provided for @midnightCaseTitleCaseA.
  ///
  /// In en, this message translates to:
  /// **'Echoes in the Lantern Street'**
  String get midnightCaseTitleCaseA;

  /// No description provided for @midnightCaseTitleCaseB.
  ///
  /// In en, this message translates to:
  /// **'Cloud Deck Signal Theft'**
  String get midnightCaseTitleCaseB;

  /// No description provided for @midnightCaseTitleCaseC.
  ///
  /// In en, this message translates to:
  /// **'Harbor District Missing Cargo'**
  String get midnightCaseTitleCaseC;

  /// No description provided for @midnightClueA1.
  ///
  /// In en, this message translates to:
  /// **'Witness heard a silver whistle near the north alley.'**
  String get midnightClueA1;

  /// No description provided for @midnightClueA2.
  ///
  /// In en, this message translates to:
  /// **'A glove with dye marks was found behind the stage.'**
  String get midnightClueA2;

  /// No description provided for @midnightClueA3.
  ///
  /// In en, this message translates to:
  /// **'The culprit knew the lamp schedule to avoid patrols.'**
  String get midnightClueA3;

  /// No description provided for @midnightClueB1.
  ///
  /// In en, this message translates to:
  /// **'Security logs show one forged cargo badge at midnight.'**
  String get midnightClueB1;

  /// No description provided for @midnightClueB2.
  ///
  /// In en, this message translates to:
  /// **'The stolen crate was too heavy for a single courier.'**
  String get midnightClueB2;

  /// No description provided for @midnightClueB3.
  ///
  /// In en, this message translates to:
  /// **'A cracked comms chip points to someone in signal control.'**
  String get midnightClueB3;

  /// No description provided for @midnightClueC1.
  ///
  /// In en, this message translates to:
  /// **'Wet boot prints came from berth C before dawn.'**
  String get midnightClueC1;

  /// No description provided for @midnightClueC2.
  ///
  /// In en, this message translates to:
  /// **'The lock was opened with an old customs override code.'**
  String get midnightClueC2;

  /// No description provided for @midnightClueC3.
  ///
  /// In en, this message translates to:
  /// **'Only one suspect knew the blind spot of camera seven.'**
  String get midnightClueC3;

  /// No description provided for @midnightSuspectVex.
  ///
  /// In en, this message translates to:
  /// **'Vex'**
  String get midnightSuspectVex;

  /// No description provided for @midnightSuspectLyra.
  ///
  /// In en, this message translates to:
  /// **'Lyra'**
  String get midnightSuspectLyra;

  /// No description provided for @midnightSuspectKade.
  ///
  /// In en, this message translates to:
  /// **'Kade'**
  String get midnightSuspectKade;

  /// No description provided for @midnightSuspectMina.
  ///
  /// In en, this message translates to:
  /// **'Mina'**
  String get midnightSuspectMina;

  /// No description provided for @midnightSuspectNox.
  ///
  /// In en, this message translates to:
  /// **'Nox'**
  String get midnightSuspectNox;

  /// No description provided for @midnightSuspectSora.
  ///
  /// In en, this message translates to:
  /// **'Sora'**
  String get midnightSuspectSora;

  /// No description provided for @midnightSuspectDax.
  ///
  /// In en, this message translates to:
  /// **'Dax'**
  String get midnightSuspectDax;

  /// No description provided for @midnightSuspectYuri.
  ///
  /// In en, this message translates to:
  /// **'Yuri'**
  String get midnightSuspectYuri;

  /// No description provided for @orbitStatusFinished.
  ///
  /// In en, this message translates to:
  /// **'Contract complete. Final net worth: {netWorth}.'**
  String orbitStatusFinished(int netWorth);

  /// No description provided for @orbitStatusPlaying.
  ///
  /// In en, this message translates to:
  /// **'Trade one resource each turn and stay ahead of market swings.'**
  String get orbitStatusPlaying;

  /// No description provided for @orbitMetricCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get orbitMetricCash;

  /// No description provided for @orbitMetricNetWorth.
  ///
  /// In en, this message translates to:
  /// **'Net Worth'**
  String get orbitMetricNetWorth;

  /// No description provided for @orbitMetricCargo.
  ///
  /// In en, this message translates to:
  /// **'Cargo'**
  String get orbitMetricCargo;

  /// No description provided for @orbitMarketBoardTitle.
  ///
  /// In en, this message translates to:
  /// **'Market Board'**
  String get orbitMarketBoardTitle;

  /// No description provided for @orbitMarketBoardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Watch quotes and execute trades from the terminal.'**
  String get orbitMarketBoardSubtitle;

  /// No description provided for @orbitTerminalTitle.
  ///
  /// In en, this message translates to:
  /// **'Trade Terminal'**
  String get orbitTerminalTitle;

  /// No description provided for @orbitTerminalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep one commodity in focus while the full quote list stays ready on the right.'**
  String get orbitTerminalSubtitle;

  /// No description provided for @orbitPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Quote'**
  String get orbitPriceLabel;

  /// No description provided for @orbitHoldingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Holdings'**
  String get orbitHoldingsLabel;

  /// No description provided for @orbitSignalHot.
  ///
  /// In en, this message translates to:
  /// **'Overheated'**
  String get orbitSignalHot;

  /// No description provided for @orbitSignalStable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get orbitSignalStable;

  /// No description provided for @orbitSignalCool.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get orbitSignalCool;

  /// No description provided for @orbitTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Trade Timeline'**
  String get orbitTimelineTitle;

  /// No description provided for @orbitTimelineEmpty.
  ///
  /// In en, this message translates to:
  /// **'No deals yet. Buy or sell one resource to begin.'**
  String get orbitTimelineEmpty;

  /// No description provided for @orbitResourceStats.
  ///
  /// In en, this message translates to:
  /// **'Price {price} | Cargo {cargo}'**
  String orbitResourceStats(int price, int cargo);

  /// No description provided for @orbitBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get orbitBuy;

  /// No description provided for @orbitSell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get orbitSell;

  /// No description provided for @orbitRoundLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Round {round} - {action} {resource} @ {price}'**
  String orbitRoundLogTitle(
    int round,
    Object action,
    Object resource,
    int price,
  );

  /// No description provided for @orbitRoundLogStats.
  ///
  /// In en, this message translates to:
  /// **'Cash {cash} | Net {netWorth}'**
  String orbitRoundLogStats(int cash, int netWorth);

  /// No description provided for @orbitResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Trade Settlement'**
  String get orbitResultTitle;

  /// No description provided for @orbitResultBody.
  ///
  /// In en, this message translates to:
  /// **'Final net worth: {netWorth}'**
  String orbitResultBody(int netWorth);

  /// No description provided for @orbitTradeAgain.
  ///
  /// In en, this message translates to:
  /// **'Trade Again'**
  String get orbitTradeAgain;

  /// No description provided for @orbitActionBuy.
  ///
  /// In en, this message translates to:
  /// **'BUY'**
  String get orbitActionBuy;

  /// No description provided for @orbitActionSell.
  ///
  /// In en, this message translates to:
  /// **'SELL'**
  String get orbitActionSell;

  /// No description provided for @orbitResourceOre.
  ///
  /// In en, this message translates to:
  /// **'Ore'**
  String get orbitResourceOre;

  /// No description provided for @orbitResourceCrystal.
  ///
  /// In en, this message translates to:
  /// **'Crystal'**
  String get orbitResourceCrystal;

  /// No description provided for @orbitResourceGas.
  ///
  /// In en, this message translates to:
  /// **'Gas'**
  String get orbitResourceGas;

  /// No description provided for @signalMetricBattlefield.
  ///
  /// In en, this message translates to:
  /// **'Battlefield'**
  String get signalMetricBattlefield;

  /// No description provided for @signalMetricMomentum.
  ///
  /// In en, this message translates to:
  /// **'Momentum'**
  String get signalMetricMomentum;

  /// No description provided for @signalFieldChip.
  ///
  /// In en, this message translates to:
  /// **'Field: {suit}'**
  String signalFieldChip(Object suit);

  /// No description provided for @signalMomentumChip.
  ///
  /// In en, this message translates to:
  /// **'Momentum {playerMomentum}-{rivalMomentum}'**
  String signalMomentumChip(int playerMomentum, int rivalMomentum);

  /// No description provided for @signalBattleBonus.
  ///
  /// In en, this message translates to:
  /// **'Battle +1'**
  String get signalBattleBonus;

  /// No description provided for @signalMomentumBonus.
  ///
  /// In en, this message translates to:
  /// **'Momentum +{bonus}'**
  String signalMomentumBonus(int bonus);

  /// No description provided for @howToPlayAction.
  ///
  /// In en, this message translates to:
  /// **'How to play'**
  String get howToPlayAction;

  /// No description provided for @guideReadyAction.
  ///
  /// In en, this message translates to:
  /// **'Start match'**
  String get guideReadyAction;

  /// No description provided for @guideBackAction.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get guideBackAction;

  /// No description provided for @guideNextAction.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get guideNextAction;

  /// No description provided for @guideSkipAction.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get guideSkipAction;

  /// No description provided for @guideStepCounter.
  ///
  /// In en, this message translates to:
  /// **'Step {current}/{total}'**
  String guideStepCounter(int current, int total);

  /// No description provided for @guideSectionGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Core goal'**
  String get guideSectionGoalTitle;

  /// No description provided for @guideSectionTurnTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn flow'**
  String get guideSectionTurnTitle;

  /// No description provided for @guideSectionTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Winning tips'**
  String get guideSectionTipsTitle;

  /// No description provided for @guideSectionReopenTitle.
  ///
  /// In en, this message translates to:
  /// **'Open Again'**
  String get guideSectionReopenTitle;

  /// No description provided for @guideReopenBody.
  ///
  /// In en, this message translates to:
  /// **'If you skip now, this guide will not auto-open for the same game next time. Use the top guide icon whenever you want to reopen it.'**
  String get guideReopenBody;

  /// No description provided for @signalGuideGoalBody.
  ///
  /// In en, this message translates to:
  /// **'Win rounds with higher effective power. The higher total score takes the match.'**
  String get signalGuideGoalBody;

  /// No description provided for @signalGuideTurnBody.
  ///
  /// In en, this message translates to:
  /// **'Play 1 card each round. Matching the battlefield suit grants +1, momentum stacks after winning rounds, and abilities resolve from the card trait.'**
  String get signalGuideTurnBody;

  /// No description provided for @signalGuideTipsBody.
  ///
  /// In en, this message translates to:
  /// **'Watch the active field and your momentum. Save chain cards for same-suit turns and use counter or anchor cards to swing key rounds.'**
  String get signalGuideTipsBody;

  /// No description provided for @midnightGuideGoalBody.
  ///
  /// In en, this message translates to:
  /// **'Identify the culprit before the rival does. Correct votes award points over the full case sequence.'**
  String get midnightGuideGoalBody;

  /// No description provided for @midnightGuideTurnBody.
  ///
  /// In en, this message translates to:
  /// **'Review revealed clues, spend insight to expose more evidence, then lock one suspect as your vote for the round.'**
  String get midnightGuideTurnBody;

  /// No description provided for @midnightGuideTipsBody.
  ///
  /// In en, this message translates to:
  /// **'Do not burn all insight early. Cross-check alibis, motive, and map access before committing your last vote.'**
  String get midnightGuideTipsBody;

  /// No description provided for @orbitGuideGoalBody.
  ///
  /// In en, this message translates to:
  /// **'Finish the contract with the highest net worth by balancing cash flow, holdings, and price swings.'**
  String get orbitGuideGoalBody;

  /// No description provided for @orbitGuideTurnBody.
  ///
  /// In en, this message translates to:
  /// **'Each turn you buy or sell exactly one resource. The market reprices after the action, so tempo matters as much as value.'**
  String get orbitGuideTurnBody;

  /// No description provided for @orbitGuideTipsBody.
  ///
  /// In en, this message translates to:
  /// **'Keep enough cash for reversals, do not overstack one commodity, and sell into peaks instead of waiting for perfect prices.'**
  String get orbitGuideTipsBody;

  /// No description provided for @chaosGuideGoalBody.
  ///
  /// In en, this message translates to:
  /// **'String together party challenges for score and streak bonuses before the round set ends.'**
  String get chaosGuideGoalBody;

  /// No description provided for @chaosGuideTurnBody.
  ///
  /// In en, this message translates to:
  /// **'Each challenge has a timer and base score. Clear it to grow streak value or fail and reset momentum.'**
  String get chaosGuideTurnBody;

  /// No description provided for @chaosGuideTipsBody.
  ///
  /// In en, this message translates to:
  /// **'Use rerolls on low-confidence prompts, protect an existing streak, and prioritize fast-completion tasks late in the run.'**
  String get chaosGuideTipsBody;

  /// No description provided for @moduleReadinessLabel.
  ///
  /// In en, this message translates to:
  /// **'Readiness'**
  String get moduleReadinessLabel;

  /// No description provided for @expandDetails.
  ///
  /// In en, this message translates to:
  /// **'Expand details'**
  String get expandDetails;

  /// No description provided for @collapseDetails.
  ///
  /// In en, this message translates to:
  /// **'Hide details'**
  String get collapseDetails;

  /// No description provided for @enterAction.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enterAction;

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
