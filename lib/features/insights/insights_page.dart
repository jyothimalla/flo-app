import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/prediction.dart';
import '../../main.dart';


class InsightsPage extends ConsumerWidget {
const InsightsPage({super.key});


@override
Widget build(BuildContext context, WidgetRef ref) {
final state = ref.watch(appStateProvider);
final predictor = CyclePredictor(state);
final next = predictor.predictNextPeriodStart();
final fert = predictor.fertileWindowDays();


return Scaffold(
appBar: AppBar(title: const Text('Insights')),
body: ListView(
padding: const EdgeInsets.all(16),
children: [
Card(
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
const Text('Upcoming', style: TextStyle(fontWeight: FontWeight.bold)),
const SizedBox(height: 8),
Text(next != null ? 'Next period: ${next.toLocal().toString().split(' ').first}' : 'Log a few cycles to get predictions.'),
const SizedBox(height: 8),
if (fert.isNotEmpty) Text('Fertile window: ${fert.first.toLocal().toString().split(' ').first} — ${fert.last.toLocal().toString().split(' ').first}')
]),
),
),
],
),
);
}
}