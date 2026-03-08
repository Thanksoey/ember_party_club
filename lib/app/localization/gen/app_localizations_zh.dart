// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '余烬派对社';

  @override
  String get discoverTab => '发现';

  @override
  String get roomsTab => '房间';

  @override
  String get reset => '重置';

  @override
  String get play => '出牌';

  @override
  String get playAgain => '再来一局';

  @override
  String get viewPlan => '查看规划';

  @override
  String get playPrototype => '试玩原型';

  @override
  String get homeHeroTitle => '今晚开房，马上开玩。';

  @override
  String get homeHeroBody => '先把朋友拉进同一个房间，再按气氛切换卡牌、推理或派对小游戏。';

  @override
  String get modulesLabel => '模块数';

  @override
  String get featuredLabel => '精选';

  @override
  String get launchStrategy => '首发策略';

  @override
  String get launchBannerTitle => '先打透房间层，再把游戏做成独立模块。';

  @override
  String get launchBannerBody =>
      '统一账号、好友、组队、语音、实时同步和结算系统后，后续每增加一个新游戏，研发成本会明显下降。';

  @override
  String get moduleFilterTitle => '模块筛选';

  @override
  String get moduleFilterSubtitle => '先用统一房间层承接，再逐步扩展到卡牌、推理和派对小游戏。';

  @override
  String candidateGamesTitle(int count) {
    return '候选游戏';
  }

  @override
  String candidateGamesSubtitle(int count) {
    return '当前展示 $count 个适合首期版本立项的模块。';
  }

  @override
  String planningQueue(Object moduleName) {
    return '$moduleName 还在排期开发中。';
  }

  @override
  String get roomLoungeTitle => '房间大厅';

  @override
  String get roomLoungeHero => '把建房、邀请、组队和语音放在统一房间层里。';

  @override
  String get roomLoungeBody => '这样新游戏只需要接入规则与渲染，不需要重复建设多人基础设施。';

  @override
  String get activeRoomsMetric => '活跃房间';

  @override
  String get onlinePlayersMetric => '在线玩家';

  @override
  String get quickMatch => '快速匹配';

  @override
  String get quickMatchBody => '自动找房 + 智能补位';

  @override
  String get createRoom => '创建房间';

  @override
  String get createRoomBody => '先选模块，再定人数和语音策略';

  @override
  String get hottestRoom => '热度最高房间';

  @override
  String get activeRoomList => '活跃房间';

  @override
  String hostLabel(Object nickname) {
    return '房主 $nickname';
  }

  @override
  String playersLabel(int current, int capacity) {
    return '$current/$capacity 人';
  }

  @override
  String get voiceOn => '语音开启';

  @override
  String get ranked => '排位';

  @override
  String get casual => '休闲';

  @override
  String get signalDeckTitle => '信号牌局';

  @override
  String get signalDeckSubtitle => '首个可玩的卡牌对战原型';

  @override
  String get signalDeckIntro => '这一版已经具备技能牌、固定回合赛制和结算复玩循环，后续可直接接到多人房间。';

  @override
  String get yourHand => '你的手牌';

  @override
  String get roundLog => '回合记录';

  @override
  String get noRoundsPlayed => '还没有进行任何回合。';

  @override
  String signalRoundLabel(int round) {
    return '第 $round 回合';
  }

  @override
  String signalPowerCheck(int playerPower, int rivalPower) {
    return '强度校验：你 $playerPower / 对手 $rivalPower';
  }

  @override
  String get youLabel => '你';

  @override
  String get rivalLabel => '脉冲 AI';

  @override
  String get roundsWon => '胜回合';

  @override
  String get matchLabel => '赛程';

  @override
  String get youNotPlayed => '你还没有出牌。';

  @override
  String youPlayed(Object title) {
    return '你打出了 $title';
  }

  @override
  String get rivalWaiting => '脉冲 AI 正在等待。';

  @override
  String rivalPlayed(Object title) {
    return '脉冲 AI 打出了 $title';
  }

  @override
  String get drawGame => '平局';

  @override
  String winnerTakesMatch(Object winner) {
    return '$winner 赢下了本局';
  }

  @override
  String get matchOver => '本局已经结束。';

  @override
  String get signalPowerLabel => '强度';

  @override
  String signalPoints(int score) {
    return '$score 分';
  }

  @override
  String signalStatus(int round, int maxRounds) {
    return '请选择一张牌，开始第 $round / 共 $maxRounds 回合。';
  }

  @override
  String signalFinishReason(
    int rounds,
    int playerScore,
    int rivalScore,
    int playerRoundsWon,
    int rivalRoundsWon,
  ) {
    return '共进行了 $rounds 回合。比分 $playerScore-$rivalScore，胜回合 $playerRoundsWon-$rivalRoundsWon。';
  }

  @override
  String signalRoundPlayerWinConnector(Object rivalCardTitle, int rivalPower) {
    return '压过了 $rivalCardTitle ($rivalPower)，你获得 3 分。';
  }

  @override
  String signalRoundRivalWinConnector(Object playerCardTitle, int playerPower) {
    return '压过了 $playerCardTitle ($playerPower)，脉冲 AI 获得 3 分。';
  }

  @override
  String signalRoundDrawSummary(
    Object playerCardTitle,
    Object rivalCardTitle,
    int power,
  ) {
    return '$playerCardTitle 与 $rivalCardTitle 同为 $power 点，双方各得 1 分。';
  }

  @override
  String get moduleNameSignalDeck => '信号牌局';

  @override
  String get moduleNameMidnightVote => '午夜投票';

  @override
  String get moduleNameOrbitMerchant => '轨道商旅';

  @override
  String get moduleNameChaosMixer => '混沌派对';

  @override
  String get moduleTaglineSignalDeck => '快节奏卡牌配合';

  @override
  String get moduleTaglineMidnightVote => '轻推理阵营博弈';

  @override
  String get moduleTaglineOrbitMerchant => '中度策略交易';

  @override
  String get moduleTaglineChaosMixer => '派对小游戏合集';

  @override
  String get moduleSummarySignalDeck => '围绕手牌联动和团队默契的回合制卡牌游戏，适合聚会开局热场。';

  @override
  String get moduleSummaryMidnightVote => '每局十分钟的隐藏身份玩法，重点在语音互动和投票节奏控制。';

  @override
  String get moduleSummaryOrbitMerchant => '资源交换和卡牌构筑结合，适合熟人长期房间和赛季排行。';

  @override
  String get moduleSummaryChaosMixer => '把抢答、表演、你画我猜和惩罚轮盘整合进一个聚会房间。';

  @override
  String get roomTitleSignalRanked => '信号牌局 冲分房';

  @override
  String get roomTitleChaosFriday => '混沌派对 周五局';

  @override
  String get roomTitleVoteFriends => '午夜投票 熟人局';

  @override
  String get gameCategoryCard => '卡牌';

  @override
  String get gameCategoryParty => '派对';

  @override
  String get gameCategoryBluff => '博弈';

  @override
  String get gameCategoryStrategy => '策略';

  @override
  String get matchTempoQuick => '15 分钟';

  @override
  String get matchTempoStandard => '30 分钟';

  @override
  String get matchTempoDeep => '45 分钟以上';

  @override
  String get roomStatusWaiting => '等待中';

  @override
  String get roomStatusInGame => '进行中';

  @override
  String get roomStatusSettling => '结算中';

  @override
  String get signalSuitEmber => '余烬';

  @override
  String get signalSuitTide => '潮汐';

  @override
  String get signalSuitSpark => '电火';

  @override
  String get signalAbilityChain => '连携';

  @override
  String get signalAbilityCounter => '克制';

  @override
  String get signalAbilitySurge => '追击';

  @override
  String get signalAbilityAnchor => '压阵';

  @override
  String get signalCardTitleE1 => '余烬连线';

  @override
  String get signalCardTitleE2 => '灰烬脉冲';

  @override
  String get signalCardTitleE3 => '日耀召令';

  @override
  String get signalCardTitleE4 => '绯红同步';

  @override
  String get signalCardTitleT1 => '涟漪标记';

  @override
  String get signalCardTitleT2 => '深流护壁';

  @override
  String get signalCardTitleT3 => '蔚蓝回声';

  @override
  String get signalCardTitleT4 => '迷雾帷幕';

  @override
  String get signalCardTitleS1 => '伏特点触';

  @override
  String get signalCardTitleS2 => '疾速回路';

  @override
  String get signalCardTitleS3 => '静冠脉冲';

  @override
  String get signalCardTitleS4 => '信号针刺';

  @override
  String get signalCardNoteE1 => '连携：上一张若同为余烬系，则强度 +2。';

  @override
  String get signalCardNoteE2 => '追击：分数落后或后期回合时强度 +1。';

  @override
  String get signalCardNoteE3 => '连携：余烬连段中的高压终结牌。';

  @override
  String get signalCardNoteE4 => '压阵：对上高强度重牌时强度 +2。';

  @override
  String get signalCardNoteT1 => '克制：对余烬系卡牌强度 +2。';

  @override
  String get signalCardNoteT2 => '压阵：吸收更强来牌时强度 +2。';

  @override
  String get signalCardNoteT3 => '克制：在余烬节奏线里更容易抢回主动。';

  @override
  String get signalCardNoteT4 => '追击：分数落后或后期回合时强度 +1。';

  @override
  String get signalCardNoteS1 => '追击：分数落后或后期回合时强度 +1。';

  @override
  String get signalCardNoteS2 => '连携：上一张若同为电火系，则强度 +2。';

  @override
  String get signalCardNoteS3 => '追击：后段回合逆转能力更强。';

  @override
  String get signalCardNoteS4 => '压阵：对上高强度重牌时强度 +2。';

  @override
  String get roomDetailBody => '这里是房间配置和正式游戏之间的桥接层。先接通信号牌局，后面其他游戏直接复用。';

  @override
  String get roomCapacityFieldLabel => '座位数量';

  @override
  String get roomVoiceToggle => '开启语音';

  @override
  String get roomCreateAndEnter => '创建并进入';

  @override
  String get roomInfoSection => '房间信息';

  @override
  String get roomUnsupportedBody => '这个模块已经进入房间层，但可玩的游戏会话还没有接上。';

  @override
  String get roomDetailTitle => '房间详情';

  @override
  String get roomSelectModuleLabel => '游戏模块';

  @override
  String get roomModuleLabel => '模块';

  @override
  String roomCreateDefaultName(Object moduleName) {
    return '$moduleName 房间';
  }

  @override
  String get roomSettingsSection => '房间设置';

  @override
  String get roomStartGame => '开始游戏';

  @override
  String get roomVoiceOff => '语音关闭';

  @override
  String get roomNotFound => '房间不存在。';

  @override
  String get roomCreateSheetBody => '先选择模块和座位数，再直接进入房间流程，后面可以继续接实时同步。';

  @override
  String get roomCodeLabel => '房间编号';

  @override
  String get roomRankedToggle => '排位房间';

  @override
  String get roomStartGameBody => '信号牌局已经接成可玩的本地原型。现在开始会把房间标记为进行中，并直接进入对局。';

  @override
  String get roomNameFieldLabel => '房间名称';

  @override
  String get roomCreateSheetTitle => '创建房间';

  @override
  String get quickMatchEmpty => '当前还没有可快速进入的房间。';

  @override
  String get roomHostNameLabel => '房主';

  @override
  String get gameSessionParticipantsLabel => '当前席位';

  @override
  String get gameSessionLocalPlayerName => '你';

  @override
  String get gameSessionLocalTag => '本地';

  @override
  String get gameSessionPhaseBriefing => '准备阶段';

  @override
  String get gameSessionSyncMultiplayerReady => '可接入多人同步';

  @override
  String get gameSessionSyncRoomBound => '已绑定房间';

  @override
  String roomSessionTitle(Object roomTitle, Object moduleName) {
    return '$roomTitle · $moduleName';
  }

  @override
  String get gameSessionPhaseFinished => '本局结束';

  @override
  String get gameSessionRoomLabel => '房间会话';

  @override
  String get gameSessionPhasePlaying => '对局进行中';

  @override
  String get gameSessionSyncLocalPreview => '本地预演';

  @override
  String gameSessionGuestSeatName(int seat) {
    return '$seat 号位';
  }

  @override
  String get gameSessionHostTag => '房主';

  @override
  String gameSessionParticipantLabel(int seat, Object name) {
    return '$name · $seat 号位';
  }

  @override
  String get signalDeckRoomSubtitle => '带房间上下文的卡牌会话';

  @override
  String get gameSessionSyncLabel => '同步';

  @override
  String get loginPasswordLabel => '密码';

  @override
  String get settingsBody => '主题和语言会自动保存，下次打开保持你上次的选择。';

  @override
  String get launchLoadingBody => '正在准备房间、模块和会话状态...';

  @override
  String get loginBody => '登录后就能直接建房、组队、开局。没账号的话在这里一键注册。';

  @override
  String get profileBody => '账号状态、界面偏好和开发期控制项统一放在这里管理。';

  @override
  String get loginUsernameLabel => '用户名';

  @override
  String get registerDisplayNameLabel => '昵称';

  @override
  String get registerConfirmPasswordLabel => '确认密码';

  @override
  String get themeTitle => '界面风格';

  @override
  String get profileRolePlayer => '普通玩家';

  @override
  String get localeBody => '默认中文；如果系统语言是英文，应用会自动切换到英文。';

  @override
  String get loginAction => '登录';

  @override
  String get registerAction => '注册';

  @override
  String get themeDark => '深色';

  @override
  String get loginDemoHint => '当前默认填充的是开发演示账号，方便你直接进入应用。管理员账号我会在交付说明里单独给你。';

  @override
  String get settingsTitle => '系统设置';

  @override
  String get profileGuest => '游客';

  @override
  String get localeTitle => '语言';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get loginInvalidCredentials => '用户名或密码错误。';

  @override
  String get registerUsernameTaken => '该用户名已被占用。';

  @override
  String get registerPasswordMismatch => '两次输入的密码不一致。';

  @override
  String get logoutAction => '退出登录';

  @override
  String get themeLight => '浅色';

  @override
  String themeModeDescription(Object mode) {
    return '当前模式：$mode';
  }

  @override
  String get loginHeadline => '登录后加入今晚的派对局';

  @override
  String get authModeSignIn => '登录';

  @override
  String get authModeRegister => '注册';

  @override
  String get profileTab => '我的';

  @override
  String get profileTitle => '用户中心';

  @override
  String get profileRoleAdmin => '管理员';

  @override
  String get authGuideAction => 'App 介绍与规则';

  @override
  String get authGuideTitle => 'App 介绍与规则';

  @override
  String get authGuideIntroTitle => '这是什么应用？';

  @override
  String get authGuideIntroBody =>
      '余烬派对社是朋友聚会用的开局工具。先进同一个房间，再选择要玩的模式，整场不用反复切页面。';

  @override
  String get authGuideRulesTitle => '核心规则';

  @override
  String get authGuideRuleSignalTitle => '信号牌局基础规则';

  @override
  String get authGuideRuleSignalBody => '每回合双方各出一张牌，按有效强度判胜负。整局结束时分数更高的一方获胜。';

  @override
  String get authGuideRuleRoomTitle => '房间流程';

  @override
  String get authGuideRuleRoomBody => '由房主创建房间并设置人数、语音后开局。房间状态会同步给所有参与者。';

  @override
  String get authGuideRuleFairTitle => '公平游戏';

  @override
  String get authGuideRuleFairBody => '请尊重其他玩家，避免辱骂与恶意行为，保持对局节奏，让所有人都能参与。';

  @override
  String get headerSubtitleDiscover => '挑今晚要玩的模式';

  @override
  String get headerSubtitleRooms => '开房、组队、准备开局';

  @override
  String get headerSubtitleProfile => '账号、偏好和安全设置';

  @override
  String get localeModeSystem => '跟随系统';

  @override
  String get localeModeChinese => '中文';

  @override
  String get localeModeEnglish => 'English';

  @override
  String localeModeDescription(Object mode) {
    return '当前语言模式：$mode';
  }

  @override
  String get loginSessionExpired => '会话已失效，请重新登录。';

  @override
  String get loginFillDemo => '填入试玩账号';

  @override
  String get loginFillAdmin => '填入管理员账号';

  @override
  String get loginHeroTitle => '把账号、房间和游戏会话收进同一套壳层。';

  @override
  String get loginHeroBody => '现在的登录机制已经具备会话模型、设备列表和资料编辑边界，后面替换成真实后端时不会重写 UI。';

  @override
  String get loginSeedPlayerTitle => '试玩玩家账号';

  @override
  String get loginSeedAdminTitle => '管理员账号';

  @override
  String get guardLoginTitle => '需要先登录';

  @override
  String get guardLoginBody => '当前页面受登录态保护。请先登录后再访问。';

  @override
  String get guardAdminTitle => '需要管理员权限';

  @override
  String get guardAdminBody => '这个入口只对管理员开放。当前账号没有足够权限。';

  @override
  String get profileEditTitle => '编辑资料';

  @override
  String get profileEditBody => '调整昵称、个人简介和头像风格，资料会立即写回当前会话。';

  @override
  String get profileDisplayNameField => '昵称';

  @override
  String get profileBioField => '个人简介';

  @override
  String get profileAvatarField => '头像风格';

  @override
  String get profileSaveAction => '保存资料';

  @override
  String get profileSavedMessage => '资料已更新。';

  @override
  String get profileSignedInAt => '登录时间';

  @override
  String get profileSessionExpiry => '会话过期';

  @override
  String profileLevel(int level) {
    return 'Lv.$level';
  }

  @override
  String get securityTitle => '账号安全';

  @override
  String get securityBody =>
      '这里管理密码、设备登录和会话边界。当前实现已把敏感信息存取收口到独立存储接口，后续可替换成系统安全存储。';

  @override
  String get securitySessionCardTitle => '当前会话';

  @override
  String get securitySessionId => '会话 ID';

  @override
  String get securitySessionExpiry => '到期时间';

  @override
  String get securityStorageMode => '存储策略';

  @override
  String get securityStorageModeValue =>
      '本地密钥接口（开发态），可直接替换为 Keychain / Keystore';

  @override
  String get securityPasswordTitle => '修改密码';

  @override
  String get securityPasswordBody => '当前为开发期账号壳层，密码修改已预留协议与错误态。';

  @override
  String get securityCurrentPassword => '当前密码';

  @override
  String get securityNextPassword => '新密码';

  @override
  String get securityPasswordAction => '更新密码';

  @override
  String get securityPasswordUpdated => '密码校验已通过，开发账号协议已更新。';

  @override
  String get securityDevicesTitle => '登录设备';

  @override
  String get securityDevicesBody => '当前设备列表来自会话仓库抽象，后续可直接对接真实风控和设备管理。';

  @override
  String get securityCurrentDevice => '当前设备';

  @override
  String get securitySignOutDevice => '移除';

  @override
  String get securityIncorrectPassword => '当前密码不正确。';

  @override
  String get securityWeakPassword => '新密码至少 8 位。';

  @override
  String get adminConsoleTitle => '管理员控制台';

  @override
  String get adminConsoleBody => '这里先做企业级壳层：用户治理、房间治理和运营配置三个看板。后续接真实后台时只替换数据源。';

  @override
  String get adminMetricUsers => '受管用户';

  @override
  String get adminMetricRooms => '房间池';

  @override
  String get adminMetricIncidents => '待处理事件';

  @override
  String get adminUsersSection => '用户治理';

  @override
  String get adminUsersBody => '集中处理违规、申诉和关键玩家画像。';

  @override
  String get adminUsersItemModeration => '快速查看最近高风险登录和异常昵称变更。';

  @override
  String get adminUsersItemBan => '预留封禁、解封和备注审计链路。';

  @override
  String get adminUsersItemSearch => '支持按 UID、昵称、设备来源搜索用户。';

  @override
  String get adminRoomsSection => '房间治理';

  @override
  String get adminRoomsBody => '统一看等待房、对局房和异常房间状态。';

  @override
  String get adminRoomsItemQueue => '查看各模块建房和匹配队列的拥塞情况。';

  @override
  String get adminRoomsItemHealth => '检查房间会话同步状态和开局成功率。';

  @override
  String get adminRoomsItemCapacity => '为节假日活动预留房间容量策略入口。';

  @override
  String get adminOpsSection => '运营配置';

  @override
  String get adminOpsBody => '把 Banner、推荐位和特性开关集中到同一套运营面板。';

  @override
  String get adminOpsItemConfig => '运营位配置支持灰度开关和时间窗。';

  @override
  String get adminOpsItemBanner => '首页 Banner 与模块排序统一由配置驱动。';

  @override
  String get adminOpsItemFeatureFlag => '预留游戏模块开关与实验分流入口。';

  @override
  String get authProviderUsernamePassword => '账号密码';

  @override
  String get gameSessionTimelineTitle => '同步时间线';

  @override
  String get gameSessionTimelineEmpty => '尚未收到同步事件。';

  @override
  String get gameSessionCommandConnect => '连接同步通道';

  @override
  String get gameSessionCommandStartGame => '开始对局';

  @override
  String get gameSessionCommandPlayCard => '广播出牌';

  @override
  String get gameSessionCommandResetMatch => '重置对局';

  @override
  String get gameSessionEventSyncConnected => '实时通道已连接。';

  @override
  String get gameSessionEventSyncReady => '同步准备就绪，房间已进入多人模式。';

  @override
  String gameSessionEventCommandDispatched(Object command) {
    return '已发送指令：$command';
  }

  @override
  String gameSessionEventCommandAcknowledged(Object command) {
    return '服务端已确认指令：$command';
  }

  @override
  String gameSessionEventPhaseChanged(Object phase) {
    return '会话阶段切换为：$phase';
  }

  @override
  String gameSessionEventParticipantSynced(int seat) {
    return '$seat 号位已完成同步。';
  }

  @override
  String gameSessionEventSignalCard(Object cardTitle) {
    return '已广播本回合卡牌：$cardTitle';
  }

  @override
  String get gameSessionEventMatchReset => '房间对局已重置，等待下一轮开始。';

  @override
  String get feedbackTitle => '系统反馈';

  @override
  String get feedbackSoundEffects => '音效';

  @override
  String get feedbackHaptics => '震动';

  @override
  String get feedbackOn => '已开启';

  @override
  String get feedbackOff => '已关闭';

  @override
  String get chaosIntro => '每回合会抽取一个派对挑战。完成后可得分，并叠加连胜倍率。';

  @override
  String get chaosScoreLabel => '得分';

  @override
  String get chaosStreakLabel => '连胜';

  @override
  String get chaosBestLabel => '最佳连胜';

  @override
  String get chaosRerollLabel => '重抽';

  @override
  String chaosStatusPlaying(int round) {
    return '第 $round 回合：完成挑战以保住连胜加成。';
  }

  @override
  String chaosStatusFinished(int score, int bestStreak) {
    return '挑战结束，总分 $score，最佳连胜 $bestStreak。';
  }

  @override
  String get chaosActionSuccess => '完成';

  @override
  String get chaosActionFail => '失败';

  @override
  String get chaosActionReroll => '重抽';

  @override
  String get chaosRoundTimeline => '回合时间线';

  @override
  String get chaosRoundEmpty => '完成至少一个挑战后，这里会记录回合进展。';

  @override
  String chaosBasePointsLabel(int points) {
    return '基础 +$points';
  }

  @override
  String chaosTimerLabel(int seconds) {
    return '倒计时 $seconds 秒';
  }

  @override
  String chaosRoundTitle(int round, Object title) {
    return '第 $round 回合 · $title';
  }

  @override
  String chaosRoundSuccess(int points) {
    return '成功，+$points 分';
  }

  @override
  String get chaosRoundFailed => '失败，连胜重置';

  @override
  String chaosStreakAfterRound(int streak) {
    return '本回合后连胜：$streak';
  }

  @override
  String get chaosSummaryTitle => '混沌总结';

  @override
  String chaosSummaryBody(int score, int bestStreak) {
    return '最终得分 $score，最佳连胜 $bestStreak。';
  }

  @override
  String get chaosRunAgain => '再开一轮';

  @override
  String get chaosChallengeTitleMimic => '镜像模仿';

  @override
  String get chaosChallengeTitleRapidQa => '极速三连答';

  @override
  String get chaosChallengeTitleRhythm => '节奏接力';

  @override
  String get chaosChallengeTitleDrawAndGuess => '速写猜题';

  @override
  String get chaosChallengeTitleSoundOnly => '纯音效';

  @override
  String get chaosChallengeTitleFrozenPose => '冻结定格';

  @override
  String get chaosChallengeTitleReverseStory => '倒叙故事';

  @override
  String get chaosChallengeTitleEmojiSpeak => '表情翻译';

  @override
  String get chaosChallengeDetailMimic => '模仿一个职业 30 秒，并让队友至少猜中一次。';

  @override
  String get chaosChallengeDetailRapidQa => '连续回答 3 个随机问题，每题限时 5 秒。';

  @override
  String get chaosChallengeDetailRhythm => '准确跟上拍手节奏和口号，中途不能失误。';

  @override
  String get chaosChallengeDetailDrawAndGuess => '20 秒内画出关键词，并让队友猜中。';

  @override
  String get chaosChallengeDetailSoundOnly => '不能说答案相关词，只能用音效表达。';

  @override
  String get chaosChallengeDetailFrozenPose => '保持一个定格姿势 10 秒，让队友说出场景。';

  @override
  String get chaosChallengeDetailReverseStory => '先讲结尾，再讲开头，仍要自圆其说。';

  @override
  String get chaosChallengeDetailEmojiSpeak => '只用 3 个表情描述电影名或歌名。';

  @override
  String midnightStatusPlaying(int round) {
    return '第 $round 回合：在热度消散前锁定投票。';
  }

  @override
  String midnightStatusFinished(int playerScore, int aiScore) {
    return '案卷关闭。你 $playerScore - 对手 $aiScore。';
  }

  @override
  String get midnightInsightLabel => '洞察';

  @override
  String midnightCaseLabel(Object title) {
    return '案件：$title';
  }

  @override
  String get midnightRevealClue => '揭示线索';

  @override
  String get midnightSuspectsTitle => '嫌疑人';

  @override
  String get midnightTimelineTitle => '调查时间线';

  @override
  String get midnightTimelineEmpty => '还没有投票记录。锁定一名嫌疑人后会记录在这里。';

  @override
  String get midnightSelectSuspect => '将其设为本回合首要嫌疑人。';

  @override
  String get midnightLockVote => '锁定投票';

  @override
  String midnightTimelineRound(int round, Object caseTitle) {
    return '第 $round 回合 · $caseTitle';
  }

  @override
  String midnightTimelineVotes(
    Object playerVote,
    Object aiVote,
    Object culpritVote,
  ) {
    return '你投给了 $playerVote；对手投给了 $aiVote；真凶是 $culpritVote。';
  }

  @override
  String midnightTimelineResult(int playerPoints, int aiPoints) {
    return '得分：你 +$playerPoints，对手 +$aiPoints。';
  }

  @override
  String get midnightResultWin => '调查压制';

  @override
  String get midnightResultLose => '对手拿下案子';

  @override
  String midnightResultScore(int playerScore, int aiScore) {
    return '最终比分：你 $playerScore - 对手 $aiScore。';
  }

  @override
  String get midnightCaseTitleCaseA => '灯街回声案';

  @override
  String get midnightCaseTitleCaseB => '云港信号失窃案';

  @override
  String get midnightCaseTitleCaseC => '港区失踪货箱案';

  @override
  String get midnightClueA1 => '目击者在北侧小巷听到了一声银哨。';

  @override
  String get midnightClueA2 => '舞台后方发现了一只沾有染料的手套。';

  @override
  String get midnightClueA3 => '凶手熟悉点灯时间表，才能避开巡逻。';

  @override
  String get midnightClueB1 => '安保记录显示，午夜有一张伪造货运通行证被刷入。';

  @override
  String get midnightClueB2 => '失窃的货箱太重，一个人根本搬不走。';

  @override
  String get midnightClueB3 => '一枚裂开的通讯芯片指向了信号控制岗位。';

  @override
  String get midnightClueC1 => '天亮前，C 泊位附近留下了潮湿的靴印。';

  @override
  String get midnightClueC2 => '锁是用一组旧海关覆盖码打开的。';

  @override
  String get midnightClueC3 => '只有一名嫌疑人知道七号摄像头的盲区。';

  @override
  String get midnightSuspectVex => '维克斯';

  @override
  String get midnightSuspectLyra => '莱拉';

  @override
  String get midnightSuspectKade => '凯德';

  @override
  String get midnightSuspectMina => '米娜';

  @override
  String get midnightSuspectNox => '诺克斯';

  @override
  String get midnightSuspectSora => '索拉';

  @override
  String get midnightSuspectDax => '达克斯';

  @override
  String get midnightSuspectYuri => '尤里';

  @override
  String orbitStatusFinished(int netWorth) {
    return '合约结束，最终净值 $netWorth。';
  }

  @override
  String get orbitStatusPlaying => '每回合只交易一项资源，领先市场波动。';

  @override
  String get orbitMetricCash => '现金';

  @override
  String get orbitMetricNetWorth => '净值';

  @override
  String get orbitMetricCargo => '货舱';

  @override
  String get orbitMarketBoardTitle => '市场面板';

  @override
  String get orbitMarketBoardSubtitle => '点击资源卡进行买卖。';

  @override
  String get orbitTimelineTitle => '交易时间线';

  @override
  String get orbitTimelineEmpty => '还没有成交记录。先买入或卖出一项资源。';

  @override
  String orbitResourceStats(int price, int cargo) {
    return '价格 $price ｜ 持仓 $cargo';
  }

  @override
  String get orbitBuy => '买入';

  @override
  String get orbitSell => '卖出';

  @override
  String orbitRoundLogTitle(
    int round,
    Object action,
    Object resource,
    int price,
  ) {
    return '第 $round 回合 · $action $resource @ $price';
  }

  @override
  String orbitRoundLogStats(int cash, int netWorth) {
    return '现金 $cash ｜ 净值 $netWorth';
  }

  @override
  String get orbitResultTitle => '贸易结算';

  @override
  String orbitResultBody(int netWorth) {
    return '最终净值：$netWorth';
  }

  @override
  String get orbitTradeAgain => '再跑一轮';

  @override
  String get orbitActionBuy => '买入';

  @override
  String get orbitActionSell => '卖出';

  @override
  String get orbitResourceOre => '矿石';

  @override
  String get orbitResourceCrystal => '晶矿';

  @override
  String get orbitResourceGas => '气体';

  @override
  String get signalMetricBattlefield => '战场属性';

  @override
  String get signalMetricMomentum => '动能';

  @override
  String signalFieldChip(Object suit) {
    return '场域：$suit';
  }

  @override
  String signalMomentumChip(int playerMomentum, int rivalMomentum) {
    return '动能 $playerMomentum-$rivalMomentum';
  }

  @override
  String get signalBattleBonus => '战场 +1';

  @override
  String signalMomentumBonus(int bonus) {
    return '动能 +$bonus';
  }

  @override
  String get howToPlayAction => '玩法说明';

  @override
  String get guideReadyAction => '开始对局';

  @override
  String get guideBackAction => '上一步';

  @override
  String get guideNextAction => '下一步';

  @override
  String get guideSkipAction => '先跳过';

  @override
  String guideStepCounter(int current, int total) {
    return '步骤 $current/$total';
  }

  @override
  String get guideSectionGoalTitle => '核心目标';

  @override
  String get guideSectionTurnTitle => '回合流程';

  @override
  String get guideSectionTipsTitle => '上手重点';

  @override
  String get signalGuideGoalBody => '用更高的有效强度赢下回合。整局结束时，总分更高的一方获胜。';

  @override
  String get signalGuideTurnBody => '每回合打出 1 张牌。同属性战场会提供 +1，加上连胜动能与牌面技能后结算强度。';

  @override
  String get signalGuideTipsBody => '优先观察当前场域和自身动能。连携牌尽量留给同系回合，关键回合再用克制或压阵牌抢分。';

  @override
  String get midnightGuideGoalBody => '比对手更快锁定真凶。每次正确投票都会累计分数，整套案卷结束后结算胜负。';

  @override
  String get midnightGuideTurnBody => '先阅读已公开线索，再消耗洞察揭示更多证据，最后锁定一名嫌疑人作为本回合投票。';

  @override
  String get midnightGuideTipsBody => '不要过早把洞察全部花完。把不在场证明、动机和行动路线对上，再做最后一票。';

  @override
  String get orbitGuideGoalBody => '在合约结束前，通过现金、持仓和价格波动管理，做出最高净值。';

  @override
  String get orbitGuideTurnBody => '每回合只能买入或卖出一种资源。你行动后市场会重新报价，节奏和价格同样重要。';

  @override
  String get orbitGuideTipsBody => '手里要始终留出回旋现金，不要把仓位压在单一资源上，涨到峰值时及时兑现。';

  @override
  String get chaosGuideGoalBody => '在一轮轮派对挑战中拉高总分，并用连胜倍率把分数滚起来。';

  @override
  String get chaosGuideTurnBody => '每个挑战都有时限和基础分。完成则继续叠连胜，失败就会把当前连胜清空。';

  @override
  String get chaosGuideTipsBody => '低把握题目优先用重抽保护连胜，后半段更适合选择完成速度快的任务。';

  @override
  String get moduleReadinessLabel => '完成度';

  @override
  String get expandDetails => '展开详情';

  @override
  String get collapseDetails => '收起详情';

  @override
  String get enterAction => '进入';

  @override
  String shortDateTime(int year, int month, int day, int hour, int minute) {
    return '$year年$month月$day日 $hour:$minute';
  }
}
