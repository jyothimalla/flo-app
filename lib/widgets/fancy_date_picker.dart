import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

Future<DateTime?> showFancyDatePicker(
  BuildContext context, {
  DateTime? initial,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _FancyDatePickerBody(initial: initial ?? DateTime.now()),
  );
}

class _FancyDatePickerBody extends StatefulWidget {
  
  final DateTime initial;
  const _FancyDatePickerBody({required this.initial});

  @override
  State<_FancyDatePickerBody> createState() => _FancyDatePickerBodyState();
}

class _FancyDatePickerBodyState extends State<_FancyDatePickerBody> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  // brand-ish pastel palette
  static const Color lilac = Color(0xFFE9E6FF);
  static const Color violet = Color(0xFF7A6FF0);
  static const Color pink = Color(0xFFFF4D8D);
  static const Color mint = Color(0xFFE6F6EA);

  @override
  void initState() {
    super.initState();
    _focusedDay = _strip(widget.initial);
    _selectedDay = _strip(widget.initial);
  }

  DateTime _strip(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(width: 42, height: 4, decoration: BoxDecoration(
            color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2),
          )),
          const SizedBox(height: 12),

          // title row
          Row(
            children: [
              const Text('Pick a date',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              )
            ],
          ),

          // quick chips
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              _chip('Today', onTap: () {
                setState(() {
                  _focusedDay = _strip(DateTime.now());
                  _selectedDay = _focusedDay;
                });
              }),
              _chip('–1 day', onTap: () {
                setState(() {
                  _selectedDay = _focusedDay = _strip(DateTime.now().subtract(const Duration(days: 1)));
                });
              }),
              _chip('–7 days', onTap: () {
                setState(() {
                  _selectedDay = _focusedDay = _strip(DateTime.now().subtract(const Duration(days: 7)));
                });
              }),
            ],
          ),
          const SizedBox(height: 8),

          // calendar
          TableCalendar(
            firstDay: DateTime(2000, 1, 1),
            lastDay: DateTime(2100, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (d) => _strip(d) == _selectedDay,
            onDaySelected: (sel, foc) {
              setState(() {
                _selectedDay = _strip(sel);
                _focusedDay = _strip(foc);
              });
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: mint, borderRadius: BorderRadius.circular(10),
              ),
              selectedDecoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [violet, pink], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(10),
              ),
              defaultDecoration: BoxDecoration(
                color: lilac.withOpacity(.35), borderRadius: BorderRadius.circular(10),
              ),
              weekendDecoration: BoxDecoration(
                color: lilac.withOpacity(.5), borderRadius: BorderRadius.circular(10),
              ),
              outsideDaysVisible: false,
              cellMargin: const EdgeInsets.all(4),
              selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
            ),
          ),

          const SizedBox(height: 12),

          // action
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _selectedDay),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const StadiumBorder(),
                foregroundColor: Colors.white,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              child: Ink(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [violet, pink],
                    begin: Alignment.centerLeft, end: Alignment.centerRight),
                  borderRadius: BorderRadius.all(Radius.circular(26)),
                ),
                child: const Center(
                  child: Text('Use date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: lilac, borderRadius: BorderRadius.circular(18),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
