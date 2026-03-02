import 'package:flutter_test/flutter_test.dart';
import 'package:memory_cards/main.dart';

void main() {
  testWidgets('App launches and shows the home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MemoryCardsApp());
    // The home screen should be visible (AppBar title)
    expect(find.text('Memory Cards'), findsOneWidget);
  });
}
