import 'package:maximize/models/database.dart';
import '../models/isar_models.dart';

class CompletionLogConverter {
  static IsarCompletionLog fromCompletionLogData(CompletionLogData data) {
    return IsarCompletionLog()
      ..logId = data.id
      ..taskId = data.taskId
      ..taskTitle = data.taskTitle ?? ''
      ..description = data.description
      ..category = data.category
      ..priority = data.priority
      ..isSubtask = data.isSubtask
      ..parentTaskTitle = data.parentTaskTitle
      ..completedAt = data.completedAt
      ..energyLevel = data.energyLevel
      ..moodTags = data.moodTags
      ..privacyContext = data.privacyContext
      ..location = data.location
      ..createdAt = data.createdAt
      ..updatedAt = data.updatedAt;
  }

  static CompletionLogData toCompletionLogData(IsarCompletionLog isar) {
    return CompletionLogData(
      id: isar.logId,
      taskId: isar.taskId ?? '',
      taskTitle: isar.taskTitle,
      description: isar.description,
      category: isar.category,
      priority: isar.priority,
      isSubtask: isar.isSubtask,
      parentTaskTitle: isar.parentTaskTitle,
      completedAt: isar.completedAt ?? DateTime.now(),
      energyLevel: isar.energyLevel,
      moodTags: isar.moodTags,
      privacyContext: isar.privacyContext,
      location: isar.location,
      createdAt: isar.createdAt,
      updatedAt: isar.updatedAt,
    );
  }

  static IsarCompletionLog fromJson(Map<String, dynamic> json) {
    return IsarCompletionLog()
      ..logId = json['id'] ?? ''
      ..taskId = json['taskId']
      ..taskTitle = json['taskTitle'] ?? ''
      ..description = json['description']
      ..category = json['category']
      ..priority = json['priority']
      ..completedAt = json['completedAt'] != null ? DateTime.parse(json['completedAt']) : DateTime.now()
      ..isSubtask = json['isSubtask'] ?? false
      ..parentTaskTitle = json['parentTaskTitle']
      ..energyLevel = json['energyLevel']
      ..moodTags = json['moodTags']
      ..privacyContext = json['privacyContext']
      ..location = json['location']
      ..createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now();
  }

  static Map<String, dynamic> toJson(IsarCompletionLog log) {
    return {
      'id': log.logId,
      'taskId': log.taskId,
      'taskTitle': log.taskTitle,
      'description': log.description,
      'category': log.category,
      'priority': log.priority,
      'completedAt': log.completedAt?.toIso8601String(),
      'isSubtask': log.isSubtask,
      'parentTaskTitle': log.parentTaskTitle,
      'energyLevel': log.energyLevel,
      'moodTags': log.moodTags,
      'privacyContext': log.privacyContext,
      'location': log.location,
      'createdAt': log.createdAt.toIso8601String(),
    };
  }
}
