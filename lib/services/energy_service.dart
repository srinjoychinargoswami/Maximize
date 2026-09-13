import 'package:kinetic/database/app_database.dart';
import 'package:kinetic/models/energy_model.dart';
import 'package:kinetic/utils/web_persistence_helper.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';

class EnergyService {
  final AppDatabase _database;

  EnergyService(this._database);

  Future<void> createEnergyEntry({
    required int energyLevel,
    required List<String> moodTags,
    required String privacyContext,
    required String location,
    String? notes,
  }) async {
    final entryId = const Uuid().v4();
    final now = DateTime.now();

    try {
      await _database.transaction(() async {
        await _database.into(_database.energyEntries).insert(
          EnergyEntriesCompanion(
            id: Value(entryId),
            entryId: Value(entryId),
            timestamp: Value(now),
            energyLevel: Value(energyLevel.clamp(1, 10)),
            moodTags: Value(moodTags.join(',')),
            privacyContext: Value(privacyContext),
            location: Value(location),
            notes: Value(notes),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
      });
      await WebPersistenceHelper.flush();
      WebPersistenceHelper.logPersistence('[EnergyService] Energy entry created: $entryId (persisted to IndexedDB)');
    } catch (e) {
      debugPrint('Error creating energy entry: $e');
    }
  }

  Future<EnergyEntryModel?> getTodaysEntry() async {
    try {
      final now = DateTime.now();
      final rows = await _database.select(_database.energyEntries).get();
      final todayEntries = rows
          .where((e) =>
            e.timestamp.year == now.year &&
            e.timestamp.month == now.month &&
            e.timestamp.day == now.day)
          .toList();

      if (todayEntries.isEmpty) return null;
      return _rowToModel(todayEntries.first);
    } catch (e) {
      debugPrint('Error fetching today\'s energy entry: $e');
      return null;
    }
  }

  Future<EnergyEntryModel?> getTodayLatestEnergy() async {
    try {
      final now = DateTime.now();
      final rows = await _database.select(_database.energyEntries).get();
      final todayEntries = rows
          .where((e) =>
            e.timestamp.year == now.year &&
            e.timestamp.month == now.month &&
            e.timestamp.day == now.day)
          .toList();

      if (todayEntries.isEmpty) return null;

      todayEntries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return _rowToModel(todayEntries.first);
    } catch (e) {
      debugPrint('Error fetching today\'s latest energy entry: $e');
      return null;
    }
  }

  Future<List<EnergyEntryModel>> getEntriesPast30Days() async {
    try {
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));
      final rows = await _database.select(_database.energyEntries).get();
      return rows
          .where((e) => e.timestamp.isAfter(thirtyDaysAgo) && e.timestamp.isBefore(now))
          .map(_rowToModel)
          .toList();
    } catch (e) {
      debugPrint('Error fetching past 30 days entries: $e');
      return [];
    }
  }

  Future<List<EnergyEntryModel>> getEntriesByDate(DateTime date) async {
    try {
      final rows = await _database.select(_database.energyEntries).get();
      return rows
          .where((e) =>
            e.timestamp.year == date.year &&
            e.timestamp.month == date.month &&
            e.timestamp.day == date.day)
          .map(_rowToModel)
          .toList();
    } catch (e) {
      debugPrint('Error fetching entries by date: $e');
      return [];
    }
  }

  Future<void> updateEnergyEntry(String entryId, {
    required int energyLevel,
    List<String>? moodTags,
    String? privacyContext,
    String? location,
    String? notes,
  }) async {
    try {
      await _database.transaction(() async {
        await (_database.update(_database.energyEntries)
              ..where((e) => e.entryId.equals(entryId)))
            .write(EnergyEntriesCompanion(
              energyLevel: Value(energyLevel.clamp(1, 10)),
              moodTags: moodTags != null ? Value(moodTags.join(',')) : const Value.absent(),
              privacyContext: privacyContext != null ? Value(privacyContext) : const Value.absent(),
              location: location != null ? Value(location) : const Value.absent(),
              notes: notes != null ? Value(notes) : const Value.absent(),
              updatedAt: Value(DateTime.now()),
            ));
      });
      await WebPersistenceHelper.flush();
      WebPersistenceHelper.logPersistence('[EnergyService] Energy entry updated: $entryId');
    } catch (e) {
      debugPrint('Error updating energy entry: $e');
    }
  }

  Future<void> deleteEnergyEntry(String entryId) async {
    try {
      await _database.transaction(() async {
        await (_database.delete(_database.energyEntries)
              ..where((e) => e.entryId.equals(entryId)))
            .go();
      });
      await WebPersistenceHelper.flush();
      WebPersistenceHelper.logPersistence('[EnergyService] Energy entry deleted: $entryId');
    } catch (e) {
      debugPrint('Error deleting energy entry: $e');
    }
  }

  Future<List<EnergyEntryModel>> getLastSevenDaysEnergy() async {
    try {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      final rows = await _database.select(_database.energyEntries).get();
      return rows
          .where((e) => e.timestamp.isAfter(sevenDaysAgo) && e.timestamp.isBefore(now))
          .map(_rowToModel)
          .toList();
    } catch (e) {
      debugPrint('Error fetching past 7 days entries: $e');
      return [];
    }
  }

  Future<double> getAverageEnergyLevel() async {
    try {
      final entries = await getLastSevenDaysEnergy();
      if (entries.isEmpty) return 0.0;
      final sum = entries.fold<double>(0, (acc, e) => acc + e.energyLevel);
      return sum / entries.length;
    } catch (e) {
      debugPrint('Error calculating average energy level: $e');
      return 0.0;
    }
  }

  Future<({TimeOfDay start, TimeOfDay end})> getPeakEnergyWindow() async {
    try {
      final entries = await getLastSevenDaysEnergy();
      if (entries.isEmpty) {
        return (start: const TimeOfDay(hour: 10, minute: 0), end: const TimeOfDay(hour: 13, minute: 0));
      }

      // Group entries by hour and calculate average energy for each hour
      Map<int, List<int>> hourlyEnergy = {};
      for (var entry in entries) {
        final hour = entry.timestamp.hour;
        hourlyEnergy.putIfAbsent(hour, () => []).add(entry.energyLevel);
      }

      // Find hour with highest average energy
      int peakHour = 22; // Default to 10 PM
      double maxAvgEnergy = 0;
      hourlyEnergy.forEach((hour, energyLevels) {
        final avg = energyLevels.fold<double>(0, (a, b) => a + b) / energyLevels.length;
        if (avg > maxAvgEnergy) {
          maxAvgEnergy = avg;
          peakHour = hour;
        }
      });

      // Return 3-hour window centered on peak hour
      final startHour = (peakHour - 1) % 24;
      final endHour = (peakHour + 2) % 24;

      return (
        start: TimeOfDay(hour: startHour, minute: 0),
        end: TimeOfDay(hour: endHour, minute: 0),
      );
    } catch (e) {
      debugPrint('Error calculating peak energy window: $e');
      return (start: const TimeOfDay(hour: 22, minute: 0), end: const TimeOfDay(hour: 1, minute: 0));
    }
  }

  EnergyEntryModel _rowToModel(EnergyEntry row) {
    return EnergyEntryModel(
      id: row.entryId,
      timestamp: row.timestamp,
      energyLevel: row.energyLevel,
      moodTags: row.moodTags?.split(',') ?? [],
      privacyContext: row.privacyContext ?? '',
      location: row.location ?? '',
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
