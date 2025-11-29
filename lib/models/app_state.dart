// lib/models/app_state.dart
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ===== Helpers (dates & formatting) ========================================
DateTime stripTime(DateTime d) => DateTime(d.year, d.month, d.day);

/// "2025-11-28"
String iso(DateTime d) => stripTime(d).toIso8601String().substring(0, 10);

String formatMonthDay(DateTime d) => DateFormat('MMM d').format(d);

DateTime reminderTwoDaysBefore(DateTime d) => stripTime(d).subtract(const Duration(days: 2));

/// ===== Domain types ========================================================
class Cycle {
  final DateTime start;   // day 1 of bleeding
  final DateTime? end;    // inclusive end date (null = still ongoing)

  const Cycle({required this.start, this.end});

  Cycle copyWith({DateTime? start, DateTime? end}) =>
      Cycle(start: start ?? this.start, end: end ?? this.end);
}

enum MoodKind {
  sad('😞', 'Sad'),
  discomfort('🥴', 'Not very comfortable'),
  ok('🙂', 'Okay'),
  average('😐', 'Average'),
  good('😊', 'Good'),
  notWorried('😌', 'Not worrying');

  final String emoji;
  final String label;
  const MoodKind(this.emoji, this.label);
}

class Prediction {
  final DateTime ovulation;
  final DateTime nextPeriodStart;
  const Prediction({required this.ovulation, required this.nextPeriodStart});
}

/// ===== AppState ============================================================
/// In-memory state. (We persist only onboarding basics for now.)
class AppState {
  final List<Cycle> cycles;                          // sorted by start ASC
  final Map<String, Set<MoodKind>> moodByDate;       // ISO -> set of moods
  final int? typicalCycleLengthDays;                 // from onboarding or user
  final int? typicalPeriodLengthDays;                // from onboarding or user

  const AppState({
    required this.cycles,
    required this.moodByDate,
    this.typicalCycleLengthDays,
    this.typicalPeriodLengthDays,
  });

  factory AppState.empty() =>
      const AppState(cycles: <Cycle>[], moodByDate: <String, Set<MoodKind>>{}, typicalCycleLengthDays: null, typicalPeriodLengthDays: null);

  AppState copyWith({
    List<Cycle>? cycles,
    Map<String, Set<MoodKind>>? moodByDate,
    int? typicalCycleLengthDays,
    int? typicalPeriodLengthDays,
  }) {
    return AppState(
      cycles: cycles ?? this.cycles,
      moodByDate: moodByDate ?? this.moodByDate,
      typicalCycleLengthDays: typicalCycleLengthDays ?? this.typicalCycleLengthDays,
      typicalPeriodLengthDays: typicalPeriodLengthDays ?? this.typicalPeriodLengthDays,
    );
  }

  /// Start a new period today (or on [start]).
  AppState startPeriod(DateTime start) {
    final DateTime s = stripTime(start);
    final List<Cycle> newCycles = <Cycle>[...cycles, Cycle(start: s)];
    newCycles.sort((Cycle a, Cycle b) => a.start.compareTo(b.start));
    return copyWith(cycles: newCycles);
  }

  /// End the current open cycle with [end].
  AppState endCurrentCycle(DateTime end) {
    if (cycles.isEmpty) return this;
    final Cycle last = cycles.last;
    if (last.end != null) return this; // already closed
    if (stripTime(end).isBefore(last.start)) return this; // invalid
    final List<Cycle> newCycles = <Cycle>[...cycles]..removeLast();
    newCycles.add(last.copyWith(end: stripTime(end)));
    return copyWith(cycles: newCycles);
  }

  /// Add a past period [start..end] in one go (used by "Add past period" flow).
  AppState addPeriod(DateTime start, DateTime end) {
    if (end.isBefore(start)) return this;
    final List<Cycle> newCycles = <Cycle>[...cycles, Cycle(start: stripTime(start), end: stripTime(end))]
      ..sort((Cycle a, Cycle b) => a.start.compareTo(b.start));
    return copyWith(cycles: newCycles);
  }

