import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import '../../widgets/card_widgets.dart'; // CardBox, CardTitle, etc.


typedef StartPeriod       = void Function(DateTime start);
typedef EndPeriodWithMood = void Function(DateTime end, MoodKind? mood);
typedef ToggleMood        = void Function(DateTime day, MoodKind mood);


class HomeScreen extends StatelessWidget {
  final AppState state;
  final void Function(DateTime) onStartPeriod;
  final Future<void> Function(DateTime) onEndPeriodWithMood;
  final VoidCallback onScheduleReminder;
  final void Function(DateTime, MoodKind) onToggleMood;
  final void Function(DateTime, DateTime) onAddPastPeriod; // NEW

  const HomeScreen({
    super.key,
    required this.state,
    required this.onStartPeriod,
    required this.onEndPeriodWithMood,
    required this.onScheduleReminder,
    required this.onToggleMood,
    required this.onAddPastPeriod, // NEW
  });

  Future<DateTime?> _pickDate(BuildContext context, {DateTime? initial}) {
    final DateTime now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
  }

  // dialog that supports ongoing or past (start+end)
  Future<void> _showAddPeriodDialog(BuildContext context) async {
    final DateTime today = stripTime(DateTime.now());
    DateTime? start = today;
    DateTime? end = today;
    bool ongoing = true;

    await showDialog(
      context: context,
      builder: (BuildContext ctx) => StatefulBuilder(
        builder: (BuildContext ctx, setLocal) => AlertDialog(
          title: const Text('Add period'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(children: <Widget>[
                const Text('Start:'), const SizedBox(width: 8),
                Text(iso(start!)), const Spacer(),
                OutlinedButton(
                  onPressed: () async {
                    final DateTime? d = await _pickDate(context, initial: start);
                    if (d != null) {
                      start = stripTime(d);
                      final bool isRecent = !today.isAfter(d.add(const Duration(days: 1)));
                      ongoing = isRecent;
                      setLocal(() {});
                    }
                  },
                  child: const Text('Pick'),
                ),
              ]),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Still ongoing (no end date yet)'),
                value: ongoing,
                onChanged: (bool v) => setLocal(() => ongoing = v),
              ),
              if (!ongoing) ...<Widget>[
                Row(children: <Widget>[
                  const Text('End:'), const SizedBox(width: 8),
                  Text(iso(end!)), const Spacer(),
                  OutlinedButton(
                    onPressed: () async {
                      final DateTime? d = await _pickDate(context, initial: end);
                      if (d != null) { end = stripTime(d); setLocal(() {}); }
                    },
                    child: const Text('Pick'),
                  ),
                ]),
                const SizedBox(height: 6),
                const Text('End date must be on/after start date.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ],
          ),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (ongoing) {
                  onStartPeriod(start!);
                } else {
                  if (end!.isBefore(start!)) return;
                  onAddPastPeriod(start!, end!);
                }
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime? prNext = state.cycles.isEmpty ? null : state.cycles.last.start.add(
      Duration(days: estimateCycleLengthDays(state.cycles)),
    );

    final Cycle? last = state.cycles.isEmpty ? null : state.cycles.last;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        // Header card
        CardBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                prNext == null
                    ? 'Welcome'
                    : '${DateTime.now().difference(prNext).inDays.abs()} DAYS '
                      '${DateTime.now().isBefore(prNext) ? 'LEFT' : 'AGO'}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                prNext == null ? '' : '${_formatMonthDay(prNext)} - Next Period',
                style: const TextStyle(color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 12),
              Center(
                child: FilledButton(
                  onPressed: () => onStartPeriod(stripTime(DateTime.now())),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Period Starts'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Cycle phase blocks
        CardBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const CardTitle('Cycle phase'),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  _phaseBlock(
                    color: const Color(0xFFFFF3AF), // lime yellow
                    icon: Icons.local_florist,
                    title: 'Period',
                    date: last?.start,
                  ),
                  const SizedBox(width: 12),
                  _phaseBlock(
                    color: const Color(0xFFDFF5E7), // light green
                    icon: Icons.blur_circular,
                    title: 'Ovulation',
                    date: (last == null)
                        ? null
                        : last.start.add(const Duration(days: 14)),
                  ),
                  const SizedBox(width: 12),
                  _phaseBlock(
                    color: const Color(0xFFE9E6FF), // light violet
                    icon: Icons.calendar_month,
                    title: 'Next Period',
                    date: prNext,
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Period tracking actions
        CardBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const CardTitle('Period tracking'),
              const SizedBox(height: 8),
              if (last == null || last.end != null) ...<Widget>[
                const Text('Start a new period or add a past one.'),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: <Widget>[
                  FilledButton(
                    onPressed: () => onStartPeriod(stripTime(DateTime.now())),
                    child: const Text('Start period today'),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final DateTime? d = await _pickDate(context);
                      if (d != null) onStartPeriod(d);
                    },
                    child: const Text('Pick start date'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _showAddPeriodDialog(context),
                    icon: const Icon(Icons.history),
                    label: const Text('Add past period'),
                  ),
                ]),
              ] else ...<Widget>[
                Text('Period in progress from ${iso(last.start)}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(children: <Widget>[
                  OutlinedButton.icon(
                    onPressed: () async {
                      final DateTime? d = await _pickDate(context, initial: DateTime.now());
                      if (d != null) await onEndPeriodWithMood(d);
                    },
                    icon: const Icon(Icons.flag_outlined),
                    label: const Text('End period'),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Day ${DateTime.now().difference(last.start).inDays + 1}',
                    ),
                  ),
                ]),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _phaseBlock({
    required Color color,
    required IconData icon,
    required String title,
    required DateTime? date,
  }) {
    return Expanded(
      child: Container(
        height: 90,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(children: <Widget>[
                Icon(icon, size: 18, color: Colors.black54),
                const SizedBox(width: 6),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              ]),
            ),
            Text(
              date == null ? '—' : _formatMonthDay(date),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMonthDay(DateTime d) {
    const List<String> months = <String>[
      'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${months[d.month - 1]} ${d.day}';
  }
}
