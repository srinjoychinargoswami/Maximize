import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:maximize/firebase_options.dart';
import 'package:maximize/database/isar_database_service.dart';
import 'package:maximize/screens/home_page.dart';
import 'package:maximize/services/reminder_service.dart';
import 'package:maximize/services/firebase_realtime_sync_service.dart';
import 'package:maximize/services/encryption_service.dart';
import 'package:maximize/config/theme_config.dart';
import 'package:maximize/providers/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone for notifications
  tz_data.initializeTimeZones();

  // Initialize Isar database FIRST
  try {
    await IsarDatabaseService.initialize();
    debugPrint('[Main] Isar database initialized');
  } catch (e) {
    debugPrint('[Main] Isar initialization error: $e');
    rethrow;
  }

  // CRITICAL: Initialize encryption service SECOND
  // Must be done before Firebase listeners start decrypting data
  try {
    await EncryptionService.instance.initialize();
    debugPrint('[Main] Encryption service initialized');
  } catch (e) {
    debugPrint('[Main] Encryption initialization error: $e');
    // App continues even if encryption setup fails
  }

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Initialize Firebase Realtime Database sync service
    await FirebaseRealtimeSyncService.instance.initialize();
  } catch (e) {
    debugPrint('[Firebase] Initialization error: $e');
    // App continues even if Firebase fails to initialize
  }

  // Initialize your NotificationService (singleton)
  await NotificationService.instance.initialize();

  // Request POST_NOTIFICATIONS permission for Android 13+
  if (Platform.isAndroid) {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  // Initialize theme notifier
  final themeNotifier = ThemeNotifier();
  await themeNotifier.initialize();

  // Start the app
  runApp(MyApp(themeNotifier: themeNotifier));
}

class MyApp extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  const MyApp({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: themeNotifier,
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, _) {
          return MaterialApp(
            title: 'Maximize',
            theme: ThemeConfig.buildLightTheme(context),
            darkTheme: ThemeConfig.buildDarkTheme(context),
            themeMode: themeNotifier.themeMode,
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}