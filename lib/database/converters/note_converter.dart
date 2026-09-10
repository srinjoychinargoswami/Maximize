import '../models/isar_models.dart';
import 'package:maximize/models/note_model.dart';

class NoteConverter {
  // From Isar to Model
  static NoteModel fromIsar(IsarNote isar) {
    return NoteModel(
      id: isar.noteId,
      title: isar.title,
      content: isar.content,
      category: isar.category,
      color: isar.color,
      createdAt: isar.createdAt,
      updatedAt: isar.updatedAt,
      isPinned: isar.isPinned,
    );
  }

  // From Model to Isar
  static IsarNote toIsar(NoteModel model) {
    return IsarNote()
      ..noteId = model.id
      ..title = model.title
      ..content = model.content
      ..category = model.category
      ..color = model.color
      ..createdAt = model.createdAt
      ..updatedAt = model.updatedAt
      ..isPinned = model.isPinned;
  }

  // To NoteModel (alias)
  static NoteModel toNoteModel(IsarNote isar) {
    return fromIsar(isar);
  }

  // To/From JSON for Firebase sync
  static Map<String, dynamic> toJson(NoteModel model) {
    return {
      'id': model.id,
      'title': model.title,
      'content': model.content,
      'category': model.category,
      'color': model.color,
      'createdAt': model.createdAt.toIso8601String(),
      'updatedAt': model.updatedAt.toIso8601String(),
      'isPinned': model.isPinned,
    };
  }

  static NoteModel fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'],
      color: json['color'] ?? '#FFD700',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      isPinned: json['isPinned'] ?? false,
    );
  }
}
