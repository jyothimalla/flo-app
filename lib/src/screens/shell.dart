// lib/src/screens/shell.dart
import 'package:flutter/material.dart';

import '../../models/app_state.dart';
import 'home_screen.dart';
import 'calendar_screen.dart';
import 'analysis_screen.dart';
import 'mood_screen.dart';
import 'reminders_screen.dart';
import 'profile_screen.dart';

class Shell extends StatefulWidget {
  /// Optional: pass an initial AppState. If null, we'll load from prefs.
  final AppState? initial;
  const Shell({super.key, this.initial});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  AppState? _state;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _state = widget.initial!;
    } else {
      _load();
    }
  }

  Future<void> _load() async {
    final s = await AppState.fromPrefs();
    if (!mounted) return;
    setState(() => _state = s);
  }

  @override
  Widget build(BuildContext context) {
    // show loader until state is ready
    if (_state == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final state = _state!;

    final pages = <Widget>[
      HomeScreen(
        state: state,
        onStartPeriod: (DateTime d) {
          setState(() => _state = state.startPeriod(d));
        },
        onEndPeriodWithMood: (DateTime d, MoodKind? m) {   // matches typedef above
          setState(() => _state = state.endCurrentCycle(d));
        },
        onScheduleReminder: () {},
        onToggleMood: (DateTime day, MoodKind m) {
          setState(() => _state = state.toggleMoodForDay(day, m));
        },
      ),

      MoodScreen(
        state: state,
        onToggleMood: (DateTime day, MoodKind m) {
          setState(() => _state = state.toggleMoodForDay(day, m));
        },
      ),
      CalendarScreen(state: state),
      AnalysisScreen(
        state: state,
        onStartPeriod: (DateTime d) {
          setState(() => _state = state.startPeriod(d));
        },
        onAddPastPeriod: (DateTime s, DateTime e) {
          setState(() => _state = state.addPeriod(s, e));
        },
      ),
      RemindersScreen(
        state: state,
        onScheduleReminder: () {}, // hook real notifications later
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions_outlined),
            label: 'Mood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outlined),
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
