import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../main.dart';


class LogPeriodPage extends ConsumerStatefulWidget {
const LogPeriodPage({super.key});
@override
ConsumerState<LogPeriodPage> createState() => _LogPeriodPageState();
}


class _LogPeriodPageState extends ConsumerState<LogPeriodPage> {
DateTime? start;
DateTime? end;
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Log period')),
body: Padding(
padding: const EdgeInsets.all(16),
child: Column(children: [
ListTile(
title: const Text('Start date'),
subtitle: Text(start?.toLocal().toString().split(' ').first ?? 'Select'),
onTap: () async {
final now = DateTime.now();
final picked = await showDatePicker(context: context, firstDate: DateTime(now.year - 2), lastDate: DateTime(now.year + 1), initialDate: start ?? now);
if (picked != null) setState(() => start = picked);
},
),
ListTile(
title: const Text('End date'),
subtitle: Text(end?.toLocal().toString().split(' ').first ?? 'Select (optional)'),
onTap: () async {
final now = DateTime.now();
final picked = await showDatePicker(context: context, firstDate: DateTime(now.year - 2), lastDate: DateTime(now.year + 1), initialDate: end ?? start ?? now);
if (picked != null) setState(() => end = picked);
},
),
const Spacer(),
FilledButton.icon(
onPressed: start == null
? null
: () {
ref.read(appStateProvider.notifier).logPeriodStart(start!);
if (end != null) {
ref.read(appStateProvider.notifier).logPeriodEnd(start!, end!);
}
Navigator.pop(context);
},
icon: const Icon(Icons.save),
label: const Text('Save'),
)
]),
),
);
}
}