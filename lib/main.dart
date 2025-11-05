import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/app_theme.dart';
import 'data/models.dart';
import 'data/storage.dart';
import 'data/prediction.dart';
import 'features/calendar/calendar_page.dart';
import 'features/insights/insights_page.dart';
import 'features/settings/settings_page.dart';
import 'features/logging/log_period_page.dart';

final appStateProvider =
    StateNotifierProvider<AppStateNotifier, AppStateSnapshot>(
  (ref) => AppStateNotifier(),
);

class AppStateNotifier extends StateNotifier<AppStateSnapshot> {
  AppStateNotifier()
      : super(AppStateSnapshot(profile: UserProfile(createdAt: DateTime.now())));

  Future<void> load() async {
    await LocalStore.init();
    state = LocalStore.loadOrDefault();
  }

  Future<void> persist() async => LocalStore.save(state);

  void logPeriodStart(DateTime date) {
    final list = [...state.periods, PeriodLog(start: date)];
    state = AppStateSnapshot(
      profile: state.profile,
      periods: list,
      symptoms: state.symptoms,
      tests: state.tests,
    );
    persist();
  }

  void logPeriodEnd(DateTime start, DateTime end) {
    final updated = state.periods
        .map((p) => p.start == start
            ? PeriodLog(start: p.start, end: end, dailyFlow: p.dailyFlow)
            : p)
        .toList();
    state = AppStateSnapshot(
      profile: state.profile,
      periods: updated,
      symptoms: state.symptoms,
      tests: state.tests,
    );
    persist();
  }

  void addSymptom(SymptomEntry e) {
    state = AppStateSnapshot(
      profile: state.profile,
      periods: state.periods,
      symptoms: [...state.symptoms, e],
      tests: state.tests,
    );
    persist();
  }

  void addTest(OvulationTest t) {
    state = AppStateSnapshot(
      profile: state.profile,
      periods: state.periods,
      symptoms: state.symptoms,
      tests: [...state.tests, t],
    );
    persist();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStore.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flo-like Tracker',
      theme: buildTheme(),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final pages = const [CalendarPage(), InsightsPage(), SettingsPage()];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.auto_graph), label: 'Insights'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      floatingActionButton: index == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const LogPeriodPage())),
              icon: const Icon(Icons.add),
              label: const Text('Log period'),
            )
          : null,
    );
  }
}
