import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kinetic/services/sync_service.dart';
import 'package:kinetic/database/app_database.dart';
import 'package:kinetic/screens/home_page.dart';
import 'package:kinetic/services/task_service.dart';
import 'package:kinetic/services/calendar_service.dart';
import 'package:kinetic/services/event_service.dart';
import 'package:kinetic/services/reminder_service.dart';
import 'package:kinetic/services/note_service.dart';
import 'package:kinetic/services/energy_service.dart';
import 'package:kinetic/services/completion_log_service.dart';
import 'package:kinetic/services/encryption_service.dart';
import 'package:kinetic/services/notification_service.dart';
import 'package:kinetic/services/metrics_service.dart';
import 'package:kinetic/services/energy_analytics_service.dart';
import 'package:kinetic/config/theme_config.dart';
import 'package:kinetic/providers/theme_notifier.dart';
import 'package:kinetic/services/database_encryption_service.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone for notifications
  tz_data.initializeTimeZones();

  // Initialize Supabase for REST API sync
  try {
    await Supabase.initialize(
      url: '',
      anonKey: '',
    );
    debugPrint('[Main] Supabase initialized');
  } catch (e) {
    debugPrint('[Main] Supabase initialization error: $e');
    // App continues even if Supabase fails
  }

  // Initialize Drift database
  final database = AppDatabase();
  debugPrint('[Main] Drift database initialized');

  // Log encryption/storage platform info
  DatabaseEncryptionService.instance.logStorageInfo();

  // Initialize encryption service
  try {
    await EncryptionService.instance.initialize();
    debugPrint('[Main] Encryption service initialized');
  } catch (e) {
    debugPrint('[Main] Encryption initialization error: $e');
    // App continues even if encryption setup fails
  }

  // Initialize SyncService for Supabase REST API sync
  try {
    await SyncService().initialize();
    debugPrint('[Main] SyncService initialized');
  } catch (e) {
    debugPrint('[Main] SyncService initialization error: $e');
    // App continues even if SyncService fails to initialize
  }

  // Sync DOWN: Fetch all data from Supabase
  try {
    await SyncService().syncDown(database);
    debugPrint('[Main] syncDown completed - pulled latest data from Supabase');
  } catch (e) {
    debugPrint('[Main] syncDown error: $e');
    // App continues even if syncDown fails
  }

  // Start periodic sync every 5 minutes
  Timer.periodic(Duration(minutes: 5), (_) async {
    try {
      debugPrint('[Main] Running periodic syncDown...');
      await SyncService().syncDown(database);
    } catch (e) {
      debugPrint('[Main] Periodic syncDown error: $e');
    }
  });

  // Initialize notification service for all platforms
  try {
    await NotificationService.instance.initialize();
    debugPrint('[Main] Notification service initialized');
  } catch (e) {
    debugPrint('[Main] Notification service initialization error: $e');
    // App continues even if notifications fail to initialize
  }

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
            title: 'Kinetic',
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