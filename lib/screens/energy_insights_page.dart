import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:maximize/services/energy_analytics_service.dart';
import 'package:maximize/database/app_database.dart';

class EnergyInsightsPage extends StatefulWidget {
  final AppDatabase database;

  const EnergyInsightsPage({super.key, required this.database});

  @override
  State<EnergyInsightsPage> createState() => _EnergyInsightsPageState();
}

class _EnergyInsightsPageState extends State<EnergyInsightsPage> {
  late EnergyAnalyticsService _analyticsService;
  bool _isLoading = true;

  // Analytics data
  String _summary = '';
  Map<int, double> _hourlyData = {};
  Map<String, int> _moodFrequency = {};
  Map<String, double> _contextData = {};
  Map<String, double> _locationData = {};
  int? _peakHour;
  String? _bestMood;
  Map<String, dynamic>? _bestCombo;

  @override
  void initState() {
    super.initState();
    _analyticsService = context.read<EnergyAnalyticsService>();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _analyticsService.getInsightsSummary(),
        _analyticsService.getHourlyAverageEnergy(),
        _analyticsService.getWeeklyHeatmapData(),
        _analyticsService.getMoodFrequency(),
        _analyticsService.getContextCorrelation(),
        _analyticsService.getLocationCorrelation(),
        _analyticsService.getPeakEnergyHour(),
        _analyticsService.getBestMoodDuringPeakEnergy(),
        _analyticsService.getBestContextCombo(),
      ]);

      if (mounted) {
        setState(() {
          _summary = results[0] as String;
          _hourlyData = results[1] as Map<int, double>;
          _moodFrequency = results[3] as Map<String, int>;
          _contextData = results[4] as Map<String, double>;
          _locationData = results[5] as Map<String, double>;
          _peakHour = results[6] as int?;
          _bestMood = results[7] as String?;
          _bestCombo = results[8] as Map<String, dynamic>?;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading analytics: $e')),
        );
      }
    }
  }

  Color _getEnergyColor(double energy) {
    if (energy <= 3) return Colors.red;
    if (energy <= 6) return Colors.amber;
    return Colors.green;
  }

  String _formatHour(int hour) {
    final time = TimeOfDay(hour: hour, minute: 0);
    return time.format(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text('Energy Insights', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalytics,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hourlyData.isEmpty && _moodFrequency.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.insights, size: 64, color: Colors.grey[600]),
                      const SizedBox(height: 16),
                      Text(
                        'Start logging energy to see insights',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Card
                      _buildSummaryCard(),
                      const SizedBox(height: 24),

                      // Quick Stats Cards
                      _buildQuickStatsRow(),
                      const SizedBox(height: 24),

                      // Hourly Energy Chart
                      _buildSectionHeader('Energy by Hour'),
                      _buildHourlyChart(),
                      const SizedBox(height: 24),

                      // Mood Frequency Pie Chart
                      _buildSectionHeader('Mood Breakdown'),
                      if (_moodFrequency.isNotEmpty)
                        _buildMoodChart()
                      else
                        _buildEmptyState('No mood data'),
                      const SizedBox(height: 24),

                      // Context & Location Correlation
                      _buildSectionHeader('Privacy Context Energy'),
                      if (_contextData.isNotEmpty)
                        _buildContextTable()
                      else
                        _buildEmptyState('No context data'),
                      const SizedBox(height: 24),

                      _buildSectionHeader('Location Energy'),
                      if (_locationData.isNotEmpty)
                        _buildLocationTable()
                      else
                        _buildEmptyState('No location data'),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Insights Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _summary.isEmpty ? 'No insights yet' : _summary,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[300],
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsRow() {
    return Row(
      children: [
        if (_peakHour != null) ...[
          Expanded(
            child: _buildStatCard(
              'Peak Hour',
              _formatHour(_peakHour!),
              'Your most energetic hour',
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
        ],
        if (_bestMood != null) ...[
          Expanded(
            child: _buildStatCard(
              'Best Mood',
              _bestMood!,
              'Most productive mood',
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
        ],
        if (_bestCombo != null) ...[
          Expanded(
            child: _buildStatCard(
              'Best Context',
              '${_bestCombo!['privacy']} at ${_bestCombo!['location']}',
              'Best energy combo',
              Colors.orange,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, Color color) {
    return Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHourlyChart() {
    return Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              maxY: 10,
              minY: 0,
              barGroups: List.generate(
                24,
                (i) => BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: _hourlyData[i] ?? 0,
                      color: _getEnergyColor(_hourlyData[i] ?? 0),
                      width: 8,
                    ),
                  ],
                ),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final hour = value.toInt();
                      if (hour % 3 == 0) {
                        return Text(
                          '${hour}h',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodChart() {
    final total = _moodFrequency.values.fold<int>(0, (a, b) => a + b);
    final moodColors = {
      'Focused': Colors.blue,
      'Energetic': Colors.green,
      'Distracted': Colors.amber,
      'Drained': Colors.red,
      'Stressed': Colors.orange,
    };

    return Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(
              sections: _moodFrequency.entries.map((entry) {
                final percentage = (entry.value / total) * 100;
                return PieChartSectionData(
                  value: entry.value.toDouble(),
                  title: '${percentage.toStringAsFixed(0)}%',
                  color: moodColors[entry.key] ?? Colors.grey,
                  radius: 100,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContextTable() {
    return Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Expanded(flex: 2, child: Text('Context', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('Energy', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('Count', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            const Divider(color: Colors.grey),
            ..._contextData.entries.map((entry) {
              final energy = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(entry.key, style: const TextStyle(fontSize: 14)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getEnergyColor(energy).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${energy.toStringAsFixed(1)}/10',
                          style: TextStyle(
                            color: _getEnergyColor(energy),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        _countEntriesForContext(entry.key).toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationTable() {
    return Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Expanded(flex: 2, child: Text('Location', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('Energy', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('Count', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            const Divider(color: Colors.grey),
            ..._locationData.entries.map((entry) {
              final energy = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(entry.key, style: const TextStyle(fontSize: 14)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getEnergyColor(energy).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${energy.toStringAsFixed(1)}/10',
                          style: TextStyle(
                            color: _getEnergyColor(energy),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        _countEntriesForLocation(entry.key).toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            message,
            style: TextStyle(color: Colors.grey[400]),
          ),
        ),
      ),
    );
  }

  int _countEntriesForContext(String context) {
    // This is a placeholder - would need access to raw entries
    // For now, we can derive from the correlation value
    return 0; // TODO: Implement proper counting
  }

  int _countEntriesForLocation(String location) {
    // This is a placeholder - would need access to raw entries
    // For now, we can derive from the correlation value
    return 0; // TODO: Implement proper counting
  }
}
