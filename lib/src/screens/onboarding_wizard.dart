import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import 'shell.dart';

// If you don't already have stripTime() anywhere, uncomment this:
// DateTime stripTime(DateTime d) => DateTime(d.year, d.month, d.day);

class OnboardingWizard extends StatefulWidget {
  const OnboardingWizard({super.key});
  @override
  State<OnboardingWizard> createState() => _OnboardingWizardState();
}

class _OnboardingWizardState extends State<OnboardingWizard> {
  int step = 0;                // 0..2
  int? periodLen;              // days
  int? cycleLen;               // days
  DateTime startDate = DateTime.now();

  final List<int> periodRange = List<int>.generate(10, (i) => i + 3);   // 3..12
  final List<int> cycleRange  = List<int>.generate(21, (i) => i + 21);  // 21..41

  @override
  void initState() {
    super.initState();
    periodLen = 4; // default highlight
    cycleLen  = 28;
    startDate = DateTime.now();
  }

  void _next() {
    if (step < 2) {
      setState(() => step += 1);
      return;
    }
    // Finish – save to AppState and go to app
    AppState.persistOnboarding(
      typicalPeriodLengthDays: periodLen,
      typicalCycleLengthDays: cycleLen,
      lastPeriodStart: stripTime(startDate),
    );
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const Shell()),
      (_) => false,
    );
  }

  void _markUnsure() {
    setState(() {
      if (step == 0) periodLen = null;
      if (step == 1) cycleLen = null;
    });
    _next();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      _NumberStep(
        index: 1, total: 3,
        title: 'How many days does your period usually last?',
        subtitle: 'Bleeding usually lasts between 4–7 days.',
        value: periodLen ?? 4,
        values: periodRange,
        unit: 'Days',
        onChanged: (v) => setState(() => periodLen = v),
        onNext: _next,
        onUnsure: _markUnsure,
      ),
      _NumberStep(
        index: 2, total: 3,
        title: 'How many days does your cycle usually last?',
        subtitle: 'The duration between two period start dates, usually 23–35 days.',
        value: cycleLen ?? 28,
        values: cycleRange,
        unit: 'Days',
        onChanged: (v) => setState(() => cycleLen = v),
        onNext: _next,
        onUnsure: _markUnsure,
      ),
      _DateStep(
        index: 3, total: 3,
        title: "What's the start date of your last period?",
        date: startDate,
        onChanged: (d) => setState(() => startDate = d),
        onDone: _next,
      ),
    ];

    return Dialog.fullscreen(
      child: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: pages[step],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final int index, total;
  final String title;
  final String? subtitle;
  final VoidCallback? onClose;

  const _Header({
    required this.index,
    required this.total,
    required this.title,
    this.subtitle,
    this.onClose, // <-- important: initialize the final field
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '$index/$total',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            IconButton(
              onPressed: onClose ?? () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              if (subtitle != null) ...<Widget>[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}


class _NumberStep extends StatelessWidget {
  final int index, total, value;
  final List<int> values;
  final String title, unit;
  final String? subtitle;
  final ValueChanged<int> onChanged;
  final VoidCallback onNext, onUnsure;

  const _NumberStep({
    required this.index,
    required this.total,
    required this.title,
    required this.value,
    required this.values,
    required this.unit,
    required this.onChanged,
    required this.onNext,
    required this.onUnsure,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final controller = FixedExtentScrollController(
      initialItem: values.indexOf(value),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        children: <Widget>[
          _Header(index: index, total: total, title: title, subtitle: subtitle),
          const Spacer(),
          SizedBox(
            height: 180,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CupertinoPicker(
                    scrollController: controller,
                    itemExtent: 40,
                    onSelectedItemChanged: (i) => onChanged(values[i]),
                    children: <Widget>[
                      for (final v in values)
                        Center(
                          child: Text('$v',
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(unit, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4D8D),
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              minimumSize: const Size.fromHeight(52),
            ),
            child: const Text('Next', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: onUnsure, child: const Text("I'm not sure")),
        ],
      ),
    );
  }
}

class _DateStep extends StatelessWidget {
  final int index, total;
  final String title;
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  final VoidCallback onDone;

  const _DateStep({
    required this.index,
    required this.total,
    required this.title,
    required this.date,
    required this.onChanged,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        children: <Widget>[
          _Header(index: index, total: total, title: title),
          const Spacer(),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: date,
              minimumDate: DateTime(2000, 1, 1),
              maximumDate: DateTime(2100, 12, 31),
              onDateTimeChanged: onChanged,
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: onDone,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4D8D),
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              minimumSize: const Size.fromHeight(52),
            ),
            child: const Text('Done', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: onDone, child: const Text("I'm not sure")),
        ],
      ),
    );
  }
}
