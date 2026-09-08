import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'energy_model.g.dart';

@JsonSerializable()
class EnergyEntryModel {
  final String id;
  final DateTime timestamp;
  final int energyLevel; // 1-10 scale
  final List<String> moodTags; // List of moods: "Focused", "Energetic", "Distracted", "Drained", "Stressed"
  final String privacyContext; // "Alone", "Coworking", "Office", "Public", "Home"
  final String location; // "Home", "Coffee Shop", "Office", "Other"
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userId; // For Firebase sync

  EnergyEntryModel({
    String? id,
    required this.timestamp,
    required this.energyLevel,
    required this.moodTags,
    required this.privacyContext,
    required this.location,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.userId,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory EnergyEntryModel.fromJson(Map<String, dynamic> json) =>
      _$EnergyEntryModelFromJson(json);

  Map<String, dynamic> toJson() => _$EnergyEntryModelToJson(this);

  // Convert to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'energyLevel': energyLevel,
      'moodTags': moodTags.join(','),
      'privacyContext': privacyContext,
      'location': location,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
    };
  }

  // Create from Map for database operations
  factory EnergyEntryModel.fromMap(Map<String, dynamic> map) {
    return EnergyEntryModel(
      id: map['id'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      energyLevel: map['energyLevel'] ?? 5,
      moodTags: (map['moodTags'] as String?)?.split(',') ?? [],
      privacyContext: map['privacyContext'] ?? 'Home',
      location: map['location'] ?? 'Home',
      notes: map['notes'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : DateTime.now(),
      userId: map['userId'],
    );
  }

  EnergyEntryModel copyWith({
    String? id,
    DateTime? timestamp,
    int? energyLevel,
    List<String>? moodTags,
    String? privacyContext,
    String? location,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return EnergyEntryModel(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      energyLevel: energyLevel ?? this.energyLevel,
      moodTags: moodTags ?? this.moodTags,
      privacyContext: privacyContext ?? this.privacyContext,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  // Helper methods
  bool get isHighEnergy => energyLevel >= 7;
  bool get isLowEnergy => energyLevel <= 3;
  bool get isMediumEnergy => energyLevel > 3 && energyLevel < 7;

  bool hasMood(String mood) => moodTags.contains(mood);

  String get energyDescription {
    switch (energyLevel) {
      case 1:
      case 2:
        return 'Very Low';
      case 3:
      case 4:
        return 'Low';
      case 5:
      case 6:
        return 'Medium';
      case 7:
      case 8:
        return 'High';
      case 9:
      case 10:
        return 'Very High';
      default:
        return 'Unknown';
    }
  }
}

// Enum for mood tags
enum MoodTag {
  focused('Focused'),
  energetic('Energetic'),
  distracted('Distracted'),
  drained('Drained'),
  stressed('Stressed');

  final String label;
  const MoodTag(this.label);
}

// Enum for privacy context
enum PrivacyContext {
  alone('Alone'),
  coworking('Coworking'),
  office('Office'),
  public('Public'),
  home('Home');

  final String label;
  const PrivacyContext(this.label);
}

// Enum for location
enum LocationType {
  home('Home'),
  coffeeShop('Coffee Shop'),
  office('Office'),
  other('Other');

  final String label;
  const LocationType(this.label);
}
