import 'package:maximize/models/note_model.dart';
import 'package:maximize/models/database.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart'; 

class NoteService {
  final AppDatabase _database;

  NoteService(this._database);

  // Get all notes (sorted by pinned first, then most recent)
  Future<List<NoteModel>> getNotes() async {
    try {
      final noteDataList = await _database.getAllNotes();
      final notes = noteDataList.map((data) => NoteModel.fromData(data)).toList();
      
      // Sort: pinned first, then by updated time (newest first)
      notes.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });
      
      return notes;
    } catch (e) {
      print('Error fetching notes: $e');
      return [];
    }
  }

  // Get pinned notes only
  Future<List<NoteModel>> getPinnedNotes() async {
    try {
      final notes = await getNotes();
      return notes.where((note) => note.isPinned).toList();
    } catch (e) {
      print('Error fetching pinned notes: $e');
      return [];
    }
  }

  // Get notes by category
  Future<List<NoteModel>> getNotesByCategory(String category) async {
    try {
      final notes = await getNotes();
      return notes.where((note) => note.category == category).toList();
    } catch (e) {
      print('Error fetching notes by category: $e');
      return [];
    }
  }

  // Search notes by title or content
  Future<List<NoteModel>> searchNotes(String query) async {
    try {
      final notes = await getNotes();
      final lowerQuery = query.toLowerCase();
      return notes.where((note) => 
        note.title.toLowerCase().contains(lowerQuery) ||
        note.content.toLowerCase().contains(lowerQuery)
      ).toList();
    } catch (e) {
      print('Error searching notes: $e');
      return [];
    }
  }

  // Add note 
  Future<String?> addNote({
    required String title,
    required String content,
    String? category,
    String color = '#FFD700',
    bool isPinned = false,
  }) async {
    try {
      final id = Uuid().v4();
      final now = DateTime.now();
      
      final note = NotesCompanion.insert(
        id: Value(id), 
        title: title,
        content: content,
        category: Value(category),
        color: Value(color), 
        createdAt: now,
        updatedAt: now,
        isPinned: Value(isPinned), 
      );
      
      await _database.insertNote(note);
      print('[NoteService] Note added successfully: $id');
      return id;
    } catch (e) {
      print('Error adding note: $e');
      return null;
    }
  }

  // Update note
  Future<bool> updateNote(NoteModel note) async {
    try {
      final updatedNote = note.copyWith(updatedAt: DateTime.now());
      final companion = updatedNote.toCompanion();
      await _database.updateNote(companion);
      print('[NoteService] Note updated successfully: ${note.id}');
      return true;
    } catch (e) {
      print('Error updating note: $e');
      return false;
    }
  }

  // Delete note
  Future<bool> deleteNote(String noteId) async {
    try {
      await _database.deleteNote(noteId);
      print('[NoteService] Note deleted successfully: $noteId');
      return true;
    } catch (e) {
      print('Error deleting note: $e');
      return false;
    }
  }

  // Toggle pin status
  Future<bool> togglePin(String noteId) async {
    try {
      final notes = await getNotes();
      final note = notes.firstWhere((n) => n.id == noteId);
      final updated = note.copyWith(
        isPinned: !note.isPinned,
        updatedAt: DateTime.now(),
      );
      return await updateNote(updated);
    } catch (e) {
      print('Error toggling pin: $e');
      return false;
    }
  }

  // Get all unique categories
  Future<List<String>> getCategories() async {
    try {
      final notes = await getNotes();
      final categories = notes
          .where((note) => note.category != null && note.category!.isNotEmpty)
          .map((note) => note.category!)
          .toSet()
          .toList();
      categories.sort();
      return categories;
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }
}
