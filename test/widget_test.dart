import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maximize/main.dart';
import 'package:maximize/providers/theme_notifier.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final themeNotifier = ThemeNotifier();

    await tester.pumpWidget(MyApp(themeNotifier: themeNotifier));

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
