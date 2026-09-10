import 'package:isar/isar.dart';
import '../isar_database_service.dart';
import '../models/isar_models.dart';

class EnergyEntryDAO {
  Future<void> insertEnergyEntry(IsarEnergyEntry entry) async {
    await IsarDatabaseService.db.writeTxn(() async {
      await IsarDatabaseService.energyEntries.put(entry);
    });
  }

  Future<List<IsarEnergyEntry>> getAllEnergyEntries() async {
    return await IsarDatabaseService.energyEntries
        .where()
        .sortByTimestampDesc()
        .findAll();
  }

  Future<IsarEnergyEntry?> getEnergyEntry(String entryId) async {
    return await IsarDatabaseService.energyEntries
        .where()
        .entryIdEqualTo(entryId)
        .findFirst();
  }

  Future<IsarEnergyEntry?> getTodaysEntry() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    return await IsarDatabaseService.energyEntries
        .where()
        .timestampBetween(startOfDay, endOfDay)
        .sortByTimestampDesc()
        .findFirst();
  }

  Future<List<IsarEnergyEntry>> getEntriesPast30Days() async {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

    return await IsarDatabaseService.energyEntries
        .where()
        .timestampGreaterThan(thirtyDaysAgo)
        .sortByTimestampDesc()
        .findAll();
  }

  Future<List<IsarEnergyEntry>> getEntriesByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return await IsarDatabaseService.energyEntries
        .where()
        .timestampBetween(startOfDay, endOfDay)
        .sortByTimestampDesc()
        .findAll();
  }

  Future<void> updateEnergyEntry(IsarEnergyEntry entry) async {
    await IsarDatabaseService.db.writeTxn(() async {
      await IsarDatabaseService.energyEntries.put(entry);
    });
  }

  Future<void> deleteEnergyEntry(String entryId) async {
    final entry = await getEnergyEntry(entryId);
    if (entry != null) {
      await IsarDatabaseService.db.writeTxn(() async {
        await IsarDatabaseService.energyEntries.delete(entry.id!);
      });
    }
  }

  Future<int> countEntries() async {
    return await IsarDatabaseService.energyEntries.count();
  }
}
