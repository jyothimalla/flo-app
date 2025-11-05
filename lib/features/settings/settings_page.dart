import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/models.dart';
import '../../main.dart';


class SettingsPage extends ConsumerWidget {
const SettingsPage({super.key});


@override
Widget build(BuildContext context, WidgetRef ref) {
final profile = ref.watch(appStateProvider).profile;
return Scaffold(
appBar: AppBar(title: const Text('Settings')),
body: ListView(padding: const EdgeInsets.all(16), children: [
ListTile(title: const Text('Default cycle length'), subtitle: Text('${profile.params.defaultCycleLength} days')),
ListTile(title: const Text('Luteal phase'), subtitle: Text('${profile.params.lutealPhaseDays} days')),
const Divider(),
const Text('Privacy', style: TextStyle(fontWeight: FontWeight.bold)),
const SizedBox(height: 8),
const Text('Data is stored locally on your device. You can export/delete anytime (to implement).'),
]),
);
}
}