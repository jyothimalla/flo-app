import 'package:flutter/material.dart';
import 'src/screens/onboarding_start.dart'; // <-- your gradient buttons screen

void main() => runApp(const FloApp());

class FloApp extends StatelessWidget {
  const FloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const OnboardingStartScreen(), // <-- start here
    );
  }
}
