import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:telebirr/main.dart';

void main() {
  testWidgets('home renders and tabs switch', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const TelebirrApp());
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Scan QR'), findsOneWidget);

    for (final tab in ['Payment', 'Apps', 'Engage', 'Account', 'Home']) {
      await tester.tap(find.text(tab).last);
      await tester.pump(const Duration(seconds: 1));
    }
    expect(tester.takeException(), isNull);
  });
}
