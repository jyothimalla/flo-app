import 'package:intl/intl.dart';

enum FlowIntensity { light, medium, heavy }
enum SymptomType { cramps, mood, bloating, headache, acne, ovulationPain, other }

class PeriodLog {
  final DateTime start; // inclusive
  final DateTime? end;  // inclusive; null if ongoing
  final List<FlowIntensity> dailyFlow;
  PeriodLog({required this.start, this.end, this.dailyFlow = const []});

  int get lengthDays =>
      ((end ?? start).difference(start).inDays + 1).clamp(1, 60);
}

class SymptomEntry {
  final DateTime date;
  final SymptomType type;
  final String? note;
  SymptomEntry({required this.date, required this.type, this.note});
}

class OvulationTest {
  final DateTime date;
  final bool positive;
  OvulationTest({required this.date, required this.positive});
}

class CycleParams {
  final int defaultCycleLength; // e.g., 28
  final int lutealPhaseDays;    // e.g., 14
  final int smoothingWindow;    // e.g., last 3 cycles
  const CycleParams({
    this.defaultCycleLength = 28,
    this.lutealPhaseDays = 14,
    this.smoothingWindow = 3,
  });
}

class UserProfile {
  final DateTime createdAt;
  final CycleParams params;
  const UserProfile({required this.createdAt, this.params = const CycleParams()});
}

class AppStateSnapshot {
  final UserProfile profile;
  final List<PeriodLog> periods;
  final List<SymptomEntry> symptoms;
  final List<OvulationTest> tests;

  const AppStateSnapshot({
    required this.profile,
    this.periods = const [],
    this.symptoms = const [],
    this.tests = const [],
  });
}

extension DateX on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);
  String get yMd => DateFormat.yMMMd().format(this);
}
