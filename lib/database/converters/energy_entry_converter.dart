import 'package:maximize/models/energy_model.dart';
import '../models/isar_models.dart';

class EnergyEntryConverter {
  static IsarEnergyEntry fromEnergyEntryModel(EnergyEntryModel model) {
    return IsarEnergyEntry()
      ..entryId = model.id
      ..timestamp = model.timestamp
      ..energyLevel = model.energyLevel
      ..moodTags = model.moodTags.join(',')
      ..privacyContext = model.privacyContext
      ..location = model.location
      ..notes = model.notes
      ..userId = model.userId
      ..createdAt = model.createdAt
      ..updatedAt = model.updatedAt;
  }

  static EnergyEntryModel toEnergyEntryModel(IsarEnergyEntry isar) {
    return EnergyEntryModel(
      id: isar.entryId,
      timestamp: isar.timestamp ?? DateTime.now(),
      energyLevel: isar.energyLevel,
      moodTags: isar.moodTags?.split(',').map((tag) => tag.trim()).toList() ?? [],
      privacyContext: isar.privacyContext ?? '',
      location: isar.location ?? '',
      notes: isar.notes,
      userId: isar.userId,
      createdAt: isar.createdAt,
      updatedAt: isar.updatedAt,
    );
  }

  static IsarEnergyEntry fromJson(Map<String, dynamic> json) {
    return IsarEnergyEntry()
      ..entryId = json['id'] ?? ''
      ..timestamp = json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now()
      ..energyLevel = json['energyLevel'] ?? 5
      ..moodTags = json['moodTags']
      ..privacyContext = json['privacyContext']
      ..location = json['location']
      ..notes = json['notes']
      ..userId = json['userId']
      ..createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now()
      ..updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now();
  }

  static Map<String, dynamic> toJson(IsarEnergyEntry entry) {
    return {
      'id': entry.entryId,
      'timestamp': entry.timestamp?.toIso8601String(),
      'energyLevel': entry.energyLevel,
      'moodTags': entry.moodTags,
      'privacyContext': entry.privacyContext,
      'location': entry.location,
      'notes': entry.notes,
      'userId': entry.userId,
      'createdAt': entry.createdAt.toIso8601String(),
      'updatedAt': entry.updatedAt.toIso8601String(),
    };
  }
}
