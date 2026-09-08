import 'package:uuid/uuid.dart';

// Mood tags constants
class MoodTags {
  static const String focused = 'Focused';
  static const String energetic = 'Energetic';
  static const String distracted = 'Distracted';
  static const String drained = 'Drained';
  static const String stressed = 'Stressed';

  static const List<String> all = [focused, energetic, distracted, drained, stressed];
}

// Privacy context constants
class PrivacyContexts {
  static const String alone = 'Alone';
  static const String coworking = 'Coworking';
  static const String office = 'Office';
  static const String public_ = 'Public';
  static const String home = 'Home';

  static const List<String> all = [alone, coworking, office, public_, home];
}

// Location constants
class Locations {
  static const String home = 'Home';
  static const String coffeeShop = 'Coffee Shop';
  static const String office = 'Office';
  static const String other = 'Other';

  static const List<String> all = [home, coffeeShop, office, other];
}

class EnergyEntry {
  final String id;
  final DateTime timestamp;
  final int energyLevel; // 1-10
  final List<String> moodTags;
  final String privacyContext;
  final String location;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userId;

  EnergyEntry({
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
        updatedAt = updatedAt ?? DateTime.now() {
    // Validate energy level
    if (energyLevel < 1 || energyLevel > 10) {
      throw ArgumentError('Energy level must be between 1 and 10');
    }
    // Validate mood tags
    for (final mood in moodTags) {
      if (!MoodTags.all.contains(mood)) {
        throw ArgumentError('Invalid mood tag: $mood');
      }
    }
    // Validate privacy context
    if (!PrivacyContexts.all.contains(privacyContext)) {
      throw ArgumentError('Invalid privacy context: $privacyContext');
    }
    // Validate location
    if (!Locations.all.contains(location)) {
      throw ArgumentError('Invalid location: $location');
    }
  }

  /// Create a modified copy of this entry
  EnergyEntry copyWith({
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
    return EnergyEntry(
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

  /// Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'energyLevel': energyLevel,
      'moodTags': getMoodTagsString(),
      'privacyContext': privacyContext,
      'location': location,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
    };
  }

  /// Create from JSON
  static EnergyEntry fromJson(Map<String, dynamic> json) {
    return EnergyEntry(
      id: json['id'] as String? ?? const Uuid().v4(),
      timestamp: json['timestamp'] is String
          ? DateTime.parse(json['timestamp'] as String)
          : json['timestamp'] as DateTime,
      energyLevel: json['energyLevel'] as int? ?? 5,
      moodTags: json['moodTags'] is String
          ? (json['moodTags'] as String).split(',').map((tag) => tag.trim()).toList()
          : List<String>.from(json['moodTags'] as List? ?? []),
      privacyContext: json['privacyContext'] as String? ?? 'Home',
      location: json['location'] as String? ?? 'Home',
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] is String
          ? DateTime.parse(json['createdAt'] as String)
          : json['createdAt'] as DateTime,
      updatedAt: json['updatedAt'] is String
          ? DateTime.parse(json['updatedAt'] as String)
          : json['updatedAt'] as DateTime,
      userId: json['userId'] as String?,
    );
  }

  /// Parse mood tags from comma-separated string
  static List<String> parseMoodTags(String moodString) {
    return moodString.split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList();
  }

  /// Get mood tags as comma-separated string
  String getMoodTagsString() {
    return moodTags.join(', ');
  }

  /// Get mood tags list
  List<String> getMoodTagsList() {
    return List<String>.from(moodTags);
  }

  /// Check if this entry is from today
  bool isTodaysEntry() {
    final now = DateTime.now();
    return timestamp.year == now.year && timestamp.month == now.month && timestamp.day == now.day;
  }

  /// Check if this entry is from a specific date
  bool isFromDate(DateTime date) {
    return timestamp.year == date.year && timestamp.month == date.month && timestamp.day == date.day;
  }

  /// Get energy description
  String getEnergyDescription() {
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

  /// Check if energy is high (>= 7)
  bool get isHighEnergy => energyLevel >= 7;

  /// Check if energy is low (<= 3)
  bool get isLowEnergy => energyLevel <= 3;

  /// Check if energy is medium (4-6)
  bool get isMediumEnergy => energyLevel > 3 && energyLevel < 7;

  /// Check if a specific mood is tagged
  bool hasMood(String mood) {
    return moodTags.contains(mood);
  }

  /// Get all tagged moods as a readable string
  String getMoodsAsString() {
    return moodTags.join(', ');
  }

  @override
  String toString() {
    return 'EnergyEntry(id: $id, timestamp: $timestamp, energyLevel: $energyLevel, '
        'moods: ${moodTags.join(", ")}, context: $privacyContext, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EnergyEntry &&
        other.id == id &&
        other.timestamp == timestamp &&
        other.energyLevel == energyLevel;
  }

  @override
  int get hashCode => Object.hash(id, timestamp, energyLevel);
}
