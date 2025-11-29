import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import '../../widgets/card_widgets.dart';

class OnboardResult { final int periodLengthDays; final int cycleLengthDays; final DateTime lastPeriodStart; OnboardResult({required this.periodLengthDays, required this.cycleLengthDays, required this.lastPeriodStart}); }

class OnboardingWizard extends StatefulWidget { const OnboardingWizard({super.key}); @override State<OnboardingWizard> createState() => _OnboardingWizardState(); }
class _OnboardingWizardState extends State<OnboardingWizard> {
  int _step = 0; int _periodLen = 5; int _cycleLen = 28; DateTime _lastStart = stripTime(DateTime.now());
  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Let’s set things up')),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        LinearProgressIndicator(value: (_step + 1) / 3, backgroundColor: cs.primary.withOpacity(.1)),
        const SizedBox(height: 16),
        Expanded(child: _buildStep(context)),
        Row(children: <Widget>[ if (_step > 0) OutlinedButton(onPressed: () => setState(() => _step -= 1), child: const Text('Back')), const Spacer(), FilledButton(onPressed: () { if (_step < 2) { setState(() => _step += 1); } else { Navigator.pop(context, OnboardResult(periodLengthDays: _periodLen, cycleLengthDays: _cycleLen, lastPeriodStart: _lastStart)); } }, child: Text(_step < 2 ? 'Next' : 'Finish')) ])
      ])),
    );
  }

  Widget _buildStep(BuildContext context) {
    switch (_step) {
      case 0:
        return NumberPickerCard(title: 'How many days does your period usually last?', min: 1, max: 14, value: _periodLen, onChanged: (int v) => setState(() => _periodLen = v));
      case 1:
        return NumberPickerCard(title: 'How many days does your cycle usually last?', min: 21, max: 45, value: _cycleLen, onChanged: (int v) => setState(() => _cycleLen = v));
      default:
        return DatePickerCard(title: "What's the start date of your last period?", value: _lastStart, onPick: () async { final DateTime now = DateTime.now(); final DateTime? picked = await showDatePicker(context: context, initialDate: _lastStart, firstDate: DateTime(now.year - 1), lastDate: DateTime(now.year + 1)); if (picked != null) setState(() => _lastStart = stripTime(picked)); });
    }
  }
}

class NumberPickerCard extends StatelessWidget {
  final String title; final int min; final int max; final int value; final ValueChanged<int> onChanged; const NumberPickerCard({super.key, required this.title, required this.min, required this.max, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final List<int> items = List<int>.generate(max - min + 1, (int i) => min + i);
    final FixedExtentScrollController controller = FixedExtentScrollController(initialItem: value - min);
    return CardBox(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      CardTitle(title), const SizedBox(height: 12),
      SizedBox(height: 160, child: Row(children: <Widget>[
        Expanded(child: CupertinoPicker(scrollController: controller, backgroundColor: Colors.transparent, itemExtent: 40, onSelectedItemChanged: (int i) => onChanged(items[i]), children: <Widget>[for (final int n in items) Center(child: Text('$n'))])),
        const SizedBox(width: 8), const Text('days', style: TextStyle(color: Color(0xFF6B7280))),
      ])),
    ]));
  }
}

class DatePickerCard extends StatelessWidget { final String title; final DateTime value; final VoidCallback onPick; const DatePickerCard({super.key, required this.title, required this.value, required this.onPick}); @override Widget build(BuildContext context) { return CardBox(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[ CardTitle(title), const SizedBox(height: 12), Row(children: <Widget>[ Expanded(child: Text(iso(value), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))), OutlinedButton.icon(onPressed: onPick, icon: const Icon(Icons.calendar_month_outlined), label: const Text('Pick date')), ]) ])); }
}