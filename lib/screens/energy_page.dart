import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maximize/models/energy_model.dart';
import 'package:maximize/models/energy_entry.dart';
import 'package:maximize/services/energy_service.dart';
import 'package:maximize/services/firebase_realtime_sync_service.dart';
import 'package:maximize/database/app_database.dart' hide EnergyEntry;
import 'package:intl/intl.dart';

class EnergyPage extends StatefulWidget {
  final AppDatabase database;

  const EnergyPage({super.key, required this.database});

  @override
  State<EnergyPage> createState() => _EnergyPageState();
}

class _EnergyPageState extends State<EnergyPage> with TickerProviderStateMixin {
  late EnergyService _energyService;
  late AnimationController _fadeController;
  late TextEditingController _notesController;

  // Form state
  int _energyLevel = 5;
  DateTime _selectedTime = DateTime.now();
  List<String> _selectedMoods = [];
  String? _selectedContext;
  String? _selectedLocation;
  String? _notes;
  bool _isLoading = false;
  EnergyEntryModel? _todaysEntry;
  bool _isEditingTodaysEntry = false;

  @override
  void initState() {
    super.initState();
    _energyService = context.read<EnergyService>();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _notesController = TextEditingController();
    _loadTodaysEntry();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadTodaysEntry() async {
    try {
      final entry = await _energyService.getTodaysEntry();
      if (entry != null && mounted) {
        setState(() {
          _todaysEntry = entry;
          _isEditingTodaysEntry = true;
          _energyLevel = entry.energyLevel;
          _selectedTime = entry.timestamp;
          _selectedMoods = List<String>.from(entry.moodTags);
          _selectedContext = entry.privacyContext;
          _selectedLocation = entry.location;
          _notes = entry.notes;
          _notesController.text = entry.notes ?? '';
        });
        _fadeController.forward();
      } else {
        _fadeController.forward();
      }
    } catch (e) {
      if (mounted) {
        _fadeController.forward();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading entry: $e')),
        );
      }
    }
  }

