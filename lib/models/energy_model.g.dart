// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'energy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnergyEntryModel _$EnergyEntryModelFromJson(Map<String, dynamic> json) =>
    EnergyEntryModel(
      id: json['id'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      energyLevel: (json['energyLevel'] as num).toInt(),
      moodTags:
          (json['moodTags'] as List<dynamic>).map((e) => e as String).toList(),
      privacyContext: json['privacyContext'] as String,
      location: json['location'] as String,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$EnergyEntryModelToJson(EnergyEntryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'energyLevel': instance.energyLevel,
      'moodTags': instance.moodTags,
      'privacyContext': instance.privacyContext,
      'location': instance.location,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'userId': instance.userId,
    };
