import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../src/states/auth_state.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Flo — Login')),
      body: Center(
        child: isLoggedIn
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Already logged in'),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/home'),
                    child: const Text('Go to Home'),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: () {
                  ref.read(authProvider.notifier).state = true;
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: const Text('Sign in (demo)'),
              ),
      ),
    );
  }
}
