import 'package:maximize/models/database.dart';
import 'package:drift/drift.dart'; 


class NoteModel {
  final String id;
  final String title;
  final String content;
  final String? category;
  final String color;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    this.category,
    this.color = '#FFD700',
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
  });

  // Convert from database Note to NoteModel
  factory NoteModel.fromData(Note noteData) {
    return NoteModel(
      id: noteData.id,
      title: noteData.title,
      content: noteData.content,
      category: noteData.category,
      color: noteData.color,
      createdAt: noteData.createdAt,
      updatedAt: noteData.updatedAt,
      isPinned: noteData.isPinned,
    );
  }

  // Convert NoteModel to database NotesCompanion
  NotesCompanion toCompanion() {
    return NotesCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      category: Value(category),
      color: Value(color),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isPinned: Value(isPinned),
    );
  }

  // Copy with method for updates
  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
