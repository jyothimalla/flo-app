import 'package:flutter_test/flutter_test.dart';
import 'package:flo_app/models/app_state.dart';

void main() {
  group('AppState periods', () {
    test('startPeriod adds open cycle', () {
      AppState s = AppState.empty();
      s = s.startPeriod(DateTime(2025, 11, 1));
      expect(s.cycles.length, 1);
      expect(s.cycles.single.start, DateTime(2025, 11, 1));
      expect(s.cycles.single.end, isNull);
    });

    test('endCurrentCycle closes last open cycle', () {
      AppState s = AppState.empty();
      s = s.startPeriod(DateTime(2025, 11, 1));
      s = s.endCurrentCycle(DateTime(2025, 11, 5));
      expect(s.cycles.single.end, DateTime(2025, 11, 5));
      expect(bleedingDays(s.cycles.single), 5);
    });

    test('addPeriod inserts and sorts', () {
      AppState s = AppState.empty();
      s = s.addPeriod(DateTime(2025, 10, 10), DateTime(2025, 10, 13));
      s = s.addPeriod(DateTime(2025, 9, 1), DateTime(2025, 9, 4));
      expect(s.cycles.first.start, DateTime(2025, 9, 1));
      expect(s.cycles.last.end, DateTime(2025, 10, 13));
    });

    test('toggleMoodForDay adds and removes', () {
      AppState s = AppState.empty();
      final DateTime day = DateTime(2025, 11, 28);
      s = s.toggleMoodForDay(day, MoodKind.good);
      expect(s.moodByDate[iso(day)]!.contains(MoodKind.good), true);
      s = s.toggleMoodForDay(day, MoodKind.good);
      expect(s.moodByDate.containsKey(iso(day)), false);
    });
  });

  group('Stats & predictions', () {
    test('estimatePeriodLengthDays from closed cycles', () {
      AppState s = AppState.empty();
      s = s.addPeriod(DateTime(2025, 10, 1), DateTime(2025, 10, 4)); // 4
      s = s.addPeriod(DateTime(2025, 11, 1), DateTime(2025, 11, 5)); // 5
      final int avg = estimatePeriodLengthDays(s.cycles, typical: 5);
      expect(avg, 5);
    });

    test('estimateCycleLengthDays from starts', () {
      AppState s = AppState.empty();
      s = s.addPeriod(DateTime(2025, 9, 1), DateTime(2025, 9, 5));
      s = s.addPeriod(DateTime(2025, 9, 30), DateTime(2025, 10, 3));
      s = s.addPeriod(DateTime(2025, 10, 29), DateTime(2025, 11, 1));
      final int est = estimateCycleLengthDays(s.cycles, typical: 28);
      expect(est, 29);
    });

    test('predict works', () {
      AppState s = AppState.empty();
      s = s.addPeriod(DateTime(2025, 10, 1), DateTime(2025, 10, 5));
      s = s.addPeriod(DateTime(2025, 10, 30), DateTime(2025, 11, 2)); // gap 29
      final Prediction pr = predict(s)!;
      expect(pr.nextPeriodStart, DateTime(2025, 11, 28));
      expect(pr.ovulation, DateTime(2025, 11, 14));
    });
  });
}
