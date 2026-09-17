import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kinetic/database/app_database.dart';
import 'package:kinetic/services/energy_service.dart';
import 'package:kinetic/models/energy_model.dart';
import 'package:uuid/uuid.dart';
import 'privacy_policy_flow.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

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
          _buildStep1_TrackingExplanation(),
          _buildStep2_Features(),
        ],
      ),
    );
  }

  // ===== STEP 0: Welcome =====
  Widget _buildStep0_Welcome() {
    return _buildOnboardingContainer(
      step: 0,
      totalSteps: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.electric_bolt, size: 80, color: Colors.blue),
          const SizedBox(height: 32),
          const Text(
            'Welcome to Kinetic',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Your Energy Operating System',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          const Text(
            'Most apps force you into rigid schedules. Kinetic is different.\n\n'
            'We\'ll learn WHEN you do your best work, then help you schedule tasks wisely.',
            style: TextStyle(fontSize: 16, height: 1.6, color: Colors.white),
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

  // ===== STEP 1: Tracking Explanation =====
  Widget _buildStep1_TrackingExplanation() {
    return _buildOnboardingContainer(
      step: 1,
      totalSteps: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bar_chart, size: 80, color: Colors.blue),
          const SizedBox(height: 32),
          const Text(
            'Let\'s Learn Your Pattern',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📊 Next, we\'ll track your energy',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text(
                  'This takes 30 seconds per day:\n'
                  '• Rate your energy (1-10 scale)\n'
                  '• Note your mood\n'
                  '• Optional: where were you, how you felt',
                  style: TextStyle(fontSize: 14, height: 1.6, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Your peak isn\'t the same as everyone else\'s.\n\n'
            'Most apps guess. Kinetic learns.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
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

  // ===== STEP 2: App Features =====
  Widget _buildStep2_Features() {
    return _buildOnboardingContainer(
      step: 2,
      totalSteps: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.apps, size: 80, color: Colors.blue),
          const SizedBox(height: 32),
          const Text(
            'Powerful Features',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildFeatureItem('📊', 'Energy Tracking', 'Log and track your energy levels throughout the day'),
                  _buildFeatureItem('📅', 'Smart Scheduling', 'Schedule tasks based on your peak energy windows'),
                  _buildFeatureItem('📝', 'Task Management', 'Organize tasks, notes, reminders, and events'),
                  _buildFeatureItem('📈', 'Analytics & Insights', 'Understand your productivity patterns with detailed analytics'),
                  _buildFeatureItem('🔄', 'Sync Across Devices', 'Keep your data synchronized across all your devices'),
                  _buildFeatureItem('🔒', 'Data Transfer', 'Export your data or transfer it to other apps in Settings after you sign up'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _proceedToPrivacy(),
              child: const Text('Continue to Privacy Policy'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
            const Color(0xFF1a1a2e),
            const Color(0xFF16213e),
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
                    color: Colors.white70,
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
                  backgroundColor: Colors.white12,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
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

  void _proceedToPrivacy() async {
    // Log the initial energy entry first
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

    // Navigate to privacy flow
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PrivacyPolicyFlow(
            onAccepted: widget.onComplete,
          ),
        ),
      );
    }
  }
}
