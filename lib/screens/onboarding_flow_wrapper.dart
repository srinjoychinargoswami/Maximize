import 'package:flutter/material.dart';
import '../services/onboarding_service.dart';
import 'onboarding_screen.dart';
import 'auth_check_wrapper.dart';

class OnboardingFlowWrapper extends StatefulWidget {
  const OnboardingFlowWrapper({Key? key}) : super(key: key);

  @override
  State<OnboardingFlowWrapper> createState() => _OnboardingFlowWrapperState();
}

class _OnboardingFlowWrapperState extends State<OnboardingFlowWrapper> {
  late Future<bool> _onboardingFuture;

  @override
  void initState() {
    super.initState();
    _onboardingFuture = OnboardingService.hasCompletedOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _onboardingFuture,
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Onboarding NOT completed → show it
        if (snapshot.data == false) {
          return OnboardingScreen(
            onComplete: () {
              // Flow continues to privacy/terms, which will mark as complete
              // and navigate to auth screen
            },
          );
        }

        // Onboarding completed → show auth flow
        return const AuthCheckWrapper();
      },
    );
  }
}
