import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/models.dart';
import '../../data/prediction.dart';
import '../../main.dart';


class CalendarPage extends ConsumerWidget {
const CalendarPage({super.key});


@override
Widget build(BuildContext context, WidgetRef ref) {
final state = ref.watch(appStateProvider);
final predictor = CyclePredictor(state);
final ovulation = predictor.estimateOvulationDay();
final fertile = predictor.fertileWindowDays().map((d) => d.toIso8601String()).toSet();


final today = DateTime.now();
final startOfMonth = DateTime(today.year, today.month, 1);
final daysInMonth = DateUtils.getDaysInMonth(today.year, today.month);


return SafeArea(
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text('Your cycle', style: Theme.of(context).textTheme.headlineMedium),
const SizedBox(height: 8),
if (ovulation != null) Text('Est. ovulation: ${ovulation.toLocal().toString().split(' ').first}'),
const SizedBox(height: 16),
Expanded(
child: GridView.builder(
gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 6, crossAxisSpacing: 6),
itemCount: daysInMonth,
itemBuilder: (_, i) {
final date = startOfMonth.add(Duration(days: i));
final isPeriod = state.periods.any((p) {
final end = p.end ?? p.start;
return !date.isBefore(p.start) && !date.isAfter(end);
});
final isFertile = fertile.contains(date.toIso8601String());
final isOvulation = ovulation?.year == date.year && ovulation?.month == date.month && ovulation?.day == date.day;
return DecoratedBox(
decoration: BoxDecoration(
color: isOvulation
? Colors.orange.withOpacity(0.25)
: isFertile
? Colors.green.withOpacity(0.18)
: isPeriod
? Colors.pink.withOpacity(0.22)
: Colors.transparent,
borderRadius: BorderRadius.circular(10),
border: Border.all(color: Colors.black12),
),
child: Center(child: Text('${i + 1}')),
);
},
),
),
],
),
),
);
}
}