import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:maximize/firebase_options.dart';
import 'package:maximize/database/app_database.dart';
import 'package:maximize/screens/home_page.dart';
import 'package:maximize/services/task_service.dart';
import 'package:maximize/services/calendar_service.dart';
import 'package:maximize/services/event_service.dart';
import 'package:maximize/services/reminder_service.dart';
import 'package:maximize/services/note_service.dart';
import 'package:maximize/services/energy_service.dart';
import 'package:maximize/services/completion_log_service.dart';
import 'package:maximize/services/firebase_realtime_sync_service.dart';
import 'package:maximize/services/encryption_service.dart';
import 'package:maximize/services/metrics_service.dart';
import 'package:maximize/services/energy_analytics_service.dart';
import 'package:maximize/config/theme_config.dart';
import 'package:maximize/providers/theme_notifier.dart';
import 'package:maximize/services/database_encryption_service.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone for notifications
  tz_data.initializeTimeZones();

  // Initialize Drift database FIRST
  final database = AppDatabase();
  debugPrint('[Main] Drift database initialized');

  // Log encryption/storage platform info
  DatabaseEncryptionService.instance.logStorageInfo();

  // CRITICAL: Initialize encryption service SECOND
  // Must be done before Firebase listeners start decrypting data
  try {
    await EncryptionService.instance.initialize();
    debugPrint('[Main] Encryption service initialized');
  } catch (e) {
    debugPrint('[Main] Encryption initialization error: $e');
    // App continues even if encryption setup fails
  }

     // Initialize Firebase (only on native platforms)
  if (!kIsWeb) {
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
  }

  // TODO: Initialize notification service once it's been properly migrated
  // await NotificationService.instance.initialize();

  // Request POST_NOTIFICATIONS permission for Android 13+ (native only)
  if (!kIsWeb && Platform.isAndroid) {
    try {
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
    } catch (e) {
      debugPrint('[Main] Notification permission request error: $e');
    }
  }
  
  // Initialize theme notifier
  final themeNotifier = ThemeNotifier();
  await themeNotifier.initialize();

  // Start the app
  runApp(MyApp(themeNotifier: themeNotifier, database: database));
}

class MyApp extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  final AppDatabase database;
  const MyApp({super.key, required this.themeNotifier, required this.database});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeNotifier),
        Provider<AppDatabase>.value(value: database),
        ProxyProvider<AppDatabase, TaskService>(
          create: (_) => TaskService(database),
          update: (_, db, __) => TaskService(db),
        ),
        ProxyProvider<AppDatabase, CalendarService>(
          create: (_) => CalendarService(database),
          update: (_, db, __) => CalendarService(db),
        ),
        ProxyProvider<AppDatabase, EventService>(
          create: (_) => EventService(database),
          update: (_, db, __) => EventService(db),
        ),
        ProxyProvider<AppDatabase, ReminderService>(
          create: (_) => ReminderService(database),
          update: (_, db, __) => ReminderService(db),
        ),
        ProxyProvider<AppDatabase, NoteService>(
          create: (_) => NoteService(database),
          update: (_, db, __) => NoteService(db),
        ),
        ProxyProvider<AppDatabase, EnergyService>(
          create: (_) => EnergyService(database),
          update: (_, db, __) => EnergyService(db),
        ),
        ProxyProvider<AppDatabase, CompletionLogService>(
          create: (_) => CompletionLogService(database),
          update: (_, db, __) => CompletionLogService(db),
        ),
        ProxyProvider2<AppDatabase, CompletionLogService, MetricsService>(
          create: (_) => MetricsService(database, CompletionLogService(database)),
          update: (_, db, completionLog, __) => MetricsService(db, completionLog),
        ),
        ProxyProvider<EnergyService, EnergyAnalyticsService>(
          create: (_) => EnergyAnalyticsService(EnergyService(database)),
          update: (_, energyService, __) => EnergyAnalyticsService(energyService),
        ),
      ],
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