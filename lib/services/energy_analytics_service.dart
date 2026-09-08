import 'package:maximize/models/database.dart';
import 'package:maximize/models/energy_model.dart';
import 'package:maximize/services/energy_service.dart';
import 'package:maximize/config/app_config.dart';

class EnergyAnalyticsService {
  static final EnergyAnalyticsService _instance = EnergyAnalyticsService._internal();

  factory EnergyAnalyticsService(AppDatabase database) {
    _instance._energyService = EnergyService(database);
    return _instance;
  }

  EnergyAnalyticsService._internal();

  late EnergyService _energyService;

  // Cache
  DateTime? _lastCacheTime;
  List<EnergyEntryModel>? _cachedEntries;
  static const Duration _cacheDuration = Duration(minutes: 5);

  /// Get peak energy hour (0-23) with highest average energy
  Future<int?> getPeakEnergyHour() async {
    try {
      final entries = await _getEntriesPast30Days();
      if (entries.isEmpty) return null;

      final hourlyAverage = await getHourlyAverageEnergy();
      if (hourlyAverage.isEmpty) return null;

      int peakHour = 0;
      double maxEnergy = 0;
      hourlyAverage.forEach((hour, energy) {
        if (energy > maxEnergy) {
          maxEnergy = energy;
          peakHour = hour;
        }
      });

      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Peak energy hour: $peakHour (avg: $maxEnergy)');
      }

      return peakHour;
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Error getting peak hour: $e');
      }
      return null;
    }
  }

  /// Get peak energy 2-hour window with highest average
  Future<Map<String, int>?> getPeakEnergyBlock() async {
    try {
      final entries = await _getEntriesPast30Days();
      if (entries.isEmpty) return null;

      final hourlyAverage = await getHourlyAverageEnergy();
      if (hourlyAverage.isEmpty) return null;

      double maxBlockEnergy = 0;
      int peakStart = 0;

      for (int i = 0; i < 23; i++) {
        final hour1 = hourlyAverage[i] ?? 0;
        final hour2 = hourlyAverage[i + 1] ?? 0;
        final blockAverage = (hour1 + hour2) / 2;

        if (blockAverage > maxBlockEnergy) {
          maxBlockEnergy = blockAverage;
          peakStart = i;
        }
      }

      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Peak block: ${peakStart}-${peakStart + 1} (avg: $maxBlockEnergy)');
      }

      return {'start': peakStart, 'end': peakStart + 1};
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Error getting peak block: $e');
      }
      return null;
    }
  }

  /// Get most common mood during peak energy hours
  Future<String?> getBestMoodDuringPeakEnergy() async {
    try {
      final peakBlock = await getPeakEnergyBlock();
      if (peakBlock == null) return null;

      final entries = await _getEntriesPast30Days();
      if (entries.isEmpty) return null;

      final moodsInPeak = <String>[];
      for (final entry in entries) {
        final hour = entry.timestamp.hour;
        if (hour >= peakBlock['start']! && hour < peakBlock['end']!) {
          moodsInPeak.addAll(entry.moodTags);
        }
      }

      if (moodsInPeak.isEmpty) return null;

      final bestMood = _getMostFrequent(moodsInPeak);
      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Best mood during peak: $bestMood');
      }

      return bestMood;
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Error getting best mood: $e');
      }
      return null;
    }
  }

  /// Get best privacy + location combination
  Future<Map<String, dynamic>?> getBestContextCombo() async {
    try {
      final entries = await _getEntriesPast30Days();
      if (entries.isEmpty) return null;

      final combos = <String, Map<String, dynamic>>{};

      for (final entry in entries) {
        final key = '${entry.privacyContext}|${entry.location}';
        if (!combos.containsKey(key)) {
          combos[key] = {
            'energies': <int>[],
            'privacy': entry.privacyContext,
            'location': entry.location,
            'count': 0,
          };
        }
        combos[key]!['energies'].add(entry.energyLevel);
        combos[key]!['count'] = (combos[key]!['count'] as int) + 1;
      }

      if (combos.isEmpty) return null;

      Map<String, dynamic>? bestCombo;
      double maxAverage = 0;

      combos.forEach((key, combo) {
        final energies = combo['energies'] as List<int>;
        final average = energies.reduce((a, b) => a + b) / energies.length;
        if (average > maxAverage) {
          maxAverage = average;
          bestCombo = {
            'privacy': combo['privacy'],
            'location': combo['location'],
            'avgEnergy': double.parse(average.toStringAsFixed(1)),
            'count': combo['count'],
          };
        }
      });

      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Best combo: ${bestCombo?['privacy']} + ${bestCombo?['location']}');
      }

      return bestCombo;
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Error getting best combo: $e');
      }
      return null;
    }
  }

  /// Get 3 worst energy hours (lowest average)
  Future<List<int>> getWorstEnergyHours() async {
    try {
      final hourlyAverage = await getHourlyAverageEnergy();
      if (hourlyAverage.isEmpty) return [];

      final sorted = hourlyAverage.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));

      final worstHours = sorted.take(3).map((e) => e.key).toList();

      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Worst hours: $worstHours');
      }

      return worstHours;
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Error getting worst hours: $e');
      }
      return [];
    }
  }

  /// Get mood frequency count
  Future<Map<String, int>> getMoodFrequency() async {
    try {
      final entries = await _getEntriesPast30Days();
      if (entries.isEmpty) return {};

      final moodCounts = <String, int>{};

      for (final entry in entries) {
        for (final mood in entry.moodTags) {
          moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
        }
      }

      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Mood frequency: $moodCounts');
      }

      return moodCounts;
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Error getting mood frequency: $e');
      }
      return {};
    }
  }

  /// Get average energy for each hour (0-23)
  Future<Map<int, double>> getHourlyAverageEnergy() async {
    try {
      final entries = await _getEntriesPast30Days();
      if (entries.isEmpty) return {};

      final hourlyData = <int, List<int>>{};

      for (int hour = 0; hour < 24; hour++) {
        hourlyData[hour] = [];
      }

      for (final entry in entries) {
        final hour = entry.timestamp.hour;
        hourlyData[hour]!.add(entry.energyLevel);
      }

      final hourlyAverage = <int, double>{};
      hourlyData.forEach((hour, energies) {
        if (energies.isNotEmpty) {
          final average = energies.reduce((a, b) => a + b) / energies.length;
          hourlyAverage[hour] = double.parse(average.toStringAsFixed(1));
        } else {
          hourlyAverage[hour] = 0;
        }
      });

      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Hourly average calculated');
      }

      return hourlyAverage;
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Error getting hourly average: $e');
      }
      return {};
    }
  }

  /// Get average energy by privacy context
  Future<Map<String, double>> getContextCorrelation() async {
    try {
      final entries = await _getEntriesPast30Days();
      if (entries.isEmpty) return {};

      final contextData = <String, List<int>>{};

      for (final entry in entries) {
        if (!contextData.containsKey(entry.privacyContext)) {
          contextData[entry.privacyContext] = [];
        }
        contextData[entry.privacyContext]!.add(entry.energyLevel);
      }

      final contextAverage = <String, double>{};
      contextData.forEach((context, energies) {
        if (energies.isNotEmpty) {
          final average = energies.reduce((a, b) => a + b) / energies.length;
          contextAverage[context] = double.parse(average.toStringAsFixed(1));
        }
      });

      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Context correlation: $contextAverage');
      }

      return contextAverage;
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Error getting context correlation: $e');
      }
      return {};
    }
  }

  /// Get average energy by location
  Future<Map<String, double>> getLocationCorrelation() async {
    try {
      final entries = await _getEntriesPast30Days();
      if (entries.isEmpty) return {};

      final locationData = <String, List<int>>{};

      for (final entry in entries) {
        if (!locationData.containsKey(entry.location)) {
          locationData[entry.location] = [];
        }
        locationData[entry.location]!.add(entry.energyLevel);
      }

      final locationAverage = <String, double>{};
      locationData.forEach((location, energies) {
        if (energies.isNotEmpty) {
          final average = energies.reduce((a, b) => a + b) / energies.length;
          locationAverage[location] = double.parse(average.toStringAsFixed(1));
        }
      });

      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Location correlation: $locationAverage');
      }

      return locationAverage;
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Error getting location correlation: $e');
      }
      return {};
    }
  }

  /// Generate insight summary text
  Future<String> getInsightsSummary() async {
    try {
      final peakBlock = await getPeakEnergyBlock();
      final bestMood = await getBestMoodDuringPeakEnergy();
      final bestCombo = await getBestContextCombo();
      final moodFreq = await getMoodFrequency();

      if (peakBlock == null || moodFreq.isEmpty) {
        return 'Not enough data for insights yet. Keep logging your energy!';
      }

      final insights = <String>[];

      // Peak time insight
      final peakStart = peakBlock['start'];
      final peakEnd = peakBlock['end'];
      final peakTimeStr = '$peakStart:00-$peakEnd:00';

      if (bestMood != null && bestCombo != null) {
        insights.add(
          'Peak energy $peakTimeStr when ${bestCombo['privacy']?.toString().toLowerCase()} at ${bestCombo['location']?.toString().toLowerCase()}. '
          'Most productive mood: $bestMood (logged ${moodFreq[bestMood]} times).',
        );
      } else if (bestMood != null) {
        insights.add(
          'Peak energy $peakTimeStr. Most productive mood: $bestMood (logged ${moodFreq[bestMood]} times).',
        );
      } else if (bestCombo != null) {
        insights.add(
          'Best context: ${bestCombo['privacy']?.toString()} at ${bestCombo['location']?.toString()} '
          '(avg ${bestCombo['avgEnergy']}/10).',
        );
      }

      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Summary: ${insights.join(" ")}');
      }

      return insights.join(' ');
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Error generating summary: $e');
      }
      return 'Unable to generate insights at this time.';
    }
  }

  /// Get weekly heatmap data: Day (0-6) → Hour (0-23) → Average Energy
  Future<Map<int, Map<int, double>>> getWeeklyHeatmapData() async {
    try {
      final entries = await _getEntriesPast30Days();
      if (entries.isEmpty) return {};

      // Initialize heatmap
      final heatmap = <int, Map<int, double>>{};
      for (int day = 0; day < 7; day++) {
        heatmap[day] = {};
        for (int hour = 0; hour < 24; hour++) {
          heatmap[day]![hour] = 0;
        }
      }

      // Collect data
      final dayHourData = <int, Map<int, List<int>>>{};
      for (int day = 0; day < 7; day++) {
        dayHourData[day] = {};
        for (int hour = 0; hour < 24; hour++) {
          dayHourData[day]![hour] = [];
        }
      }

      for (final entry in entries) {
        final day = entry.timestamp.weekday % 7; // 0 = Monday
        final hour = entry.timestamp.hour;
        dayHourData[day]![hour]!.add(entry.energyLevel);
      }

      // Calculate averages
      dayHourData.forEach((day, hours) {
        hours.forEach((hour, energies) {
          if (energies.isNotEmpty) {
            final average = energies.reduce((a, b) => a + b) / energies.length;
            heatmap[day]![hour] = double.parse(average.toStringAsFixed(1));
          }
        });
      });

      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Weekly heatmap calculated');
      }

      return heatmap;
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[EnergyAnalytics] Error getting heatmap: $e');
      }
      return {};
    }
  }

  // HELPER METHODS

  /// Get entries from past 30 days (with caching)
  Future<List<EnergyEntryModel>> _getEntriesPast30Days() async {
    // Check cache
    if (_cachedEntries != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!).inMinutes < _cacheDuration.inMinutes) {
      return _cachedEntries!;
    }

    // Fetch fresh data
    final entries = await _energyService.getEntriesPast30Days();

    // Update cache
    _cachedEntries = entries;
    _lastCacheTime = DateTime.now();

    return entries;
  }

  /// Clear cache manually
  void clearCache() {
    _cachedEntries = null;
    _lastCacheTime = null;
    if (AppConfig.debugLogging) {
      print('[EnergyAnalytics] Cache cleared');
    }
  }

  /// Get most frequent item in list
  T? _getMostFrequent<T>(List<T> items) {
    if (items.isEmpty) return null;

    final counts = <T, int>{};
    for (final item in items) {
      counts[item] = (counts[item] ?? 0) + 1;
    }

    T? mostFrequent;
    int maxCount = 0;
    counts.forEach((item, count) {
      if (count > maxCount) {
        maxCount = count;
        mostFrequent = item;
      }
    });

    return mostFrequent;
  }

  static EnergyAnalyticsService get instance => _instance;
}
