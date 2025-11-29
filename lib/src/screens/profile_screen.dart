import 'package:flutter/material.dart';
import '../../services/local_auth.dart';
import 'splash.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(colors: <Color>[cs.primary, cs.secondary]),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('You', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text('me@example.com',
                      style: TextStyle(color: Color(0x00000080))),
                  Text('Premium Member',
                      style: TextStyle(color: Color(0x00000080))),
                ],
              ),
            ),
            
            OutlinedButton(
              onPressed: () async {
                await LocalAuth.logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const SplashScreen(),
                    ),
                    (_) => false,
                  );
                }
              },
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
