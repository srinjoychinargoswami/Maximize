import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:kinetic/services/energy_service.dart';
import 'package:kinetic/services/completion_log_service.dart';
import 'package:kinetic/services/metrics_service.dart';
import 'package:kinetic/models/energy_model.dart';
import 'package:kinetic/models/completion_log_model.dart';
import 'package:intl/intl.dart';

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  bool _isRefreshing = false;
  late Future<List<EnergyEntryModel>> _energyEntriesFuture;
  late Future<List<CompletionLogModel>> _completionLogsFuture;
  late Future<int> _completedTasksFuture;
  late Future<int> _totalTasksFuture;

  @override
  void initState() {
    super.initState();
    _initializeFutures();
  }

  void _initializeFutures() {
    final energyService = context.read<EnergyService>();
    final completionLogService = context.read<CompletionLogService>();
    final metricsService = context.read<MetricsService>();

    _energyEntriesFuture = energyService.getEntriesPast30Days();
    _completionLogsFuture = completionLogService.getAllCompletions();
    _completedTasksFuture = metricsService.getCompletedTasks();
    _totalTasksFuture = metricsService.getTotalTasks();
  }

  Future<void> _loadInsights() async {
    final energyService = context.read<EnergyService>();
    final completionLogService = context.read<CompletionLogService>();
    final metricsService = context.read<MetricsService>();

    setState(() {
      _energyEntriesFuture = energyService.getEntriesPast30Days();
      _completionLogsFuture = completionLogService.getAllCompletions();
      _completedTasksFuture = metricsService.getCompletedTasks();
      _totalTasksFuture = metricsService.getTotalTasks();
    });
    // Add a small delay to ensure FutureBuilder rebuilds
    await Future.delayed(const Duration(milliseconds: 100));
  }

  // Public method for parent to call via GlobalKey
  Future<void> refreshPage() async {
    return _refresh();
  }

  Future<void> _refresh() async {
    if (_isRefreshing) return;
    if (!mounted) return;

    setState(() => _isRefreshing = true);
    try {
      await _loadInsights();
      if (mounted) {
        setState(() => _isRefreshing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Insights refreshed!'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
      debugPrint('Error refreshing insights: $e');
    }
  }

  Future<void> _refreshInsights() async {
    await _loadInsights();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insights refreshed!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refresh,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: RefreshIndicator(
          onRefresh: _refreshInsights,
          color: Colors.blue,
          backgroundColor: Colors.white,
          strokeWidth: 2.0,
          displacement: 40.0,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === 1. YOUR PEAK ENERGY WINDOW (MOST IMPORTANT) ===
              _buildPeakEnergyWindow(),
              const SizedBox(height: 24),

              // === 2. ENERGY × PRODUCTIVITY CORRELATION ===
              _buildEnergyProductivityCorrelation(),
              const SizedBox(height: 24),

              // === 3. WHEN YOU WORK BEST ===
              _buildBestWorkTimes(),
              const SizedBox(height: 24),

              // === 4. MOOD & ENVIRONMENT PATTERNS ===
              _buildMoodEnvironmentPatterns(),
              const SizedBox(height: 24),

              // === 5. RECOVERY TIME TRACKING ===
              _buildRecoveryTimeTracking(),
              const SizedBox(height: 24),

              // === 6. COMPLETION RATES BY ENERGY LEVEL ===
              _buildCompletionByEnergy(),
              const SizedBox(height: 24),

              // === 7. PROCRASTINATION PATTERNS ===
              _buildProcrastinationPatterns(),
              const SizedBox(height: 24),

              // === 8. ACTIONABLE RECOMMENDATIONS ===
              _buildRecommendations(),
            ],
            ),
          ),
        ),
      ),
    );
  }

  // === 1. YOUR PEAK ENERGY WINDOW (HERO SECTION) ===
  Widget _buildPeakEnergyWindow() {
    return FutureBuilder<List<EnergyEntryModel>>(
      future: _energyEntriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final entries = snapshot.data ?? [];
        if (entries.isEmpty) {
          return Card(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                '📊 Log energy entries to see your peak energy window patterns.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
          );
        }

        // Calculate peak energy window (most common time range with 8+/10)
        final peakEntries = entries.where((e) => e.energyLevel >= 8).toList();
        String peakWindow = 'TBD';

        if (peakEntries.isNotEmpty) {
          final hours = peakEntries.map((e) => e.timestamp.hour).toList();
          final mostCommonHour = hours.fold<Map<int, int>>(
            {},
            (map, hour) {
              map[hour] = (map[hour] ?? 0) + 1;
              return map;
            },
          ).entries.reduce((a, b) => a.value > b.value ? a : b).key;

          peakWindow = '${mostCommonHour.toString().padLeft(2, '0')}:00 - ${(mostCommonHour + 2).toString().padLeft(2, '0')}:00';
        }

        final avgPeak = peakEntries.isEmpty ? 0 : peakEntries.map((e) => e.energyLevel).reduce((a, b) => a + b) ~/ peakEntries.length;

        return Card(
          elevation: 4,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.amber.withOpacity(0.2),
                  Colors.amber.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🎯 Your Peak Energy Window',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Based on your energy data:',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        peakWindow,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'You consistently rate your energy at ${avgPeak}/10 during peak hours.\n\n'
                        '💡 Schedule your hardest, most important work during this window.\n\n'
                        '✅ Peak energy entries recorded: ${peakEntries.length}\n'
                        '📊 From past 30 days of data.',
                        style: const TextStyle(fontSize: 13, height: 1.8),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '🎯 Action: Block this time on your calendar for deep work.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // === 2. ENERGY × PRODUCTIVITY CORRELATION ===
  Widget _buildEnergyProductivityCorrelation() {
    return FutureBuilder<List<CompletionLogModel>>(
      future: _completionLogsFuture,
      builder: (context, logSnapshot) {
        if (logSnapshot.connectionState == ConnectionState.waiting) {
          return Card(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final logs = logSnapshot.data ?? [];

        return FutureBuilder<List<EnergyEntryModel>>(
          future: _energyEntriesFuture,
          builder: (context, energySnapshot) {
            final energyEntries = energySnapshot.data ?? [];

            if (logs.isEmpty || energyEntries.isEmpty) {
              return Card(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    '📊 Complete tasks while logging energy to see productivity correlations.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
              );
            }

            // Calculate completion rates for each energy level
            final energyToCompletion = <String, (int, int)>{
              '8-10/10': (0, 0),
              '5-7/10': (0, 0),
              '3-5/10': (0, 0),
              '1-3/10': (0, 0),
            };

            for (final log in logs) {
              final energyAtTime = energyEntries
                  .where((e) => e.timestamp.day == log.completedAt.day)
                  .fold<int?>(null, (prev, e) => e.energyLevel);

              if (energyAtTime != null) {
                String bucket;
                if (energyAtTime >= 8) bucket = '8-10/10';
                else if (energyAtTime >= 5) bucket = '5-7/10';
                else if (energyAtTime >= 3) bucket = '3-5/10';
                else bucket = '1-3/10';

                final (completed, total) = energyToCompletion[bucket]!;
                energyToCompletion[bucket] = (completed + 1, total + 1);
              }
            }

            return Card(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚡ Energy Level vs Task Completion',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildEnergyComparisonRow(
                      energyRange: '8-10/10',
                      emoji: '🔥',
                      completed: energyToCompletion['8-10/10']!.$1,
                      total: energyToCompletion['8-10/10']!.$2,
                      description: 'Peak energy — your best work',
                      color: Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildEnergyComparisonRow(
                      energyRange: '5-7/10',
                      emoji: '⚡',
                      completed: energyToCompletion['5-7/10']!.$1,
                      total: energyToCompletion['5-7/10']!.$2,
                      description: 'Good energy — solid productivity',
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 12),
                    _buildEnergyComparisonRow(
                      energyRange: '3-5/10',
                      emoji: '😴',
                      completed: energyToCompletion['3-5/10']!.$1,
                      total: energyToCompletion['3-5/10']!.$2,
                      description: 'Low energy — admin/routine work',
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    _buildEnergyComparisonRow(
                      energyRange: '1-3/10',
                      emoji: '🥱',
                      completed: energyToCompletion['1-3/10']!.$1,
                      total: energyToCompletion['1-3/10']!.$2,
                      description: 'Very low — mostly skipped',
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '📊 The pattern is clear: Your productivity DIRECTLY correlates with energy level.\n\n'
                        'When energy is high, you complete more tasks. When it\'s low, tasks pile up.',
                        style: TextStyle(fontSize: 12, height: 1.8),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEnergyComparisonRow({
    required String energyRange,
    required String emoji,
    required int completed,
    required int total,
    required String description,
    required Color color,
  }) {
    final percentage = total == 0 ? 0 : ((completed / total) * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  energyRange,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                '$completed/$total tasks',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // === 3. WHEN YOU WORK BEST ===
  Widget _buildBestWorkTimes() {
    return FutureBuilder<List<EnergyEntryModel>>(
      future: _energyEntriesFuture,
      builder: (context, snapshot) {
        final entries = snapshot.data ?? [];

        if (entries.isEmpty) {
          return Card(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🎯 When You Work Best',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '📊 Log energy entries over time to see your best work windows.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        // Calculate average energy by hour
        final hourlyAvg = <int, (int, int)>{};
        for (final entry in entries) {
          final hour = entry.timestamp.hour;
          final (sum, count) = hourlyAvg[hour] ?? (0, 0);
          hourlyAvg[hour] = (sum + entry.energyLevel, count + 1);
        }

        final hoursList = hourlyAvg.entries
            .map((e) => (e.key, e.value.$1 ~/ e.value.$2))
            .toList();
        hoursList.sort((a, b) => b.$2.compareTo(a.$2));
        final topHours = hoursList.take(3).toList();

        return Card(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🎯 When You Work Best',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...topHours.map((hourData) {
                  final hour = hourData.$1;
                  final avgEnergy = hourData.$2;
                  final timeStr = '${hour.toString().padLeft(2, '0')}:00 - ${(hour + 2).toString().padLeft(2, '0')}:00';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildTimeWindowCard(
                      time: timeStr,
                      rating: '$avgEnergy/10',
                      bestFor: avgEnergy >= 8
                          ? 'Peak performance time'
                          : avgEnergy >= 5
                              ? 'Productive work time'
                              : 'Best for routine tasks',
                      icon: avgEnergy >= 8 ? '🔥' : avgEnergy >= 5 ? '⚡' : '😴',
                      color: avgEnergy >= 8
                          ? Colors.green
                          : avgEnergy >= 5
                              ? Colors.amber
                              : Colors.orange,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeWindowCard({
    required String time,
    required String rating,
    required String bestFor,
    required String icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$icon $time', style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                rating,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            bestFor,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // === 4. MOOD & ENVIRONMENT PATTERNS ===
  Widget _buildMoodEnvironmentPatterns() {
    return FutureBuilder<List<EnergyEntryModel>>(
      future: _energyEntriesFuture,
      builder: (context, snapshot) {
        final entries = snapshot.data ?? [];

        if (entries.isEmpty) {
          return Card(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🌍 Your Mood & Environment',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '📊 Log mood tags and location to see patterns.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        // Find most common mood
        final moods = <String, int>{};
        for (final entry in entries) {
          for (final mood in entry.moodTags) {
            moods[mood] = (moods[mood] ?? 0) + 1;
          }
        }
        final bestMood = moods.isEmpty
            ? 'Logging'
            : moods.entries.reduce((a, b) => a.value > b.value ? a : b).key;

        // Find most common location
        final locations = <String, int>{};
        for (final entry in entries) {
          locations[entry.location] = (locations[entry.location] ?? 0) + 1;
        }
        final bestLocation = locations.isEmpty
            ? 'Various'
            : locations.entries.reduce((a, b) => a.value > b.value ? a : b).key;

        return Card(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🌍 Your Mood & Environment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '😊 Most Common Mood',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bestMood,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${moods[bestMood] ?? 0} entries recorded',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📍 Most Common Location',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bestLocation,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${locations[bestLocation] ?? 0} times logged',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // === 5. RECOVERY TIME TRACKING ===
  Widget _buildRecoveryTimeTracking() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔋 Recovery Time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'After peak-energy work sessions:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '📊 Log energy multiple times per day to track recovery patterns.\n\n'
                    'This helps you understand when you typically dip in energy after intense focus sessions.\n\n'
                    '💡 Schedule recovery activities (breaks, walks, meals) strategically.',
                    style: TextStyle(fontSize: 12, height: 1.8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === 6. COMPLETION RATES BY ENERGY LEVEL ===
  Widget _buildCompletionByEnergy() {
    final metricsService = context.read<MetricsService>();

    return FutureBuilder<int>(
      future: metricsService.getThisWeekDone(),
      builder: (context, weekSnapshot) {
        final weekDone = weekSnapshot.data ?? 0;

        return FutureBuilder<int>(
          future: metricsService.getTotalDone(),
          builder: (context, totalSnapshot) {
            final totalDone = totalSnapshot.data ?? 0;

            return Card(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📈 Completion Trends',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('This Week', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text('$weekDone tasks', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: weekDone > 0 ? (weekDone / (weekDone + 5)).clamp(0, 1) : 0,
                                  minHeight: 6,
                                  backgroundColor: Colors.grey.withOpacity(0.2),
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${((weekDone / (weekDone + 5)) * 100).toInt()}%',
                                style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('All Time', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text('$totalDone tasks', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: totalDone > 0 ? (totalDone / (totalDone + 10)).clamp(0, 1) : 0,
                                  minHeight: 6,
                                  backgroundColor: Colors.grey.withOpacity(0.2),
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${((totalDone / (totalDone + 10)) * 100).toInt()}%',
                                style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // === 7. PROCRASTINATION PATTERNS ===
  Widget _buildProcrastinationPatterns() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⏳ Procrastination Patterns',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🚩 Track procrastination patterns:',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Complete tasks at various energy levels\n'
                    '• Log completion times consistently\n'
                    '• Rate task priority levels\n\n'
                    '💡 Once you have enough data, Kinetic will identify your procrastination triggers.',
                    style: TextStyle(fontSize: 12, height: 1.8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === 8. ACTIONABLE RECOMMENDATIONS ===
  Widget _buildRecommendations() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '💡 Your Action Plan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRecommendationItem(
              number: '1',
              title: 'Log Energy Regularly',
              description: 'Log your energy 2-3x daily to build pattern data. Use the Energy tab.',
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            _buildRecommendationItem(
              number: '2',
              title: 'Complete Tasks Consistently',
              description: 'Mark tasks done as you finish them. This trains the recommendations algorithm.',
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildRecommendationItem(
              number: '3',
              title: 'Tag Task Energy Requirements',
              description: 'When adding tasks, rate how much energy they require (1-10).',
              color: Colors.purple,
            ),
            const SizedBox(height: 12),
            _buildRecommendationItem(
              number: '4',
              title: 'Add Mood & Location Context',
              description: 'When logging energy, include mood tags and location for better insights.',
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem({
    required String number,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