  Future<void> _saveEntry() async {
    // Validation
    if (_selectedContext == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a privacy context')),
      );
      return;
    }

    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isEditingTodaysEntry && _todaysEntry != null) {
        // Update existing entry
        final updated = _todaysEntry!.copyWith(
          timestamp: _selectedTime,
          energyLevel: _energyLevel,
          moodTags: _selectedMoods,
          privacyContext: _selectedContext,
          location: _selectedLocation,
          notes: _notes,
          updatedAt: DateTime.now(),
        );

        await _energyService.updateEnergyEntry(
          updated.id,
          energyLevel: _energyLevel,
          moodTags: _selectedMoods,
          privacyContext: _selectedContext,
          location: _selectedLocation,
          notes: _notes,
        );

        // Sync updated entry to Firebase
        final energyEntry = EnergyEntry(
          id: updated.id,
          timestamp: updated.timestamp,
          energyLevel: updated.energyLevel,
          moodTags: updated.moodTags,
          privacyContext: updated.privacyContext,
          location: updated.location,
          notes: updated.notes,
          createdAt: updated.createdAt,
          updatedAt: updated.updatedAt,
        );
        await FirebaseRealtimeSyncService.instance.syncEnergyEntry(energyEntry);

        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Energy updated at ${DateFormat('h:mm a').format(_selectedTime)}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Create new entry
        await _energyService.createEnergyEntry(
          energyLevel: _energyLevel,
          moodTags: _selectedMoods,
          privacyContext: _selectedContext!,
          location: _selectedLocation!,
          notes: _notes,
        );

        if (mounted) {
          // Reload today's entry to populate _todaysEntry
          await _loadTodaysEntry();

          // Sync new entry to Firebase
          if (_todaysEntry != null) {
            final energyEntry = EnergyEntry(
              id: _todaysEntry!.id,
              timestamp: _todaysEntry!.timestamp,
              energyLevel: _todaysEntry!.energyLevel,
              moodTags: _todaysEntry!.moodTags,
              privacyContext: _todaysEntry!.privacyContext,
              location: _todaysEntry!.location,
              notes: _todaysEntry!.notes,
              createdAt: _todaysEntry!.createdAt,
              updatedAt: _todaysEntry!.updatedAt,
            );
            await FirebaseRealtimeSyncService.instance.syncEnergyEntry(energyEntry);
          }

          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Energy logged at ${DateFormat('h:mm a').format(_selectedTime)}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving entry: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteEntry() async {
    if (_todaysEntry == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry?'),
        content: const Text('Are you sure you want to delete today\'s energy entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final entryId = _todaysEntry!.id;

      await _energyService.deleteEnergyEntry(entryId);

      // Sync deletion to Firebase
      await FirebaseRealtimeSyncService.instance.deleteEnergyEntry(entryId);

      if (mounted) {
        setState(() {
          _isLoading = false;
          _todaysEntry = null;
          _isEditingTodaysEntry = false;
          _energyLevel = 5;
          _selectedTime = DateTime.now();
          _selectedMoods = [];
          _selectedContext = null;
          _selectedLocation = null;
          _notes = null;
          _notesController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Entry deleted'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting entry: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectTime() async {
    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTime),
    );

    if (timeOfDay != null) {
      setState(() {
        _selectedTime = DateTime(
          _selectedTime.year,
          _selectedTime.month,
          _selectedTime.day,
          timeOfDay.hour,
          timeOfDay.minute,
        );
      });
    }
  }

  Color _getEnergyColor(int level) {
    if (level <= 3) return Colors.red;
    if (level <= 6) return Colors.amber;
    return Colors.green;
  }

  String _getEnergyDescription(int level) {
    switch (level) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text('Log Energy', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          if (_isEditingTodaysEntry)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Logged at ${DateFormat('h:mm a').format(_todaysEntry?.timestamp ?? DateTime.now())}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeController.view,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Energy Level Slider
              Card(
                color: Colors.grey[800],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Energy Level',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getEnergyColor(_energyLevel),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$_energyLevel/10',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getEnergyDescription(_energyLevel),
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      Slider(
                        value: _energyLevel.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        activeColor: _getEnergyColor(_energyLevel),
                        inactiveColor: Colors.grey[700],
                        onChanged: (value) => setState(() => _energyLevel = value.toInt()),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Time Picker
              Card(
                color: Colors.grey[800],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Time',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('h:mm a').format(_selectedTime),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          ElevatedButton.icon(
                            onPressed: _selectTime,
                            icon: const Icon(Icons.access_time),
                            label: const Text('Change'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Mood Tags
              Card(
                color: Colors.grey[800],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mood (${_selectedMoods.length} selected)',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: MoodTags.all.map((mood) {
                          final isSelected = _selectedMoods.contains(mood);
                          return FilterChip(
                            label: Text(mood),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedMoods.add(mood);
                                } else {
                                  _selectedMoods.remove(mood);
                                }
                              });
                            },
                            backgroundColor: Colors.grey[700],
                            selectedColor: Colors.blue[400],
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey[300],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Privacy Context
              Card(
                color: Colors.grey[800],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Privacy Context',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      DropdownButton<String>(
                        value: _selectedContext,
                        hint: const Text('Select one'),
                        isExpanded: true,
                        dropdownColor: Colors.grey[800],
                        items: PrivacyContexts.all.map((context) {
                          return DropdownMenuItem(
                            value: context,
                            child: Text(context),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedContext = value),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Location
              Card(
                color: Colors.grey[800],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Location',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      DropdownButton<String>(
                        value: _selectedLocation,
                        hint: const Text('Select one'),
                        isExpanded: true,
                        dropdownColor: Colors.grey[800],
                        items: Locations.all.map((location) {
                          return DropdownMenuItem(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedLocation = value),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Notes
              Card(
                color: Colors.grey[800],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notes (Optional)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _notesController,
                        maxLines: 5,
                        onChanged: (value) => _notes = value.isNotEmpty ? value : null,
                        decoration: InputDecoration(
                          hintText: 'Add notes...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          fillColor: Colors.grey[700],
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: (_selectedContext != null && _selectedLocation != null && !_isLoading)
                        ? _saveEntry
                        : null,
                    icon: _isLoading ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ) : const Icon(Icons.save),
                    label: Text(_isEditingTodaysEntry ? 'Update Entry' : 'Save Energy Entry'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue[600],
                      disabledBackgroundColor: Colors.grey[600],
                    ),
                  ),
                  if (_isEditingTodaysEntry) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _isLoading ? null : _deleteEntry,
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete Entry'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