  /// Toggle a mood entry for a specific day.
  AppState toggleMoodForDay(DateTime day, MoodKind m) {
    final String key = iso(day);
    final Map<String, Set<MoodKind>> map = Map<String, Set<MoodKind>>.from(moodByDate);
    final Set<MoodKind> set = map[key] != null ? Set<MoodKind>.from(map[key]!) : <MoodKind>{};
    if (set.contains(m)) {
      set.remove(m);
    } else {
      set.add(m);
    }
    if (set.isEmpty) {
      map.remove(key);
    } else {
      map[key] = set;
    }
    return copyWith(moodByDate: map);
  }

  /// ===== Onboarding persistence (minimal) ==================================
  static Future<void> persistOnboarding({
    int? typicalPeriodLengthDays,
    int? typicalCycleLengthDays,
    required DateTime lastPeriodStart,
  }) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('onboarded', true);
    if (typicalPeriodLengthDays != null) {
      await sp.setInt('typicalPeriod', typicalPeriodLengthDays);
    }
    if (typicalCycleLengthDays != null) {
      await sp.setInt('typicalCycle', typicalCycleLengthDays);
    }
    await sp.setString('lastStart', iso(lastPeriodStart));
  }

  static Future<bool> hasOnboarded() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool('onboarded') ?? false;
  }

  /// Optionally load hints from prefs into a fresh state.
  static Future<AppState> fromPrefs() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final int? tPer = sp.getInt('typicalPeriod');
    final int? tCyc = sp.getInt('typicalCycle');
    final String? lastIso = sp.getString('lastStart');

    final List<Cycle> initialCycles = <Cycle>[];
    if (lastIso != null) {
      // Seed one (open) cycle starting at last known start.
      initialCycles.add(Cycle(start: DateTime.parse('${lastIso}T00:00:00')));
    }

    return AppState(
      cycles: initialCycles,
      moodByDate: <String, Set<MoodKind>>{},
      typicalCycleLengthDays: tCyc,
      typicalPeriodLengthDays: tPer,
    );
  }
}

/// ===== Stats & predictions =================================================
int bleedingDays(Cycle c) {
  if (c.end == null) return 0;
  return c.end!.difference(c.start).inDays + 1;
}

/// Average period length from closed cycles; fallback to typical or 5.
int estimatePeriodLengthDays(List<Cycle> cycles, {int? typical}) {
  final List<Cycle> closed = cycles.where((Cycle c) => c.end != null).toList();
  if (closed.isNotEmpty) {
    final int avg = closed
        .map((Cycle c) => bleedingDays(c))
        .where((int d) => d > 0)
        .fold<int>(0, (int a, int b) => a + b);
    final int n = closed.where((Cycle c) => bleedingDays(c) > 0).length;
    if (n > 0) return (avg / n).round();
  }
  return typical ?? 5;
}

/// Average cycle length between consecutive starts; fallback to typical or 28.
int estimateCycleLengthDays(List<Cycle> cycles, {int? typical}) {
  if (cycles.length >= 2) {
    final List<DateTime> starts = cycles.map((Cycle c) => c.start).toList()..sort();
    final List<int> gaps = <int>[];
    for (int i = 1; i < starts.length; i++) {
      gaps.add(starts[i].difference(starts[i - 1]).inDays);
    }
    if (gaps.isNotEmpty) {
      final double avg = gaps.reduce((int a, int b) => a + b) / gaps.length;
      return avg.round();
    }
  }
  return typical ?? 28;
}

Prediction? predict(AppState s) {
  if (s.cycles.isEmpty) return null;
  final DateTime lastStart = s.cycles.last.start;

  final int estCycle = estimateCycleLengthDays(
    s.cycles,
    typical: s.typicalCycleLengthDays,
  );

  final DateTime nextPeriodStart = stripTime(lastStart.add(Duration(days: estCycle)));
  // simple model: ovulation ≈ 14 days before next period
  final DateTime ovulation = stripTime(nextPeriodStart.subtract(const Duration(days: 14)));

  return Prediction(ovulation: ovulation, nextPeriodStart: nextPeriodStart);
}

