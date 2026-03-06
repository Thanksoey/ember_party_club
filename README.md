# Ember Party Club

一个面向朋友局的移动端游戏大厅。目标不是堆很多小游戏，而是先把多人实时房间、模块化游戏编排、低延迟互动和企业级工程规范打稳，再持续扩展卡牌、推理、派对玩法。

## 为什么这样做

多人游戏 App 最容易失败的点不是界面，而是基础设施重复建设。每加一个新游戏都重新写房间、匹配、状态同步、结算和社交关系，团队很快会失控。

这个工程的第一版采用两层策略：

- `Room Platform`: 账号、好友、房间、观战、麦位、实时事件流、结算面板。
- `Game Modules`: 卡牌、派对、推理等玩法只关心自己的规则、回合和渲染。

## 当前目录结构

```text
lib/
  app/
    theme/
  core/
    data/
    models/
  features/
    home/
      application/
      presentation/
docs/
  architecture.md
```

## 已落地的内容

- 一个独立项目目录：`ember_party_club`
- 首页骨架：展示首期候选游戏和产品方向
- 分层示例：`app / core / features`
- 轻量控制器：`ChangeNotifier` 驱动首页筛选
- 企业级方向文档：性能、模块拆分、工程规范、迭代路线

## 推荐的企业级技术路线

- 客户端：Flutter + feature-first 分层 + 可插拔 game module
- 实时层：WebSocket 或自建实时网关，所有房间事件统一协议
- 状态同步：房间状态采用 event-driven 模型，不让 UI 直接拼业务状态
- 游戏引擎：每个玩法维护自己的 `game_state`, `action`, `reducer`, `validator`
- 数据策略：大厅数据缓存、本地快照、房间态增量同步
- 质量基线：严格 lint、分层测试、埋点、崩溃收集、性能预算

## 开发建议

先做首期 3 个高复玩率玩法，而不是一次性做 20 个：

1. 轻卡牌对战
2. 隐藏身份 / 推理
3. 派对小游戏合集

这样可以复用同一套房间系统，验证留存更快。

## 运行

```bash
flutter pub get
flutter run
```

