import 'package:maximize/models/database.dart';
import 'package:uuid/uuid.dart';

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
    String? id,
    required this.title,
    required this.content,
    this.category,
    this.color = '#FFD700',
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isPinned = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert from database NoteData to NoteModel
  factory NoteModel.fromData(NoteData noteData) {
    return NoteModel(
      id: noteData.id,
      title: noteData.title,
      content: noteData.content,
      category: noteData.category,
      color: '#FFD700',
      createdAt: noteData.createdAt,
      updatedAt: noteData.updatedAt,
      isPinned: false,
    );
  }

  // Convert to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPinned': isPinned,
    };
  }

  // Create from Map
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      category: map['category'],
      color: map['color'] ?? '#FFD700',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      isPinned: map['isPinned'] ?? false,
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
