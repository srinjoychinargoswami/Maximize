import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kinetic/database/app_database.dart';
import 'package:kinetic/services/energy_service.dart';
import 'package:kinetic/models/energy_model.dart';
import 'package:uuid/uuid.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  int _energyLevel = 5;
  TimeOfDay? _peakStartTime;
  TimeOfDay? _peakEndTime;
  String _userName = '';

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() => _currentStep = index);
        },
        children: [
          _buildStep0_Welcome(),
          _buildStep1_PeakWindow(),
          _buildStep2_TrackingExplanation(),
          _buildStep3_LogEnergy(),
          _buildStep4_EnergyPattern(),
          _buildStep5_FirstTask(),
          _buildStep6_Complete(),
        ],
      ),
    );
  }

  // ===== STEP 0: Welcome =====
  Widget _buildStep0_Welcome() {
    return _buildOnboardingContainer(
      step: 0,
      totalSteps: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.electric_bolt, size: 80, color: Colors.amber),
          const SizedBox(height: 32),
          const Text(
            'Welcome to Kinetic',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Your Energy Operating System',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          const Text(
            'Most apps force you into rigid schedules. Kinetic is different.\n\n'
            'We\'ll learn WHEN you do your best work, then help you schedule tasks during your peak energy.',
            style: TextStyle(fontSize: 16, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _nextStep(),
              child: const Text('Let\'s Begin'),
            ),
          ),
        ],
      ),
    );
  }

  // ===== STEP 1: Peak Window Discovery =====
  Widget _buildStep1_PeakWindow() {
    return _buildOnboardingContainer(
      step: 1,
      totalSteps: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.trending_up, size: 80, color: Colors.amber),
          const SizedBox(height: 32),
          const Text(
            'When Do You Peak?',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Think about your typical day. When do you have the most energy and focus?',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Start time picker
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Peak starts at:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _peakStartTime ?? const TimeOfDay(hour: 10, minute: 0),
                  );
                  if (time != null) {
                    setState(() => _peakStartTime = time);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_peakStartTime?.format(context) ?? '10:00 AM'),
                      const Icon(Icons.access_time),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // End time picker
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Peak ends at:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _peakEndTime ?? const TimeOfDay(hour: 13, minute: 0),
                  );
                  if (time != null) {
                    setState(() => _peakEndTime = time);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_peakEndTime?.format(context) ?? '1:00 PM'),
                      const Icon(Icons.access_time),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _peakStartTime != null && _peakEndTime != null
                  ? () => _nextStep()
                  : null,
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }

  // ===== STEP 2: Tracking Explanation =====
  Widget _buildStep2_TrackingExplanation() {
    return _buildOnboardingContainer(
      step: 2,
      totalSteps: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bar_chart, size: 80, color: Colors.amber),
          const SizedBox(height: 32),
          const Text(
            'Let\'s Learn Your Pattern',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📊 Next, we\'ll track your energy for 3 days',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                const Text(
                  'This takes 30 seconds per day:\n'
                  '• Rate your energy (1-10 scale)\n'
                  '• Note your mood\n'
                  '• Optional: where were you, how you felt\n\n'
                  'After 3 days, we\'ll show you YOUR actual peak window.',
                  style: TextStyle(fontSize: 14, height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Why? Because your peak isn\'t the same as everyone else\'s.\n\n'
            'Most apps guess. Kinetic learns.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _nextStep(),
              child: const Text('I\'m Ready to Track'),
            ),
          ),
        ],
      ),
    );
  }

  // ===== STEP 3: Log First Energy Entry =====
  Widget _buildStep3_LogEnergy() {
    return _buildOnboardingContainer(
      step: 3,
      totalSteps: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.battery_charging_full, size: 80, color: Colors.amber),
          const SizedBox(height: 32),
          const Text(
            'How\'s Your Energy Right Now?',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Energy slider
          Slider(
            value: _energyLevel.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: '$_energyLevel',
            onChanged: (value) {
              setState(() {
                _energyLevel = value.toInt();
              });
            },
          ),
          const SizedBox(height: 16),
          Text(
            _getEnergyDescription(_energyLevel),
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _nextStep(),
              child: const Text('Log This Energy Level'),
            ),
          ),
        ],
      ),
    );
  }

  // ===== STEP 4: Energy Pattern Insights =====
  Widget _buildStep4_EnergyPattern() {
    return _buildOnboardingContainer(
      step: 4,
      totalSteps: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.insights, size: 80, color: Colors.amber),
          const SizedBox(height: 32),
          const Text(
            'Your Energy Insight',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Based on your input:',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Your peak energy: ',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      TextSpan(
                        text: '${_peakStartTime?.format(context) ?? "10:00 AM"} - ${_peakEndTime?.format(context) ?? "1:00 PM"}',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '💡 Schedule your hardest work during this window. Save admin tasks for when energy dips.',
                  style: TextStyle(fontSize: 14, height: 1.6),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _nextStep(),
              child: const Text('Got It!'),
            ),
          ),
        ],
      ),
    );
  }

  // ===== STEP 5: Add First Task (Optional) =====
  Widget _buildStep5_FirstTask() {
    return _buildOnboardingContainer(
      step: 5,
      totalSteps: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_task, size: 80, color: Colors.amber),
          const SizedBox(height: 32),
          const Text(
            'Add Your First Task (Optional)',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            'You can add a task now or skip and do it later.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            decoration: InputDecoration(
              hintText: 'What do you need to do?',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) => setState(() => _userName = value),
          ),
          const SizedBox(height: 32),
          const Text(
            'Don\'t worry — you can add tasks anytime. Kinetic will suggest when to do them based on your energy.',
            style: TextStyle(fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _nextStep(),
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }

  // ===== STEP 6: Complete Onboarding =====
  Widget _buildStep6_Complete() {
    return _buildOnboardingContainer(
      step: 6,
      totalSteps: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 80, color: Colors.green),
          const SizedBox(height: 32),
          const Text(
            'You\'re Ready!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            'Kinetic is now personalized to YOUR energy rhythm.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '✅ Energy tracking enabled\n'
              '✅ Peak window identified\n'
              '✅ Ready for intelligent task scheduling\n'
              '✅ Sync configured',
              style: TextStyle(fontSize: 14, height: 2.0),
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _completeOnboarding(),
              child: const Text('Start Using Kinetic'),
            ),
          ),
        ],
      ),
    );
  }

  // ===== HELPER WIDGETS =====
  Widget _buildOnboardingContainer({
    required int step,
    required int totalSteps,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.amber.withOpacity(0.05),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Progress indicator
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Step ${step + 1} of $totalSteps',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (step + 1) / totalSteps,
                  minHeight: 4,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                ),
              ),
              const SizedBox(height: 32),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }

  String _getEnergyDescription(int level) {
    if (level >= 8) return '🔥 Peak energy! You\'re at your best.';
    if (level >= 5) return '⚡ Good energy. Ready for solid work.';
    if (level >= 3) return '😴 Low energy. Good for admin tasks.';
    return '😴 Very low. Time to rest.';
  }

  void _nextStep() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _completeOnboarding() async {
    // Log the initial energy entry
    try {
      final energyService = context.read<EnergyService>();
      await energyService.createEnergyEntry(
        energyLevel: _energyLevel,
        moodTags: [],
        privacyContext: 'Onboarding',
        location: 'Home',
        notes: 'Initial energy logged during onboarding',
      );
    } catch (e) {
      debugPrint('Error logging energy entry: $e');
    }

    // Navigate to home
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }
}
