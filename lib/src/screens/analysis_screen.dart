import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import '../../widgets/card_widgets.dart'; // CardBox, CardTitle helpers

class AnalysisScreen extends StatelessWidget {
  final AppState state;
  final void Function(DateTime) onStartPeriod;
  final void Function(DateTime, DateTime) onAddPastPeriod;

  const AnalysisScreen({
    super.key,
    required this.state,
    required this.onStartPeriod,
    required this.onAddPastPeriod,
  });

  // local date picker
  Future<DateTime?> _pickDate(BuildContext context, {DateTime? initial}) {
    final DateTime now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
  }

  Future<void> _showAddPeriodDialog(BuildContext context) async {
    DateTime today = stripTime(DateTime.now());
    DateTime? start = today;
    DateTime? end = today;
    bool ongoing = true; // default to ongoing for today/yesterday

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
                const SizedBox(height: 4),
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
                const Text(
                  'End date must be on/after the start date.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
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
    final int avgCycle  = estimateCycleLengthDays(state.cycles);
    final int avgPeriod = _estimatePeriodLengthDays(state.cycles);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        // My cycles / stats
        CardBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const CardTitle('My cycles'),
              Text(
                '${state.cycles.length} cycles logged',
                style: const TextStyle(color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _StatTile(
                      color: const Color(0xFFFFE1EA),
                      icon: Icons.water_drop,
                      big: '$avgPeriod Days',
                      sub: 'Average period',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      color: const Color(0xFFFFF6D9),
                      icon: Icons.pie_chart,
                      big: '$avgCycle Days',
                      sub: 'Average cycle',
                      iconColor: const Color(0xFFFF8A00),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4D8D),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _showAddPeriodDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Period'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // History (newest first)
        CardBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const CardTitle('History'),
              const SizedBox(height: 8),
              if (state.cycles.isEmpty)
                const Text('No periods yet.')
              else
                ...state.cycles.reversed.map((Cycle c) {
                  final int? bleed = c.end == null ? null : bleedingDays(c);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.calendar_today, size: 16, color: Color(0xFF6B7280)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${iso(c.start)}  –  ${c.end == null ? 'ongoing' : iso(c.end!)}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        if (bleed != null)
                          Text('$bleed d', style: const TextStyle(color: Color(0xFF6B7280))),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String big;
  final String sub;
  final Color? iconColor;

  const _StatTile({
    required this.color,
    required this.icon,
    required this.big,
    required this.sub,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(icon, size: 18, color: iconColor ?? Colors.black54),
          Text(big, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          Text(sub, style: const TextStyle(color: Color(0xFF6B7280))),
        ],
      ),
    );
  }
}

// Average period length (closed cycles only); fallback to 4 days
int _estimatePeriodLengthDays(List<Cycle> cycles) {
  final List<Cycle> closed = cycles.where((Cycle c) => c.end != null).toList();
  if (closed.isEmpty) return 4;
  final int total = closed
      .map((Cycle c) => c.end!.difference(c.start).inDays + 1)
      .fold<int>(0, (int a, int b) => a + b);
  return (total / closed.length).round().clamp(1, 14);
}
