import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinetic/main.dart';
import 'package:kinetic/providers/theme_notifier.dart';
import 'package:kinetic/database/app_database.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final themeNotifier = ThemeNotifier();
    final database = AppDatabase();

    await tester.pumpWidget(MyApp(themeNotifier: themeNotifier, database: database));

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
