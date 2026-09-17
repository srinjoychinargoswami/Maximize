import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as p;
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
import 'package:kinetic/services/deep_link_service.dart';
import 'package:kinetic/screens/onboarding_flow_wrapper.dart';

// Global environment variables map - accessible from other files
final Map<String, String> envVars = {};

String getEnv(String key, {String defaultValue = ''}) {
  return envVars[key] ?? defaultValue;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file FIRST, before any code uses environment variables
  await _loadEnvironmentFile();
  print('[Main] ✓ .env loaded');

  // Initialize timezone for notifications
  tz_data.initializeTimeZones();

  // Initialize EncryptionService EARLY (before SyncService uses it)
  try {
    await EncryptionService.instance.initialize();
    print('[Main] ✅ EncryptionService initialized');
  } catch (e) {
    print('[Main] ⚠️ EncryptionService init failed: $e (continuing without encryption)');
  }

  // Log encryption/storage platform info
  DatabaseEncryptionService.instance.logStorageInfo();

  // Initialize Supabase for REST API sync
  try {
    // Load from environment (priority: dart-define > .env)
    var supabaseUrl = const String.fromEnvironment('SUPABASE_URL', defaultValue: '');
    var anonKey = const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

    // Fallback to envVars if dart-define not set
    if (supabaseUrl.isEmpty) {
      supabaseUrl = envVars['SUPABASE_URL'] ?? '';
      if (supabaseUrl.isNotEmpty) {
        print('[Main] Loaded SUPABASE_URL from .env');
      }
    } else {
      print('[Main] Loaded SUPABASE_URL from dart-define (production)');
    }

    if (anonKey.isEmpty) {
      anonKey = envVars['SUPABASE_ANON_KEY'] ?? '';
      if (anonKey.isNotEmpty) {
        print('[Main] Loaded SUPABASE_ANON_KEY from .env');
      }
    } else {
      print('[Main] Loaded SUPABASE_ANON_KEY from dart-define (production)');
    }

    if (supabaseUrl.isEmpty || anonKey.isEmpty) {
      print('[!] WARNING: Supabase credentials missing!');
      print('[!] For development: ensure .env file exists');
      print('[!] For production: build with: flutter build --dart-define SUPABASE_URL=... --dart-define SUPABASE_ANON_KEY=...');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: anonKey,
    );
    print('[Main] ✅ Supabase initialized');
  } catch (e) {
    print('[Main] ❌ Supabase initialization error: $e');
    // App continues even if Supabase fails
  }

  // Initialize Drift database
  final database = AppDatabase();
  print('[Main] ✅ Drift database initialized');

  // Initialize deep link handler for auth callbacks
  try {
    await DeepLinkService.initialize();
    print('[Main] ✅ DeepLinkService initialized');
  } catch (e) {
    print('[Main] ⚠️ DeepLinkService initialization error: $e');
  }

  // Initialize SyncService for Supabase REST API sync
  try {
    await SyncService().initialize();
    print('[Main] ✅ SyncService initialized');
  } catch (e) {
    print('[Main] ⚠️ SyncService initialization error: $e');
    // App continues even if SyncService fails to initialize
  }

  // Sync DOWN: Fetch all data from Supabase (now EncryptionService is ready)
  try {
    await SyncService().syncDown(database);
    print('[Main] ✅ syncDown completed - pulled latest data from Supabase');
  } catch (e) {
    print('[Main] ⚠️ syncDown error: $e (app continues offline)');
    // App continues even if syncDown fails
  }

  // Start periodic sync every 5 minutes
  Timer.periodic(const Duration(minutes: 5), (_) async {
    try {
      print('[Main] Running periodic syncDown...');
      await SyncService().syncDown(database);
    } catch (e) {
      print('[Main] Periodic syncDown error: $e');
    }
  });

  // Initialize notification service for all platforms
  try {
    await NotificationService.instance.initialize();
    print('[Main] ✅ NotificationService initialized');
  } catch (e) {
    print('[Main] ⚠️ NotificationService initialization error: $e');
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
      print('[Main] ⚠️ Notification permission request error: $e');
    }
  }

  // Initialize theme notifier
  final themeNotifier = ThemeNotifier();
  await themeNotifier.initialize();

  // Start the app
  runApp(MyApp(themeNotifier: themeNotifier, database: database));
}

Future<void> _loadEnvironmentFile() async {
  final currentDir = Directory.current.path;
  final envFile = File(p.join(currentDir, '.env'));

  print('[DEBUG] Working directory: $currentDir');
  print('[DEBUG] Looking for .env at: ${envFile.path}');
  print('[DEBUG] .env exists: ${envFile.existsSync()}');

  if (!envFile.existsSync()) {
    print('[!] .env file not found at: ${envFile.path}');
    print('[!] App will continue without environment variables');
    return;
  }

  try {
    print('[DEBUG] Reading .env file directly...');
    final content = envFile.readAsStringSync();
    print('[DEBUG] Content length: ${content.length} chars');

    // Parse and store in a local map
    final envMap = <String, String>{};
    final lines = content.split(RegExp(r'\r?\n'));

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('#')) continue;

      final eqIndex = line.indexOf('=');
      if (eqIndex > 0) {
        final key = line.substring(0, eqIndex).trim();
        final value = line.substring(eqIndex + 1).trim();
        envMap[key] = value;
        print('[ENV] ✓ Parsed $key');
      }
    }

    print('[✓] .env parsed successfully (${envMap.length} vars)');

    // Store in global envVars map (doesn't rely on dotenv.env)
    for (final entry in envMap.entries) {
      envVars[entry.key] = entry.value;
      print('[ENV] Stored ${entry.key}');
    }

    _debugPrintEnvVars();
  } catch (e) {
    print('[!] Error reading .env: $e');
    print('[!] App will continue without environment variables');
  }
}

void _debugPrintEnvVars() {
  final keysToShow = [
    'SUPABASE_URL',
    'SUPABASE_ANON_KEY',
    'ENCRYPTION_MASTER_KEY',
    'ENCRYPTION_IV',
    'XOR_SECRET_KEY',
    'APP_ENV',
  ];

  print('[DEBUG] === Environment Variables ===');
  for (final key in keysToShow) {
    final value = envVars[key];
    if (value != null) {
      if (key.contains('KEY') || key.contains('ANON')) {
        print('[DEBUG] $key: ${value.substring(0, (value.length > 10 ? 10 : value.length))}...');
      } else {
        print('[DEBUG] $key: $value');
      }
    } else {
      print('[DEBUG] $key: <not set>');
    }
  }
  print('[DEBUG] =====================================');
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
            home: const OnboardingFlowWrapper(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}