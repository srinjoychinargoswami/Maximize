import 'package:maximize/models/database.dart';
import 'package:maximize/models/energy_model.dart';
import 'package:uuid/uuid.dart';

class EnergyService {
  final AppDatabase _database;

  EnergyService(this._database);

  /// Create a new energy entry
  Future<void> createEnergyEntry({
    required int energyLevel,
    required List<String> moodTags,
    required String privacyContext,
    required String location,
    String? notes,
  }) async {
    final entry = EnergyEntry(
      id: const Uuid().v4(),
      timestamp: DateTime.now(),
      energyLevel: energyLevel.clamp(1, 10),
      moodTags: moodTags.join(','),
      privacyContext: privacyContext,
      location: location,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: null,
    );

    await _database.insertEnergyEntry(entry);
  }

  /// Get today's energy entry if it exists
  Future<EnergyEntryModel?> getTodaysEntry() async {
    final entry = await _database.getTodaysEntry();
    if (entry == null) return null;
    return _convertToModel(entry);
  }

  /// Get energy entries from the past 30 days
  Future<List<EnergyEntryModel>> getEntriesPast30Days() async {
    final entries = await _database.getEntriesPast30Days();
    return entries.map(_convertToModel).toList();
  }

  /// Get energy entries for a specific date
  Future<List<EnergyEntryModel>> getEntriesByDate(DateTime date) async {
    final entries = await _database.getEntriesByDate(date);
    return entries.map(_convertToModel).toList();
  }

  /// Get all energy entries
  Future<List<EnergyEntryModel>> getAllEntries() async {
    final entries = await _database.getAllEnergyEntries();
    return entries.map(_convertToModel).toList();
  }

  /// Update an energy entry
  Future<void> updateEnergyEntry(
    String id, {
    int? energyLevel,
    List<String>? moodTags,
    String? privacyContext,
    String? location,
    String? notes,
  }) async {
    final currentEntry = await _database.getEnergyEntry(id);
    if (currentEntry == null) throw Exception('Energy entry not found');

    // Create updated entry with new values
    final updated = EnergyEntry(
      id: currentEntry.id,
      timestamp: currentEntry.timestamp,
      energyLevel: energyLevel != null ? energyLevel.clamp(1, 10) : currentEntry.energyLevel,
      moodTags: moodTags != null ? moodTags.join(',') : currentEntry.moodTags,
      privacyContext: privacyContext ?? currentEntry.privacyContext,
      location: location ?? currentEntry.location,
      notes: notes ?? currentEntry.notes,
      createdAt: currentEntry.createdAt,
      updatedAt: DateTime.now(),
      userId: currentEntry.userId,
    );

    await _database.updateEnergyEntry(updated);
  }

  /// Delete an energy entry
  Future<void> deleteEnergyEntry(String id) async {
    await _database.deleteEnergyEntry(id);
  }

  /// Get average energy level for the past 30 days
  Future<double> getAverageEnergyPast30Days() async {
    final entries = await _database.getEntriesPast30Days();
    if (entries.isEmpty) return 0.0;

    final sum = entries.fold<int>(0, (sum, entry) => sum + entry.energyLevel);
    return sum / entries.length;
  }

  /// Get the most common mood in the past 30 days
  Future<String?> getMostCommonMood() async {
    final entries = await _database.getEntriesPast30Days();
    if (entries.isEmpty) return null;

    final moodCounts = <String, int>{};
    for (final entry in entries) {
      final moods = entry.moodTags.split(',');
      for (final mood in moods) {
        final trimmed = mood.trim();
        moodCounts[trimmed] = (moodCounts[trimmed] ?? 0) + 1;
      }
    }

    if (moodCounts.isEmpty) return null;
    return moodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Get the most common location in the past 30 days
  Future<String?> getMostCommonLocation() async {
    final entries = await _database.getEntriesPast30Days();
    if (entries.isEmpty) return null;

    final locationCounts = <String, int>{};
    for (final entry in entries) {
      locationCounts[entry.location] = (locationCounts[entry.location] ?? 0) + 1;
    }

    if (locationCounts.isEmpty) return null;
    return locationCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Check if user has logged energy today
  Future<bool> hasLoggedToday() async {
    final todaysEntry = await _database.getTodaysEntry();
    return todaysEntry != null;
  }

  /// Convert database EnergyEntry to EnergyEntryModel
  EnergyEntryModel _convertToModel(EnergyEntry entry) {
    return EnergyEntryModel(
      id: entry.id,
      timestamp: entry.timestamp,
      energyLevel: entry.energyLevel,
      moodTags: entry.moodTags.split(',').map((tag) => tag.trim()).toList(),
      privacyContext: entry.privacyContext,
      location: entry.location,
      notes: entry.notes,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
      userId: entry.userId,
    );
  }
}
