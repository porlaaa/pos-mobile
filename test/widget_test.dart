import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mobile/app/pos_mobile_app.dart';

void main() {
  testWidgets('shows login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const PosMobileApp());
    expect(find.text('Employee Login'), findsOneWidget);
    expect(find.text('Restro'), findsOneWidget);
  });
}
