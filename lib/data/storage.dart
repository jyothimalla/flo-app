import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'models.dart';

const _boxKey = 'app_state_v1';

class LocalStore {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_boxKey);
  }

  static Future<void> save(AppStateSnapshot snapshot) async {
    final box = Hive.box<String>(_boxKey);
    await box.put('state', _encode(snapshot));
  }

  static AppStateSnapshot loadOrDefault() {
    final box = Hive.box<String>(_boxKey);
    final str = box.get('state');
    if (str == null) {
      return AppStateSnapshot(profile: UserProfile(createdAt: DateTime.now()));
    }
    return _decode(str);
  }

  static String _encode(AppStateSnapshot s) {
    final m = {
      'profile': {
        'createdAt': s.profile.createdAt.toIso8601String(),
        'params': {
          'defaultCycleLength': s.profile.params.defaultCycleLength,
          'lutealPhaseDays': s.profile.params.lutealPhaseDays,
          'smoothingWindow': s.profile.params.smoothingWindow,
        }
      },
      'periods': s.periods.map((p) => {
            'start': p.start.toIso8601String(),
            'end': p.end?.toIso8601String(),
            'dailyFlow': p.dailyFlow.map((e) => e.index).toList(),
          }).toList(),
      'symptoms': s.symptoms.map((x) => {
            'date': x.date.toIso8601String(),
            'type': x.type.index,
            'note': x.note,
          }).toList(),
      'tests': s.tests.map((t) => {
            'date': t.date.toIso8601String(),
            'positive': t.positive,
          }).toList(),
    };
    return jsonEncode(m);
  }

  static AppStateSnapshot _decode(String str) {
    final m = jsonDecode(str) as Map<String, dynamic>;
    final p = m['profile'];
    final params = p['params'];
    return AppStateSnapshot(
      profile: UserProfile(
        createdAt: DateTime.parse(p['createdAt']),
        params: CycleParams(
          defaultCycleLength: (params['defaultCycleLength'] ?? 28) as int,
          lutealPhaseDays: (params['lutealPhaseDays'] ?? 14) as int,
          smoothingWindow: (params['smoothingWindow'] ?? 3) as int,
        ),
      ),
      periods: (m['periods'] as List).map((e) => PeriodLog(
            start: DateTime.parse(e['start']),
            end: e['end'] != null ? DateTime.parse(e['end']) : null,
            dailyFlow: (e['dailyFlow'] as List)
                .map((i) => FlowIntensity.values[i])
                .toList(),
          )).toList(),
      symptoms: (m['symptoms'] as List).map((e) => SymptomEntry(
            date: DateTime.parse(e['date']),
            type: SymptomType.values[e['type']],
            note: e['note'],
          )).toList(),
      tests: (m['tests'] as List).map((e) => OvulationTest(
            date: DateTime.parse(e['date']),
            positive: e['positive'] == true,
          )).toList(),
    );
  }
}
