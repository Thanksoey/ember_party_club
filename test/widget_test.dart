import 'package:ember_party_club/app/app.dart';
import 'package:ember_party_club/core/data/game_seed_data.dart';
import 'package:ember_party_club/features/home/application/game_hub_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the first-screen hub content', (tester) async {
    final controller = GameHubController.seeded(GameSeedData.modules);

    await tester.pumpWidget(PartyForgeApp(controller: controller));
    await tester.pumpAndSettle();

    expect(find.text('Ember Party Club'), findsOneWidget);
    expect(find.text('给朋友局而不是单机局设计的移动游戏中心'), findsOneWidget);
    expect(find.text('模块筛选'), findsOneWidget);
    expect(find.text('Card'), findsOneWidget);
    expect(find.text('Party'), findsOneWidget);
  });
}
