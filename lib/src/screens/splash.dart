// lib/src/screens/splash.dart
import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import 'onboarding_start.dart';
import 'shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final bool onboarded = await AppState.hasOnboarded();

    if (!mounted) return;

    if (!onboarded) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingStartScreen()),
      );
      return;
    }

    final AppState state = await AppState.fromPrefs();
    if (!mounted) return;

    Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => Shell(initial: state)),
);

  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
