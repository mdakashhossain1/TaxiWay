import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:taxiway/main.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  testWidgets('First launch boots past the theme gate to the language chooser', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ProviderScope(child: TaxiwayApp()));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Choose your language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 3));
  });
}
