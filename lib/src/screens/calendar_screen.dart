import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/app_state.dart';

class CalendarScreen extends StatefulWidget {
  final AppState state;
  const CalendarScreen({super.key, required this.state});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focused = stripTime(DateTime.now());
  DateTime _selected = stripTime(DateTime.now());

  // brand palette aligned with your cards
  static const Color cardBg = Color(0xFFF6EEF7);     // page bg
  static const Color lilac  = Color(0xFFE9E6FF);     // neutral cell
  static const Color violet = Color(0xFF7A6FF0);     // accent
  static const Color pink   = Color(0xFFFF4D8D);     // accent 2
  static const Color blue   = Color(0xFFDDEBFF);     // predicted period range
  static const Color green  = Color(0xFFE9F7ED);     // fertile window

  @override
  Widget build(BuildContext context) {
    final Prediction? pr = predict(widget.state);
    final int periodLen =
        estimatePeriodLengthDays(widget.state.cycles, typical: widget.state.typicalPeriodLengthDays);

    // predicted period range
    final DateTime? pStart = pr?.nextPeriodStart;
    final DateTime? pEnd =
        pStart == null ? null : stripTime(pStart.add(Duration(days: periodLen - 1)));

    // fertile window (ovulation -5 .. -1), and ovulation day
    final DateTime? ovu = pr?.ovulation;
    final DateTime? fStart =
        ovu == null ? null : stripTime(ovu.subtract(const Duration(days: 5)));
    final DateTime? fEnd =
        ovu == null ? null : stripTime(ovu.subtract(const Duration(days: 1)));

    bool isWithin(DateTime d, DateTime a, DateTime b) =>
        !d.isBefore(a) && !d.isAfter(b);

    return Scaffold(
      backgroundColor: cardBg,
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: cardBg,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime(2000, 1, 1),
              lastDay: DateTime(2100, 12, 31),
              focusedDay: _focused,
              selectedDayPredicate: (d) => stripTime(d) == _selected,
              onDaySelected: (sel, foc) {
                setState(() {
                  _selected = stripTime(sel);
                  _focused  = stripTime(foc);
                });
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                cellMargin: const EdgeInsets.all(4),
                defaultDecoration: BoxDecoration(
                  color: lilac.withOpacity(.35),
                  borderRadius: BorderRadius.circular(10),
                ),
                weekendDecoration: BoxDecoration(
                  color: lilac.withOpacity(.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                todayDecoration: BoxDecoration(
                  border: Border.all(color: violet, width: 1.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                selectedDecoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [violet, pink],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w800),
              ),

              // Paint backgrounds for fertile + predicted period ranges
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final DateTime d = stripTime(day);
                  Color? bg;

                  // predicted period (soft blue)
                  if (pStart != null && pEnd != null && isWithin(d, pStart, pEnd)) {
                    bg = blue;
                  }
                  // fertile window (mint/green)
                  if (fStart != null && fEnd != null && isWithin(d, fStart, fEnd)) {
                    bg = green;
                  }

                  return _buildCell(d,
                      background: bg ?? lilac.withOpacity(.35),
                      overlay: _overlayForDay(d, ovu, fStart, fEnd));
                },
                todayBuilder: (context, day, focusedDay) {
                  final DateTime d = stripTime(day);
                  return _buildCell(d,
                      outline: violet,
                      overlay: _overlayForDay(d, ovu, fStart, fEnd));
                },
                selectedBuilder: (context, day, focusedDay) {
                  final DateTime d = stripTime(day);
                  return _buildCell(d,
                      gradient: const LinearGradient(
                        colors: [violet, pink],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      textColor: Colors.white,
                      overlay: _overlayForDay(d, ovu, fStart, fEnd));
                },
                outsideBuilder: (context, day, focusedDay) {
                  final DateTime d = stripTime(day);
                  return _buildCell(d,
                      background: lilac.withOpacity(.15),
                      textStyle: const TextStyle(color: Colors.grey),
                      overlay: _overlayForDay(d, ovu, fStart, fEnd));
                },
              ),
            ),

            const SizedBox(height: 12),

            // Small legend
            Row(
              children: const [
                _LegendSwatch(color: blue, label: 'Predicted period'),
                SizedBox(width: 12),
                _LegendSwatch(color: green, label: 'Fertile window'),
                SizedBox(width: 12),
                _LegendDot(color: violet, label: 'Ovulation'),
              ],
            ),

            const SizedBox(height: 16),

            // Selected day info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formatMonthDay(_selected),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(_chanceText(_selected, ovu, fStart, fEnd),
                      style: const TextStyle(color: Color(0xFF6B7280))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Compose a single calendar cell with optional gradient/background/outline and tiny overlays.
  Widget _buildCell(
    DateTime day, {
    LinearGradient? gradient,
    Color? background,
    Color? outline,
    Color textColor = const Color(0xFF111827),
    TextStyle? textStyle,
    Widget? overlay,
  }) {
    final BoxDecoration deco = BoxDecoration(
      gradient: gradient,
      color: gradient == null ? background : null,
      borderRadius: BorderRadius.circular(10),
      border: outline == null ? null : Border.all(color: outline, width: 1.2),
    );

    return Container(
      decoration: deco,
      child: Stack(
        children: [
          Center(
            child: Text('${day.day}',
                style: textStyle ??
                    TextStyle(fontWeight: FontWeight.w600, color: textColor)),
          ),
          if (overlay != null)
            Positioned(right: 6, bottom: 6, child: overlay),
        ],
      ),
    );
  }

  /// Returns a small overlay widget for cells: 🌱 leaf for fertile, • dot for ovulation.
  Widget? _overlayForDay(
    DateTime d,
    DateTime? ovulation,
    DateTime? fStart,
    DateTime? fEnd,
  ) {
    if (ovulation != null && iso(d) == iso(ovulation)) {
      // small violet dot for ovulation
      return Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: violet, shape: BoxShape.circle,
        ),
      );
    }
    if (fStart != null && fEnd != null && !d.isBefore(fStart) && !d.isAfter(fEnd)) {
      // a tiny 🌱 leaf (emoji) so no asset needed
      return const Text('🌱', style: TextStyle(fontSize: 12));
    }
    return null;
  }

  String _chanceText(
    DateTime d,
    DateTime? ovulation,
    DateTime? fStart,
    DateTime? fEnd,
  ) {
    if (ovulation != null && iso(d) == iso(ovulation)) {
      return 'HIGH — Ovulation';
    }
    if (fStart != null && fEnd != null && !d.isBefore(fStart) && !d.isAfter(fEnd)) {
      return 'HIGH — Chance of getting pregnant';
    }
    return 'LOW — Not in fertile window';
  }
}

class _LegendSwatch extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendSwatch({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 16, height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 12)),
    ]);
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 8, height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 12)),
    ]);
  }
}
