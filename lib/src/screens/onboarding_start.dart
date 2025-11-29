import 'package:flutter/material.dart';
import 'onboarding_wizard.dart';

class OnboardingStartScreen extends StatelessWidget {
  const OnboardingStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Insets = MediaQuery.paddingOf(context); // handle notch
    return Scaffold(
      backgroundColor: const Color(0xFFF6EFF7), // soft lilac bg
      body: Stack(
        children: [
          // optional status icons
          Positioned(
            left: 16, top: Insets.top + 6,
            child: const Icon(Icons.settings_outlined, color: Colors.black54),
          ),
          Positioned(
            right: 16, top: Insets.top + 6,
            child: const Icon(Icons.notifications_none_outlined, color: Colors.black54),
          ),

          // Bottom card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 20, 20, Insets.bottom + 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Illustration – fixed height, no crop
                  SizedBox(
                    height: 220, // <- adjust if you want taller
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.asset('assets/illustrations/onboarding.png'),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // "Let's start" — dual-violet gradient
                  _GradientButton(
                    title: "Let's start",
                    subtitle: "I'm a new member",
                    colors: const [Color(0xFF6D28D9), Color(0xFF9333EA)], // deep -> bright violet
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const OnboardingWizard()),
                      );
                    },
                  ),
                  const SizedBox(height: 14),

                  // "Restore my data" — dark pink (solid)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4D8D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const OnboardingWizard()),
                        );
                      },
                      child: const Text('Restore my data'),
                    ),
                  ),
                  // No “Partner mode” for now
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable gradient-filled rounded button that supports a title + subtitle.
class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.title,
    this.subtitle,
    required this.colors,
    required this.onTap,
  });

  final String title;
  final String? subtitle;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: onTap,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      )),
                  if (subtitle != null)
                    const SizedBox(height: 2),
                  if (subtitle != null)
                    Text(subtitle!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
