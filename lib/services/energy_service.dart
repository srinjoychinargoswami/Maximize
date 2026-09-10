import 'package:maximize/database/daos/energy_entry_dao.dart';
import 'package:maximize/database/converters/energy_entry_converter.dart';
import 'package:maximize/models/energy_model.dart';
import 'package:uuid/uuid.dart';

class EnergyService {
  final EnergyEntryDAO _dao = EnergyEntryDAO();

  /// Create a new energy entry
  Future<void> createEnergyEntry({
    required int energyLevel,
    required List<String> moodTags,
    required String privacyContext,
    required String location,
    String? notes,
  }) async {
    final model = EnergyEntryModel(
      id: const Uuid().v4(),
      timestamp: DateTime.now(),
      energyLevel: energyLevel.clamp(1, 10),
      moodTags: moodTags,
      privacyContext: privacyContext,
      location: location,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final isarEntry = EnergyEntryConverter.fromEnergyEntryModel(model);
    await _dao.insertEnergyEntry(isarEntry);
  }

  /// Get today's energy entry if it exists
  Future<EnergyEntryModel?> getTodaysEntry() async {
    final entry = await _dao.getTodaysEntry();
    if (entry == null) return null;
    return EnergyEntryConverter.toEnergyEntryModel(entry);
  }

  /// Get energy entries from the past 30 days
  Future<List<EnergyEntryModel>> getEntriesPast30Days() async {
    final entries = await _dao.getEntriesPast30Days();
    return entries.map((e) => EnergyEntryConverter.toEnergyEntryModel(e)).toList();
  }

  /// Get energy entries for a specific date
  Future<List<EnergyEntryModel>> getEntriesByDate(DateTime date) async {
    final entries = await _dao.getEntriesByDate(date);
    return entries.map((e) => EnergyEntryConverter.toEnergyEntryModel(e)).toList();
  }

  /// Get all energy entries
  Future<List<EnergyEntryModel>> getAllEntries() async {
    final entries = await _dao.getAllEnergyEntries();
    return entries.map((e) => EnergyEntryConverter.toEnergyEntryModel(e)).toList();
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
    final currentEntry = await _dao.getEnergyEntry(id);
    if (currentEntry == null) throw Exception('Energy entry not found');

    final currentModel = EnergyEntryConverter.toEnergyEntryModel(currentEntry);
    final updated = currentModel.copyWith(
      energyLevel: energyLevel?.clamp(1, 10),
      moodTags: moodTags,
      privacyContext: privacyContext,
      location: location,
      notes: notes,
      updatedAt: DateTime.now(),
    );

    final isarEntry = EnergyEntryConverter.fromEnergyEntryModel(updated);
    await _dao.updateEnergyEntry(isarEntry);
  }

  /// Delete an energy entry
  Future<void> deleteEnergyEntry(String id) async {
    await _dao.deleteEnergyEntry(id);
  }

  /// Get average energy level for the past 30 days
  Future<double> getAverageEnergyPast30Days() async {
    final entries = await _dao.getEntriesPast30Days();
    if (entries.isEmpty) return 0.0;

    final sum = entries.fold<int>(0, (sum, entry) => sum + entry.energyLevel);
    return sum / entries.length;
  }

  /// Get the most common mood in the past 30 days
  Future<String?> getMostCommonMood() async {
    final isarEntries = await _dao.getEntriesPast30Days();
    if (isarEntries.isEmpty) return null;

    final moodCounts = <String, int>{};
    for (final entry in isarEntries) {
      final moods = entry.moodTags?.split(',') ?? [];
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
    final isarEntries = await _dao.getEntriesPast30Days();
    if (isarEntries.isEmpty) return null;

    final locationCounts = <String, int>{};
    for (final entry in isarEntries) {
      final loc = entry.location ?? '';
      locationCounts[loc] = (locationCounts[loc] ?? 0) + 1;
    }

    if (locationCounts.isEmpty) return null;
    return locationCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Check if user has logged energy today
  Future<bool> hasLoggedToday() async {
    final todaysEntry = await _dao.getTodaysEntry();
    return todaysEntry != null;
  }
}
