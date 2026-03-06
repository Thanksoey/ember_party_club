# Architecture

## 产品拆分

建议把整个 App 拆成 4 个稳定层：

1. `experience layer`
   负责大厅、房间、邀请、结算、个人页等通用体验。
2. `game module layer`
   每个游戏独立维护规则、动作校验、状态转换和表现层。
3. `real-time layer`
   统一处理建房、入房、心跳、重连、事件广播和状态恢复。
4. `platform layer`
   包括账号、风控、支付、埋点、配置、版本控制和客服。

## 客户端推荐目录

```text
lib/
  app/
    bootstrap/
    routing/
    theme/
  core/
    constants/
    data/
    models/
    networking/
    telemetry/
    utils/
  features/
    lobby/
    room/
    social/
    game_shell/
    modules/
      card_battle/
      hidden_role/
      party_mix/
```

## 模块化约束

每个游戏模块只暴露 4 个核心对象：

- `GameDescriptor`: 元数据、人数、节奏、是否支持观战。
- `GameAction`: 用户操作的协议定义。
- `GameReducer`: 服务端或客户端状态推进逻辑。
- `GameView`: 玩法自己的 UI。

这样可以让房间层复用，而不是每个游戏都单独造壳。

## 性能约束

- 首屏目标：冷启动后尽快进入大厅，不阻塞在非关键接口。
- 房间目标：状态同步增量化，避免整房间全量刷新。
- UI 目标：减少大范围 rebuild，列表优先 `const` 和局部状态更新。
- 资源目标：卡牌贴图、头像、音效分级加载，弱网优先文本协议。
- 稳定性目标：断线重连后能恢复到最近一帧可用状态。

## 工程规范

- feature-first 目录，不按 widget/service 混堆。
- domain model 不直接依赖 presentation。
- 房间协议和游戏规则协议分离。
- 每个 feature 至少覆盖 `unit + widget` 两层测试。
- 关键链路加埋点：建房、邀请成功、开局、掉线、结算、复玩。

## 建议的迭代顺序

### Phase 1

- 账号与游客体系
- 好友和邀请
- 通用房间
- 语音占位能力
- 3 个验证型游戏

### Phase 2

- 排位与赛季
- 战绩和复盘
- 礼物和社交裂变
- 游戏配置中心

### Phase 3

- 游戏模块热更新策略
- AI 陪玩和托管
- 创作者房间规则模板

