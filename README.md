# Ember Party Club

一个面向朋友局的移动端游戏大厅。目标不是堆很多小游戏，而是先把多人实时房间、模块化游戏编排、低延迟互动和企业级工程规范打稳，再持续扩展卡牌、推理、派对玩法。

## 为什么这样做

多人游戏 App 最容易失败的点不是界面，而是基础设施重复建设。每加一个新游戏都重新写房间、匹配、状态同步、结算和社交关系，团队很快会失控。

这个工程目前采用两层策略：

- `Room Platform`: 账号、好友、房间、观战、麦位、实时事件流、结算面板。
- `Game Modules`: 卡牌、派对、推理等玩法只关心自己的规则、回合和渲染。

## 当前目录结构

```text
lib/
  app/
    shell/
    theme/
  core/
    data/
    models/
  features/
    home/
    modules/
    rooms/
docs/
  architecture.md
.github/
  workflows/
```

## 已落地的内容

- 独立项目目录：`ember_party_club`
- 双入口壳层：`Discover + Rooms`
- 游戏模块注册中心：统一管理模块元数据与分类
- 房间大厅骨架：活跃房间、快速动作、热度房间展示
- GitHub Actions：自动执行 `flutter analyze` 和 `flutter test`
- 企业级方向文档：性能、模块拆分、工程规范、迭代路线

## 当前建议的产品迭代

1. 做通用房间协议和状态机，而不是先做复杂战斗逻辑。
2. 每个游戏模块只接入 `descriptor / action / reducer / view` 四层。
3. 先验证高复玩玩法，再扩充长期内容型玩法。

## 工程规范方向

- feature-first 目录，不按 service/widget 混堆
- 房间层和游戏规则层解耦
- 关键入口必须可测试、可分析、可持续集成
- 先立性能预算，再叠加实时能力和动画效果

## 运行

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```
