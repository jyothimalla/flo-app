import 'models.dart';

class CyclePredictor {
  final AppStateSnapshot state;
  CyclePredictor(this.state);

  DateTime? predictNextPeriodStart() {
    final periods = [...state.periods]..sort((a, b) => a.start.compareTo(b.start));
    if (periods.isEmpty) return null;

    final diffs = <int>[];
    for (int i = 1; i < periods.length; i++) {
      final diff = periods[i].start.difference(periods[i - 1].start).inDays;
      if (diff >= 15 && diff <= 60) diffs.add(diff);
    }

    int cycleLen = state.profile.params.defaultCycleLength;
    if (diffs.isNotEmpty) {
      final k = state.profile.params.smoothingWindow.clamp(1, diffs.length);
      final lastK = diffs.sublist(diffs.length - k);
      cycleLen = (lastK.reduce((a, b) => a + b) / lastK.length).round();
      cycleLen = cycleLen.clamp(20, 45);
    }

    final lastStart = periods.last.start;
    return DateTime(lastStart.year, lastStart.month, lastStart.day)
        .add(Duration(days: cycleLen));
  }

  DateTime? estimateOvulationDay() {
    final nextStart = predictNextPeriodStart();
    if (nextStart == null) return null;
    return nextStart.subtract(Duration(days: state.profile.params.lutealPhaseDays));
  }

  List<DateTime> fertileWindowDays() {
    final o = estimateOvulationDay();
    if (o == null) return [];
    final start = o.subtract(const Duration(days: 5));
    return List.generate(7, (i) => DateTime(start.year, start.month, start.day).add(Duration(days: i)));
  }
}
