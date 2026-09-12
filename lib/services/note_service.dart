import 'package:kinetic/database/app_database.dart';
import 'package:kinetic/models/note_model.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';

class NoteService {
  final AppDatabase _database;

  NoteService(this._database);

  Future<List<NoteModel>> getNotes() async {
    try {
      final rows = await _database.select(_database.notes).get();
      final notes = rows.map(_rowToModel).toList();
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return notes;
    } catch (e) {
      debugPrint('Error fetching notes: $e');
      return [];
    }
  }

  Future<List<NoteModel>> getPinnedNotes() async {
    try {
      final notes = await getNotes();
      return notes.where((note) => note.isPinned).toList();
    } catch (e) {
      debugPrint('Error fetching pinned notes: $e');
      return [];
    }
  }

  Future<List<NoteModel>> getNotesByCategory(String category) async {
    try {
      final notes = await getNotes();
      return notes.where((note) => note.category == category).toList();
    } catch (e) {
      debugPrint('Error fetching notes by category: $e');
      return [];
    }
  }

  Future<List<NoteModel>> searchNotes(String query) async {
    try {
      final notes = await getNotes();
      final lowerQuery = query.toLowerCase();
      return notes.where((note) =>
        note.title.toLowerCase().contains(lowerQuery) ||
        note.content.toLowerCase().contains(lowerQuery)
      ).toList();
    } catch (e) {
      debugPrint('Error searching notes: $e');
      return [];
    }
  }

  Future<String?> addNote({
    required String title,
    required String content,
    String? category,
    String color = '#FFD700',
    bool isPinned = false,
  }) async {
    try {
      final id = const Uuid().v4();
      final now = DateTime.now();

      await _database.into(_database.notes).insert(
        NotesCompanion(
          id: Value(id),
          noteId: Value(id),
          title: Value(title),
          content: Value(content),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
      debugPrint('[NoteService] Note added successfully: $id');
      return id;
    } catch (e) {
      debugPrint('Error adding note: $e');
      return null;
    }
  }

  Future<bool> updateNote(NoteModel note) async {
    try {
      await (_database.update(_database.notes)
            ..where((n) => n.noteId.equals(note.id)))
          .write(NotesCompanion(
            title: Value(note.title),
            content: Value(note.content),
            updatedAt: Value(DateTime.now()),
          ));
      debugPrint('[NoteService] Note updated successfully: ${note.id}');
      return true;
    } catch (e) {
      debugPrint('Error updating note: $e');
      return false;
    }
  }

  Future<bool> deleteNote(String noteId) async {
    try {
      await (_database.delete(_database.notes)
            ..where((n) => n.noteId.equals(noteId)))
          .go();
      debugPrint('[NoteService] Note deleted successfully: $noteId');
      return true;
    } catch (e) {
      debugPrint('Error deleting note: $e');
      return false;
    }
  }

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
      debugPrint('Error toggling pin: $e');
      return false;
    }
  }

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
      debugPrint('Error getting categories: $e');
      return [];
    }
  }

  NoteModel _rowToModel(Note row) {
    return NoteModel(
      id: row.noteId,
      title: row.title,
      content: row.content,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
