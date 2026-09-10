import 'package:maximize/database/app_database.dart';
import 'package:maximize/models/energy_model.dart';
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
    } catch (e) {
      debugPrint('Error creating energy entry: $e');
    }
  }

  Future<EnergyEntryModel?> getTodaysEntry() async {
    try {
      final now = DateTime.now();
      final rows = await _database.select(_database.energyEntries).get();
      final entry = rows.firstWhere(
        (e) =>
          e.timestamp.year == now.year &&
          e.timestamp.month == now.month &&
          e.timestamp.day == now.day,
        orElse: () => null as EnergyEntry,
      );
      if (entry == null) return null;
      return _rowToModel(entry);
    } catch (e) {
      debugPrint('Error fetching today\'s energy entry: $e');
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
    } catch (e) {
      debugPrint('Error updating energy entry: $e');
    }
  }

  Future<void> deleteEnergyEntry(String entryId) async {
    try {
      await (_database.delete(_database.energyEntries)
            ..where((e) => e.entryId.equals(entryId)))
          .go();
    } catch (e) {
      debugPrint('Error deleting energy entry: $e');
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
