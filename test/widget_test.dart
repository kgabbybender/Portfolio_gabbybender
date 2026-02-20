import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main.dart';

void main() {
  testWidgets('Portfolio app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyPortfolio());
    expect(find.byType(MyPortfolio), findsOneWidget);
  });
}
