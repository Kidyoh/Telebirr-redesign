import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:telebirr/data/wallet.dart';
import 'package:telebirr/main.dart';

void main() {
  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  testWidgets('home renders and tabs switch', (tester) async {
    phone(tester);
    await tester.pumpWidget(const TelebirrApp());
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Welcome back'), findsOneWidget);

    for (final tab in ['Payment', 'Apps', 'Analytics', 'Setting', 'Home']) {
      await tester.tap(find.text(tab).last);
      await tester.pump(const Duration(seconds: 1));
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('send money: keypad, confirm, receipt', (tester) async {
    phone(tester);
    final before = Wallet.balance.value;
    await tester.pumpWidget(const TelebirrApp());
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.text('Send Money'));
    await tester.pump(const Duration(seconds: 1));
    for (final k in ['1', '0', '0']) {
      await tester.tap(find.text(k).last);
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.tap(find.text('Send'));
    for (var f = 0; f < 3; f++) {
      await tester.pump(const Duration(seconds: 1));
    }
    expect(find.text('Confirm Transaction'), findsOneWidget);

    // Dragging the ruler left raises the amount, one birr per tick.
    await tester.timedDrag(
      find.text('100'),
      const Offset(-180, 0),
      const Duration(seconds: 2),
    );
    for (var f = 0; f < 3; f++) {
      await tester.pump(const Duration(seconds: 1));
    }
    final adjusted = tester
        .widgetList<Text>(find.byType(Text))
        .map((t) => int.tryParse(t.data ?? ''))
        .whereType<int>()
        .firstWhere((n) => n > 100);
    expect(adjusted, greaterThanOrEqualTo(115));
    expect(find.text('${adjusted + 2}.00'), findsOneWidget); // total

    await tester.ensureVisible(find.text('Confirm'));
    await tester.pump();
    await tester.tap(find.text('Confirm'));
    for (var f = 0; f < 4; f++) {
      await tester.pump(const Duration(seconds: 1));
    }
    expect(find.text('Transaction Successful'), findsOneWidget);
    expect(
      Wallet.balance.value,
      closeTo(before - adjusted - Wallet.fee, 0.001),
    );

    await tester.ensureVisible(find.text('Done'));
    await tester.pump();
    await tester.tap(find.text('Done'));
    for (var f = 0; f < 3; f++) {
      await tester.pump(const Duration(seconds: 1));
    }
    expect(find.text('Welcome back'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
