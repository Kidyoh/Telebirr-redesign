// Renders each screen with the real bundled fonts and logos into golden PNGs.
// Run: flutter test --update-goldens test_screenshots
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:telebirr/main.dart';
import 'package:telebirr/screens/scan_screen.dart';
import 'package:telebirr/screens/send_money_screen.dart';

Future<void> _loadFonts() async {
  final families = {
    'Inter': ['Regular', 'Medium', 'SemiBold', 'Bold'],
    'NotoSansEthiopic': ['Regular', 'SemiBold'],
  };
  for (final e in families.entries) {
    final loader = FontLoader(e.key);
    for (final w in e.value) {
      final bytes = File('assets/fonts/${e.key}-$w.ttf').readAsBytesSync();
      loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    }
    await loader.load();
  }
  final icons = FontLoader('MaterialIcons');
  final sdk = Platform.environment['FLUTTER_ROOT'] ?? '';
  final f = File(
    '$sdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  if (f.existsSync()) {
    icons.addFont(Future.value(ByteData.view(f.readAsBytesSync().buffer)));
    await icons.load();
  }
}

Future<void> _precache(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final el in find.byType(Image).evaluate()) {
      final img = el.widget as Image;
      await precacheImage(img.image, el);
    }
  });
}

void main() {
  setUpAll(_loadFonts);

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    tester.view.padding = const FakeViewPadding(top: 162, bottom: 102);
  }

  for (final (i, tab) in [
    'Home',
    'Payment',
    'Apps',
    'Engage',
    'Account',
  ].indexed) {
    testWidgets('tab $tab', (tester) async {
      phone(tester);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const TelebirrApp());
      if (i > 0) {
        await tester.tap(find.text(tab).last);
      }
      await tester.pump(const Duration(seconds: 2));
      await _precache(tester);
      for (var f = 0; f < 4; f++) {
        await tester.pump(const Duration(seconds: 1));
      }
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('../docs/screenshots/$i-$tab.png'),
      );
    });
  }

  for (final (name, page) in [
    ('send', const SendMoneyScreen()),
    ('scan', const ScanScreen()),
  ]) {
    testWidgets('page $name', (tester) async {
      phone(tester);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Inter'),
          home: page,
        ),
      );
      if (name == 'send') {
        for (final k in ['3', '.', '5']) {
          await tester.tap(find.text(k).last);
          await tester.pump(const Duration(milliseconds: 100));
        }
      }
      await tester.pump(const Duration(seconds: 2));
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('../docs/screenshots/page-$name.png'),
      );
    });
  }
}
