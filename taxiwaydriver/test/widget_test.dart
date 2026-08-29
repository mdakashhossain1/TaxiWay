import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taxiwaydriver/main.dart';

void main() {
  testWidgets('App boots to the driver login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: DriverApp()));
    await tester.pumpAndSettle();

    expect(find.text('Driver Login'), findsOneWidget);
  });
}
