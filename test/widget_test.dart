import 'package:flutter_test/flutter_test.dart';
import 'package:isaretler_diyari/main.dart';

void main() {
  testWidgets('App boots to home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const IsaretlerDiyariApp());
    expect(find.text('İşaretler Diyarı'), findsOneWidget);
  });
}
