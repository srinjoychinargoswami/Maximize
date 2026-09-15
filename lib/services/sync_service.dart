import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kinetic/database/app_database.dart';
import 'package:kinetic/services/encryption_service.dart';
import 'package:drift/drift.dart' as drift;

class SyncQueue {
  final String table;
  final String operation; // INSERT, UPDATE, DELETE
  final Map<String, dynamic> data;
  final String id;
  final DateTime timestamp;
  bool synced;

  SyncQueue({
    required this.table,
    required this.operation,
    required this.data,
    required this.id,
    required this.timestamp,
    this.synced = false,
  });

  Map<String, dynamic> toJson() => {
    'table': table,
    'operation': operation,
    'data': data,
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'synced': synced,
  };

  factory SyncQueue.fromJson(Map<String, dynamic> json) => SyncQueue(
    table: json['table'],
    operation: json['operation'],
    data: json['data'],
    id: json['id'],
    timestamp: DateTime.parse(json['timestamp']),
    synced: json['synced'] ?? false,
  );
}

class SyncService {
  static final SyncService _instance = SyncService._internal();
  static const String _supabaseUrl = '';
  static const String _anonKey = '';
  static const String _queueKey = 'sync_queue';

  factory SyncService() {
    return _instance;
  }

  SyncService._internal();

  List<SyncQueue> _queue = [];
  bool _isInitialized = false;
  bool _isSyncing = false;

  // Stream to notify UI when syncDown completes
  final _syncDownCompleted = StreamController<void>.broadcast();
  Stream<void> get onSyncDownCompleted => _syncDownCompleted.stream;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadQueue();
      _isInitialized = true;
      debugPrint('[SyncService] Initialized');

