import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kinetic/services/energy_service.dart';
import 'package:kinetic/models/energy_model.dart';
import 'package:intl/intl.dart';

class EnergyDashboardScreen extends StatefulWidget {
  const EnergyDashboardScreen({Key? key}) : super(key: key);

  @override
  State<EnergyDashboardScreen> createState() => _EnergyDashboardScreenState();
}

class _EnergyDashboardScreenState extends State<EnergyDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Dashboard'),
        centerTitle: true,
      ),
      body: Consumer<EnergyService>(
        builder: (context, energyService, _) {
          return FutureBuilder<EnergyEntryModel?>(
            future: energyService.getTodaysEntry(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final entry = snapshot.data;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCurrentEnergyCard(entry),
                    const SizedBox(height: 24),
                    _buildWeeklyTrendCard(energyService),
                    const SizedBox(height: 24),
                    _buildInsightsSection(entry),
                    const SizedBox(height: 24),
                    _buildLogEnergyCard(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCurrentEnergyCard(EnergyEntryModel? latest) {
    final level = latest?.energyLevel ?? 5;
    final timestamp = latest?.timestamp;

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
            if (timestamp != null) ...[
              const SizedBox(height: 8),
              Text(
                'Last updated: ${DateFormat('h:mm a').format(timestamp)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyTrendCard(EnergyService energyService) {
    return FutureBuilder<List<EnergyEntryModel>>(
      future: energyService.getEntriesPast30Days(),
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

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('How\'s Your Energy?'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  const SizedBox(height: 16),
                  Text(
                    _getEnergyStatus(selectedLevel),
                    style: TextStyle(
                      fontSize: 14,
                      color: _getEnergyStatusColor(selectedLevel),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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
                      moodTags: [],
                      privacyContext: 'Dashboard',
                      location: 'Home',
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Energy logged!')),
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
