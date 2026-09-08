import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:maximize/models/database.dart';
import 'package:maximize/screens/home_page.dart';
import 'package:maximize/services/reminder_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone for notifications
  tz_data.initializeTimeZones();

  // Initialize your NotificationService (singleton)
  await NotificationService.instance.initialize();

  // Request POST_NOTIFICATIONS permission for Android 13+
  if (Platform.isAndroid) {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  // Initialize Drift database
  final database = AppDatabase.instance;

  // Start the app
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;
  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maximize',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[850],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[800],
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.grey, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
      home: MyHomePage(database: database),
    );
  }
}