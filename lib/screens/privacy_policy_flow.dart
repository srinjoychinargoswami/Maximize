import 'package:flutter/material.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';
import '../services/onboarding_service.dart';
import 'auth_check_wrapper.dart';

class PrivacyPolicyFlow extends StatefulWidget {
  final VoidCallback onAccepted;

  const PrivacyPolicyFlow({
    Key? key,
    required this.onAccepted,
  }) : super(key: key);

  @override
  State<PrivacyPolicyFlow> createState() => _PrivacyPolicyFlowState();
}

class _PrivacyPolicyFlowState extends State<PrivacyPolicyFlow> {
  bool _privacyAccepted = false;

  void _handlePrivacyResponse(bool accepted) {
    if (accepted) {
      setState(() => _privacyAccepted = true);
      _goToTerms();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must accept the Privacy Policy to continue'),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void _goToTerms() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TermsConditionsScreen(
          onAccepted: _handleTermsAccepted,
        ),
      ),
    );
  }

  Future<void> _handleTermsAccepted() async {
    // Mark onboarding as completed
    await OnboardingService.completeOnboarding();

    // Navigate to auth screen (login/signup)
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthCheckWrapper()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PrivacyPolicyScreen(
      onAccepted: _handlePrivacyResponse,
    );
  }
}