      // Auto-sync after initialization
      unawaited(_autoSync());
    } catch (e) {
      debugPrint('[SyncService] Init error: $e');
    }
  }

  /// Load queue from SharedPreferences
  Future<void> _loadQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getStringList(_queueKey) ?? [];
      _queue = queueJson
          .map((item) => SyncQueue.fromJson(jsonDecode(item)))
          .toList();
      debugPrint('[SyncService] Loaded ${_queue.length} items from queue');
    } catch (e) {
      debugPrint('[SyncService] Error loading queue: $e');
      _queue = [];
    }
  }

  /// Save queue to SharedPreferences
  Future<void> _saveQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = _queue.map((item) => jsonEncode(item.toJson())).toList();
      await prefs.setStringList(_queueKey, queueJson);
    } catch (e) {
      debugPrint('[SyncService] Error saving queue: $e');
    }
  }

  /// Add operation to queue
  Future<void> _enqueue(SyncQueue item) async {
    _queue.add(item);
    await _saveQueue();
    debugPrint('[SyncService] Enqueued: ${item.operation} ${item.table}/${item.id}');
  }

  /// Auto-sync unsynced items when online
  Future<void> _autoSync() async {
    if (_isSyncing) return;

    _isSyncing = true;
    try {
      final unsynced = _queue.where((item) => !item.synced).toList();
      for (final item in unsynced) {
        // Skip subtasks and old events - these tables no longer exist in Supabase
        if (item.table == 'subtasks' || item.table == 'events') {
          debugPrint('[SyncService] ⏭️  Skipping ${item.table} (table removed): ${item.id}');
          item.synced = true;
          continue;
        }

        try {
          await _syncItem(item);
          item.synced = true;
        } catch (e) {
          debugPrint('[SyncService] Sync failed for ${item.table}/${item.id}: $e');
        }
      }
      await _saveQueue();
    } finally {
      _isSyncing = false;
    }
  }

  /// Convert camelCase to lowercase (for Supabase)
  String _camelToLowercase(String text) {
    return text.toLowerCase();
  }

  /// Convert all field names from camelCase to lowercase
  Map<String, dynamic> _convertFieldNamesToLowercase(Map<String, dynamic> data) {
    final result = <String, dynamic>{};
    data.forEach((key, value) {
      result[_camelToLowercase(key)] = value;
    });
    return result;
  }

  /// Sensitive fields that should be encrypted in transit
  static const List<String> _sensitiveFields = [
    'title',
    'description',
    'content',
    'notes',
    'moodtags',
  ];

  /// Encrypt sensitive fields before sending to Supabase
  Future<Map<String, dynamic>> _encryptSensitiveFields(
    Map<String, dynamic> data,
  ) async {
    try {
      final encryptedData = Map<String, dynamic>.from(data);
      for (final field in _sensitiveFields) {
        if (encryptedData.containsKey(field) &&
            encryptedData[field] != null &&
            encryptedData[field] is String) {
          encryptedData[field] =
              await EncryptionService.instance.encryptString(encryptedData[field]);
          debugPrint('[SyncService] 🔒 Encrypted field: $field');
        }
      }
      return encryptedData;
    } catch (e) {
      debugPrint('[SyncService] ⚠️ Encryption error: $e');
      rethrow;
    }
  }

  /// Decrypt sensitive fields after receiving from Supabase
  Future<Map<String, dynamic>> _decryptSensitiveFields(
    Map<String, dynamic> data,
  ) async {
    try {
      final decryptedData = Map<String, dynamic>.from(data);
      for (final field in _sensitiveFields) {
        if (decryptedData.containsKey(field) &&
            decryptedData[field] != null &&
            decryptedData[field] is String) {
          try {
            decryptedData[field] =
                await EncryptionService.instance.decryptString(decryptedData[field]);
            debugPrint('[SyncService] 🔓 Decrypted field: $field');
          } catch (e) {
            debugPrint('[SyncService] Decryption failed for $field (may be plaintext): $e');
          }
        }
      }
      return decryptedData;
    } catch (e) {
      debugPrint('[SyncService] ⚠️ Decryption error: $e');
      return data;
    }
  }

  /// Convert all timestamp fields from DateTime or milliseconds to ISO 8601 strings
  void _convertTimestampsToIso(Map<String, dynamic> data) {
    final timestampFields = [
      'duedate',
      'completedat',
      'createdat',
      'updatedat',
      'startdatetime',
      'enddatetime',
      'scheduleddate',
      'recurrenceenddate',
      'remindertime',
      'timestamp',
    ];

    for (final field in timestampFields) {
      if (data.containsKey(field) && data[field] != null) {
        if (data[field] is DateTime) {
          try {
            data[field] = (data[field] as DateTime).toUtc().toIso8601String();
          } catch (e) {
            debugPrint('[SyncService] Error converting timestamp field $field: $e');
          }
        } else if (data[field] is int) {
          try {
            data[field] = DateTime.fromMillisecondsSinceEpoch(data[field] as int)
                .toUtc()
                .toIso8601String();
          } catch (e) {
            debugPrint('[SyncService] Error converting timestamp field $field: $e');
          }
        }
      }
    }
  }

  /// Get the primary key field name for a table (lowercase)
  String _getPrimaryKeyField(String table) {
    final primaryKeyMap = {
      'tasks': 'taskid',
      'events': 'eventid',
      'reminders': 'reminderid',
      'notes': 'noteid',
      'energy_entries': 'entryid',
      'completion_logs': 'logid',
    };
    return primaryKeyMap[table] ?? 'id';
  }

  /// Sync a single item to Supabase
  Future<void> _syncItem(SyncQueue item) async {
    final headers = {
      'Authorization': 'Bearer $_anonKey',
      'apikey': _anonKey,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final primaryKey = _getPrimaryKeyField(item.table);
    final url = '$_supabaseUrl/${item.table}?$primaryKey=eq.${item.id}';

    try {
      debugPrint('[SyncService] Syncing ${item.operation} ${item.table}/${item.id}');

      var data = Map<String, dynamic>.from(item.data);
      data = _convertFieldNamesToLowercase(data);
      _convertTimestampsToIso(data);

      // Encrypt sensitive fields before sending to Supabase
      data = await _encryptSensitiveFields(data);

      if (item.operation == 'DELETE') {
        await http.delete(
          Uri.parse(url),
          headers: headers,
        );
        debugPrint('[SyncService] ✅ DELETE succeeded: ${item.table}/${item.id}');
      } else if (item.operation == 'INSERT') {
        final insertData = {
          ...data,
          'id': item.id,
          primaryKey: item.id,
        };
        final response = await http.post(
          Uri.parse('$_supabaseUrl/${item.table}'),
          headers: headers,
          body: jsonEncode(insertData),
        );

        if (response.statusCode < 200 || response.statusCode >= 300) {
          throw Exception('HTTP ${response.statusCode}: ${response.body}');
        }
        debugPrint('[SyncService] ✅ INSERT succeeded: ${item.table}/${item.id}');
      } else if (item.operation == 'UPDATE') {
        final response = await http.patch(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(data),
        );

        if (response.statusCode < 200 || response.statusCode >= 300) {
          throw Exception('HTTP ${response.statusCode}: ${response.body}');
        }
        debugPrint('[SyncService] ✅ UPDATE succeeded: ${item.table}/${item.id}');
      }
    } catch (e) {
      debugPrint('[SyncService] ❌ Sync error: $e');
      rethrow;
    }
  }

  /// INSERT operation - writes locally, queues for sync
  Future<void> insert(String table, String id, Map<String, dynamic> data) async {
    try {
      await _enqueue(SyncQueue(
        table: table,
        operation: 'INSERT',
        data: data,
        id: id,
        timestamp: DateTime.now(),
      ));
      unawaited(_autoSync());
    } catch (e) {
      debugPrint('[SyncService] Insert error: $e');
    }
  }

  /// UPDATE operation - writes locally, queues for sync
  Future<void> update(String table, String id, Map<String, dynamic> data) async {
    try {
      await _enqueue(SyncQueue(
        table: table,
        operation: 'UPDATE',
        data: data,
        id: id,
        timestamp: DateTime.now(),
      ));
      unawaited(_autoSync());
    } catch (e) {
      debugPrint('[SyncService] Update error: $e');
    }
  }

  /// DELETE operation - queues for sync
  Future<void> delete(String table, String id) async {
    try {
      await _enqueue(SyncQueue(
        table: table,
        operation: 'DELETE',
        data: {},
        id: id,
        timestamp: DateTime.now(),
      ));
      unawaited(_autoSync());
    } catch (e) {
      debugPrint('[SyncService] Delete error: $e');
    }
  }

  /// Manually trigger sync of all unsynced items
  Future<void> syncAll() async {
    debugPrint('[SyncService] Manual sync triggered');
    await _autoSync();
  }

  /// Get queue status
  Map<String, int> getQueueStatus() {
    return {
      'total': _queue.length,
      'synced': _queue.where((item) => item.synced).length,
      'pending': _queue.where((item) => !item.synced).length,
    };
  }

  /// Clear synced items from queue
  Future<void> clearSyncedItems() async {
    _queue.removeWhere((item) => item.synced);
    await _saveQueue();
    debugPrint('[SyncService] Cleared synced items');
  }

  /// Convert lowercase to camelCase (for Drift)
  String _lowerToCamelCase(String text) {
    // Map lowercase field names to camelCase
    final camelCaseMap = {
      'taskid': 'taskId',
      'eventid': 'eventId',
      'reminderid': 'reminderId',
      'noteid': 'noteId',
      'entryid': 'entryId',
      'logid': 'logId',
      'createdat': 'createdAt',
      'updatedat': 'updatedAt',
      'completedat': 'completedAt',
      'duedate': 'dueDate',
      'startdatetime': 'startDateTime',
      'enddatetime': 'endDateTime',
      'scheduleddate': 'scheduledDate',
      'recurrenceenddate': 'recurrenceEndDate',
      'remindertime': 'reminderTime',
      'recurrencerule': 'recurrenceRule',
      'isrecurring': 'isRecurring',
      'customcategory': 'customCategory',
      'recurrencepattern': 'recurrencePattern',
      'recurrencecount': 'recurrenceCount',
      'recurrenceexceptiondates': 'recurrenceExceptionDates',
      'parenteventid': 'parentEventId',
      'reminderpreset': 'reminderPreset',
      'rememberenabled': 'reminderEnabled',
      'parenttaskid': 'parentTaskId',
      'maxoccurrences': 'maxOccurrences',
      'skipweekends': 'skipWeekends',
      'dayofmonth': 'dayOfMonth',
      'weekofmonth': 'weekOfMonth',
      'recurrenceinterval': 'recurrenceInterval',
      'daysofweek': 'daysOfWeek',
      'parentreminderid': 'parentReminderId',
      'energylevel': 'energyLevel',
      'moodtags': 'moodTags',
      'privacycontext': 'privacyContext',
      'tasktitle': 'taskTitle',
      'parenttasktitle': 'parentTaskTitle',
      'energyrequired': 'energyRequired',
      'pageid': 'pageId',
    };
    return camelCaseMap[text] ?? text;
  }

  /// Convert all field names from lowercase to camelCase (for Drift compatibility)
  Map<String, dynamic> _convertFieldNamesToCamelCase(Map<String, dynamic> data) {
    final result = <String, dynamic>{};
    data.forEach((key, value) {
      result[_lowerToCamelCase(key)] = value;
    });
    return result;
  }

  /// Convert ISO 8601 timestamp strings to DateTime
  dynamic _convertTimestampFromIso(dynamic value) {
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        debugPrint('[SyncService] Error parsing timestamp $value: $e');
        return value;
      }
    }
    return value;
  }

  /// Sync DOWN: Fetch all data from Supabase and populate Drift database
  Future<void> syncDown(AppDatabase db) async {
    debugPrint('[SyncService] Starting syncDown from Supabase...');

    final headers = {
      'Authorization': 'Bearer $_anonKey',
      'apikey': _anonKey,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      // CLEAR all old data from Drift before syncing fresh data
      debugPrint('[SyncService] Clearing all old data from Drift...');
      await db.reminders.delete().go();
      await db.tasks.delete().go();
      await db.events.delete().go();
      await db.notes.delete().go();
      await db.energyEntries.delete().go();
      await db.completionLogs.delete().go();
      debugPrint('[SyncService] ✅ Cleared all old data from Drift');

      // NOW sync fresh data from Supabase
      await _syncDownTable('tasks', headers, (data) async {
        await db.into(db.tasks).insertOnConflictUpdate(
          TasksCompanion(
            id: drift.Value(data['id'] ?? ''),
            taskId: drift.Value(data['taskId'] ?? ''),
            title: drift.Value(data['title'] ?? ''),
            description: drift.Value(data['description']),
            content: drift.Value(data['content']),
            dueDate: drift.Value(_convertTimestampFromIso(data['dueDate'])),
            completed: drift.Value(data['completed'] ?? false),
            completedAt: drift.Value(_convertTimestampFromIso(data['completedAt'])),
            category: drift.Value(data['category']),
            priority: drift.Value(data['priority'] ?? 'Low'),
            isRecurring: drift.Value(data['isRecurring'] ?? false),
            recurrenceRule: drift.Value(data['recurrenceRule']),
            recurrenceInterval: drift.Value(data['recurrenceInterval'] ?? 1),
            daysOfWeek: drift.Value(data['daysOfWeek']),
            recurrenceEndDate: drift.Value(_convertTimestampFromIso(data['recurrenceEndDate'])),
            parentTaskId: drift.Value(data['parentTaskId']),
            maxOccurrences: drift.Value(data['maxOccurrences']),
            skipWeekends: drift.Value(data['skipWeekends'] ?? false),
            dayOfMonth: drift.Value(data['dayOfMonth']),
            weekOfMonth: drift.Value(data['weekOfMonth']),
            reminderEnabled: drift.Value(data['reminderEnabled'] ?? false),
            reminderTime: drift.Value(_convertTimestampFromIso(data['reminderTime'])),
            reminderPreset: drift.Value(data['reminderPreset']),
            energyRequired: drift.Value(data['energyRequired'] ?? 5),
            pageId: drift.Value(data['pageId']),
            createdAt: drift.Value(_convertTimestampFromIso(data['createdAt']) ?? DateTime.now()),
            updatedAt: drift.Value(_convertTimestampFromIso(data['updatedAt']) ?? DateTime.now()),
          ),
        );
      });

      await _syncDownTable('events', headers, (data) async {
        await db.into(db.events).insertOnConflictUpdate(
          EventsCompanion(
            id: drift.Value(data['id'] ?? ''),
            eventId: drift.Value(data['eventId'] ?? ''),
            title: drift.Value(data['title'] ?? ''),
            description: drift.Value(data['description']),
            startDateTime: drift.Value(_convertTimestampFromIso(data['startDateTime']) ?? DateTime.now()),
            endDateTime: drift.Value(_convertTimestampFromIso(data['endDateTime']) ?? DateTime.now()),
            scheduledDate: drift.Value(_convertTimestampFromIso(data['scheduledDate']) ?? DateTime.now()),
            customCategory: drift.Value(data['customCategory']),
            color: drift.Value(data['color']),
            completed: drift.Value(data['completed'] ?? false),
            completedAt: drift.Value(_convertTimestampFromIso(data['completedAt'])),
            isRecurring: drift.Value(data['isRecurring'] ?? false),
            recurrencePattern: drift.Value(data['recurrencePattern']),
            recurrenceRule: drift.Value(data['recurrenceRule']),
            recurrenceCount: drift.Value(data['recurrenceCount']),
            recurrenceEndDate: drift.Value(_convertTimestampFromIso(data['recurrenceEndDate'])),
            recurrenceExceptionDates: drift.Value(data['recurrenceExceptionDates']),
            parentEventId: drift.Value(data['parentEventId']),
            reminderEnabled: drift.Value(data['reminderEnabled'] ?? false),
            reminderTime: drift.Value(_convertTimestampFromIso(data['reminderTime'])),
            reminderPreset: drift.Value(data['reminderPreset']),
            createdAt: drift.Value(_convertTimestampFromIso(data['createdAt']) ?? DateTime.now()),
            updatedAt: drift.Value(_convertTimestampFromIso(data['updatedAt']) ?? DateTime.now()),
          ),
        );
      });

      await _syncDownTable('notes', headers, (data) async {
        await db.into(db.notes).insertOnConflictUpdate(
          NotesCompanion(
            id: drift.Value(data['id'] ?? ''),
            noteId: drift.Value(data['noteId'] ?? ''),
            title: drift.Value(data['title'] ?? ''),
            content: drift.Value(data['content'] ?? ''),
            createdAt: drift.Value(_convertTimestampFromIso(data['createdAt']) ?? DateTime.now()),
            updatedAt: drift.Value(_convertTimestampFromIso(data['updatedAt']) ?? DateTime.now()),
          ),
        );
      });

      await _syncDownTable('reminders', headers, (data) async {
        debugPrint('[SyncService] Processing reminder: ${data['id']} - ${data['title']}');
        await db.into(db.reminders).insertOnConflictUpdate(
          RemindersCompanion(
            id: drift.Value(data['id'] ?? ''),
            reminderId: drift.Value(data['reminderId'] ?? ''),
            title: drift.Value(data['title'] ?? ''),
            description: drift.Value(data['description']),
            reminderTime: drift.Value(_convertTimestampFromIso(data['reminderTime'])),
            isRecurring: drift.Value(data['isRecurring'] ?? false),
            recurrenceRule: drift.Value(data['recurrenceRule']),
            recurrenceInterval: drift.Value(data['recurrenceInterval'] ?? 1),
            daysOfWeek: drift.Value(data['daysOfWeek']),
            recurrenceEndDate: drift.Value(_convertTimestampFromIso(data['recurrenceEndDate'])),
            parentReminderId: drift.Value(data['parentReminderId']),
            maxOccurrences: drift.Value(data['maxOccurrences']),
            createdAt: drift.Value(_convertTimestampFromIso(data['createdAt']) ?? DateTime.now()),
            updatedAt: drift.Value(_convertTimestampFromIso(data['updatedAt']) ?? DateTime.now()),
          ),
        );
        debugPrint('[SyncService] ✅ Inserted reminder: ${data['id']}');
      });

      await _syncDownTable('energy_entries', headers, (data) async {
        await db.into(db.energyEntries).insertOnConflictUpdate(
          EnergyEntriesCompanion(
            id: drift.Value(data['id'] ?? ''),
            entryId: drift.Value(data['entryId'] ?? ''),
            timestamp: drift.Value(_convertTimestampFromIso(data['timestamp']) ?? DateTime.now()),
            energyLevel: drift.Value(data['energyLevel'] ?? 5),
            moodTags: drift.Value(data['moodTags']),
            privacyContext: drift.Value(data['privacyContext']),
            location: drift.Value(data['location']),
            notes: drift.Value(data['notes']),
            createdAt: drift.Value(_convertTimestampFromIso(data['createdAt']) ?? DateTime.now()),
            updatedAt: drift.Value(_convertTimestampFromIso(data['updatedAt']) ?? DateTime.now()),
          ),
        );
      });

      await _syncDownTable('completion_logs', headers, (data) async {
        await db.into(db.completionLogs).insertOnConflictUpdate(
          CompletionLogsCompanion(
            id: drift.Value(data['id'] ?? ''),
            logId: drift.Value(data['logId'] ?? ''),
            taskId: drift.Value(data['taskId']),
            taskTitle: drift.Value(data['taskTitle'] ?? ''),
            description: drift.Value(data['description']),
            category: drift.Value(data['category']),
            priority: drift.Value(data['priority']),
            completedAt: drift.Value(_convertTimestampFromIso(data['completedAt']) ?? DateTime.now()),
            parentTaskTitle: drift.Value(data['parentTaskTitle']),
            energyLevel: drift.Value(data['energyLevel']),
            moodTags: drift.Value(data['moodTags']),
            privacyContext: drift.Value(data['privacyContext']),
            location: drift.Value(data['location']),
            createdAt: drift.Value(_convertTimestampFromIso(data['createdAt']) ?? DateTime.now()),
          ),
        );
      });

      // Verify data was inserted into Drift
      final remindersCount = await db.reminders.select().get();
      final tasksCount = await db.tasks.select().get();
      final eventsCount = await db.events.select().get();

      debugPrint('[SyncService] ✅ syncDown completed successfully');
      debugPrint('[SyncService] Drift database after sync: ${remindersCount.length} reminders, ${tasksCount.length} tasks, ${eventsCount.length} events');

      // Notify listeners that syncDown completed
      _syncDownCompleted.add(null);
    } catch (e) {
      debugPrint('[SyncService] ❌ syncDown error: $e');
      rethrow;
    }
  }

  /// Helper: Fetch a table from Supabase and process each row
  Future<void> _syncDownTable(
    String table,
    Map<String, String> headers,
    Future<void> Function(Map<String, dynamic>) processor,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$_supabaseUrl/$table'),
        headers: headers,
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }

      final rows = jsonDecode(response.body) as List<dynamic>;
      debugPrint('[SyncService] Fetched ${rows.length} rows from $table');

      for (final row in rows) {
        var data = row as Map<String, dynamic>;
        // Decrypt sensitive fields after receiving from Supabase
        data = await _decryptSensitiveFields(data);
        data = _convertFieldNamesToCamelCase(data);
        await processor(data);
      }
    } catch (e) {
      debugPrint('[SyncService] Error syncing table $table: $e');
      rethrow;
    }
  }
}
