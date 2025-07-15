import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maximize/main.dart'; // Ensure this imports MyApp correctly
import 'package:maximize/models/database.dart';
import 'package:maximize/services/api_service.dart'; // Import database.dart
import 'package:maximize/services/api_service.dart'; // Import database.dart


void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create a mock database instance
    final database = AppDatabase.instance;
    final apiService = ApiService(db:database); //Add this line
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(database: database, apiService: apiService));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}