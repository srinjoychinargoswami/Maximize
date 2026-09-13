import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:kinetic/services/energy_service.dart';
import 'package:kinetic/models/energy_model.dart';
import 'package:intl/intl.dart';

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class EnergyDashboardScreen extends StatefulWidget {
  const EnergyDashboardScreen({Key? key}) : super(key: key);

  @override
  State<EnergyDashboardScreen> createState() => _EnergyDashboardScreenState();
}

class _EnergyDashboardScreenState extends State<EnergyDashboardScreen> {
  bool _isRefreshing = false;
  late Future<EnergyEntryModel?> _todaysEntryFuture;
  late Future<List<EnergyEntryModel>> _past30DaysFuture;

  @override
  void initState() {
    super.initState();
    _initializeFutures();
  }

  void _initializeFutures() {
    final energyService = context.read<EnergyService>();
    _todaysEntryFuture = energyService.getTodaysEntry();
    _past30DaysFuture = energyService.getEntriesPast30Days();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadEnergyData() async {
    final energyService = context.read<EnergyService>();
    setState(() {
      _todaysEntryFuture = energyService.getTodaysEntry();
      _past30DaysFuture = energyService.getEntriesPast30Days();
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
      await _loadEnergyData();
      if (mounted) {
        setState(() => _isRefreshing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Energy dashboard refreshed!'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
      debugPrint('Error refreshing energy dashboard: $e');
    }
  }

  Future<void> _refreshEnergy() async {
    await _loadEnergyData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Energy dashboard refreshed!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Dashboard'),
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
          onRefresh: _refreshEnergy,
          color: Colors.blue,
          backgroundColor: Colors.white,
          strokeWidth: 2.0,
          displacement: 40.0,
          child: FutureBuilder<EnergyEntryModel?>(
            future: _todaysEntryFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final entry = snapshot.data;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCurrentEnergyCard(entry),
                    const SizedBox(height: 24),
                    _buildWeeklyTrendCard(),
                    const SizedBox(height: 24),
                    _buildInsightsSection(entry),
                    const SizedBox(height: 24),
                    _buildLogEnergyCard(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentEnergyCard(EnergyEntryModel? latest) {
    // Show "Not logged yet" if no energy entry exists
    if (latest == null) {
      return Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.grey.withOpacity(0.1),
                Colors.grey.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Current Energy',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                'Not logged yet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tap "Log Energy Level" below to record your energy and get personalized insights.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final level = latest.energyLevel;
    final timestamp = latest.timestamp;

    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.amber.withOpacity(0.1),
              Colors.amber.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Current Energy',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$level/10',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                Text(
                  _getEnergyEmoji(level),
                  style: const TextStyle(fontSize: 48),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _getEnergyStatus(level),
              style: TextStyle(
                fontSize: 14,
                color: _getEnergyStatusColor(level),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Logged at ${DateFormat('h:mm a').format(timestamp)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyTrendCard() {
    return FutureBuilder<List<EnergyEntryModel>>(
      future: _past30DaysFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Card(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Text('No energy data yet. Start logging!'),
            ),
          );
        }

        final entries = snapshot.data!;
        final last7 = entries.length > 7 ? entries.sublist(entries.length - 7) : entries;

        return Card(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📊 This Week\'s Energy',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: last7.length,
                    itemBuilder: (context, index) {
                      final entry = last7[index];
                      final height = (entry.energyLevel / 10) * 100;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 30,
                              height: height,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              DateFormat('EEE').format(entry.timestamp),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        );
      },
    );
  }

  Widget _buildInsightsSection(EnergyEntryModel? entry) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '💡 Your Patterns',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInsightRow('Current Level', '${entry?.energyLevel ?? "—"}/10'),
            _buildInsightRow('Mood', entry?.moodTags.isNotEmpty == true ? entry!.moodTags.first : '—'),
            _buildInsightRow('Location', entry?.location ?? '—'),
            if (entry?.notes != null && entry!.notes!.isNotEmpty) ...[
              _buildInsightRow('Notes', entry.notes ?? '—'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInsightRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogEnergyCard() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔋 Log New Energy',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _showEnergyLogDialog();
              },
              icon: const Icon(Icons.add),
              label: const Text('Log Energy Level'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEnergyLogDialog() {
    int selectedLevel = 5;
    String selectedMood = 'Neutral';
    String selectedLocation = 'Home';

    final moods = ['Very Bad', 'Bad', 'Neutral', 'Good', 'Excellent'];
    final locations = ['Home', 'Work', 'Cafe', 'Outdoors', 'Other'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('How\'s Your Energy?'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === ENERGY SLIDER ===
                    const Text(
                      'Energy Level',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: selectedLevel.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: '$selectedLevel',
                      onChanged: (value) {
                        setState(() => selectedLevel = value.toInt());
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getEnergyStatus(selectedLevel),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getEnergyStatusColor(selectedLevel),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // === MOOD DROPDOWN ===
                    const Text(
                      'Your Mood',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedMood,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: moods.map((mood) {
                          return DropdownMenuItem(
                            value: mood,
                            child: Text(mood),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedMood = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // === LOCATION DROPDOWN ===
                    const Text(
                      'Location',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedLocation,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: locations.map((location) {
                          return DropdownMenuItem(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedLocation = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<EnergyService>().createEnergyEntry(
                      energyLevel: selectedLevel,
                      moodTags: [selectedMood],
                      privacyContext: 'Dashboard',
                      location: selectedLocation,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Energy logged with mood & location!')),
                    );
                    setState(() {});
                  },
                  child: const Text('Log'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getEnergyEmoji(int level) {
    if (level >= 8) return '🔥';
    if (level >= 5) return '⚡';
    if (level >= 3) return '😴';
    return '🥱';
  }

  String _getEnergyStatus(int level) {
    if (level >= 8) return 'Peak energy! Perfect for deep work.';
    if (level >= 5) return 'Good energy. Ready for solid tasks.';
    if (level >= 3) return 'Low energy. Best for admin work.';
    return 'Very low. Time to rest.';
  }

  Color _getEnergyStatusColor(int level) {
    if (level >= 8) return Colors.green;
    if (level >= 5) return Colors.amber;
    if (level >= 3) return Colors.orange;
    return Colors.red;
  }
}
