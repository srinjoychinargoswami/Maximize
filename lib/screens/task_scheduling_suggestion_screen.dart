import 'package:flutter/material.dart';
import 'package:kinetic/models/task_model.dart';

class TaskSchedulingSuggestionScreen extends StatefulWidget {
  final TaskModel task;
  final int currentEnergy;

  const TaskSchedulingSuggestionScreen({
    Key? key,
    required this.task,
    required this.currentEnergy,
  }) : super(key: key);

  @override
  State<TaskSchedulingSuggestionScreen> createState() => _TaskSchedulingSuggestionScreenState();
}

class _TaskSchedulingSuggestionScreenState extends State<TaskSchedulingSuggestionScreen> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('When Should You Do This? (Energy-Optimized)'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Requires: ${_getEnergyLabel(widget.task.energyRequired)}/10 energy',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Current energy status
            Text(
              'Your Energy Now: ${widget.currentEnergy}/10',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            _buildEnergyStatusBox(widget.currentEnergy),
            const SizedBox(height: 20),

            // Scheduling recommendation
            Text(
              'Recommended Timing',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 12),
            _buildSchedulingRecommendation(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Schedule Later'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Got It!'),
        ),
      ],
    );
  }

  Widget _buildEnergyStatusBox(int currentEnergy) {
    String status;
    Color color;

    if (currentEnergy >= 8) {
      status = '🔥 Peak Energy! Perfect time for this task.';
      color = Colors.green;
    } else if (currentEnergy >= widget.task.energyRequired) {
      status = '⚡ Good enough. You can do this now.';
      color = Colors.amber;
    } else if (widget.task.energyRequired <= 5) {
      status = '😴 Low energy, but this task only needs ${widget.task.energyRequired}/10. Go for it.';
      color = Colors.orange;
    } else {
      status = '⚠️ Your energy is lower than ideal. Save for peak time (10pm-1am).';
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSchedulingRecommendation() {
    if (widget.task.energyRequired >= 8) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🎯 Best Time: Tonight (10:00 PM - 1:00 AM)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              'This task needs peak energy. Your peak window is tonight.\n\n'
              'Block this time on your calendar.',
              style: TextStyle(fontSize: 11, height: 1.6),
            ),
          ],
        ),
      );
    } else if (widget.task.energyRequired >= 5) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.1),
          border: Border.all(color: Colors.amber),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚡ Flexible: Do when energy hits 5-6/10',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              'This task is moderately demanding. Best in your morning (9am) or tonight (10pm).\n\n'
              'Avoid afternoons (2-5pm) when your energy dips.',
              style: TextStyle(fontSize: 11, height: 1.6),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📋 Anytime: This is an admin/routine task',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              'You can do this whenever. Best during your afternoon slump (2-5pm) to fill low-energy time productively.',
              style: TextStyle(fontSize: 11, height: 1.6),
            ),
          ],
        ),
      );
    }
  }

  String _getEnergyLabel(int level) {
    if (level >= 9) return 'Peak';
    if (level >= 7) return 'High';
    if (level >= 5) return 'Medium';
    if (level >= 3) return 'Low';
    return 'Minimal';
  }
}
