import 'package:isar/isar.dart';
import '../isar_database_service.dart';
import '../models/isar_models.dart';

class NoteDAO {
  Future<void> insertNote(IsarNote note) async {
    await IsarDatabaseService.db.writeTxn(() async {
      await IsarDatabaseService.notes.put(note);
    });
  }

  Future<List<IsarNote>> getAllNotes() async {
    final notes = await IsarDatabaseService.notes.where().findAll();
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  Future<IsarNote?> getNoteById(String noteId) async {
    final notes = await IsarDatabaseService.notes.where().findAll();
    try {
      return notes.firstWhere((note) => note.noteId == noteId);
    } catch (e) {
      return null;
    }
  }

  Future<List<IsarNote>> getPinnedNotes() async {
    final notes = await IsarDatabaseService.notes.where().findAll();
    final filtered = notes.where((note) => note.isPinned).toList();
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  Future<List<IsarNote>> getNotesByCategory(String category) async {
    final notes = await IsarDatabaseService.notes.where().findAll();
    final filtered = notes.where((note) => note.category == category).toList();
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  Future<void> updateNote(IsarNote note) async {
    await IsarDatabaseService.db.writeTxn(() async {
      await IsarDatabaseService.notes.put(note);
    });
  }

  Future<void> deleteNote(String noteId) async {
    final note = await getNoteById(noteId);
    if (note != null) {
      await IsarDatabaseService.db.writeTxn(() async {
        await IsarDatabaseService.notes.delete(note.id!);
      });
    }
  }

  Future<int> countNotes() async {
    return await IsarDatabaseService.notes.count();
  }

  Future<int> countPinnedNotes() async {
    final notes = await IsarDatabaseService.notes.where().findAll();
    return notes.where((note) => note.isPinned).length;
  }
}
