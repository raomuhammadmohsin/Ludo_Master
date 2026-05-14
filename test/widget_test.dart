import 'package:flutter_test/flutter_test.dart';
import 'package:ludo_master/main.dart';

void main() {
  testWidgets('App starts smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LudoMasterApp());
    expect(find.text('LUDO MASTER'), findsOneWidget);
  });
}
