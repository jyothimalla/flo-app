import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flo_app/models/app_state.dart';
import 'package:flo_app/src/screens/calendar_screen.dart';

void main() {
  testWidgets('Calendar shows ovulation day & fertile day', (WidgetTester tester) async {
    AppState s = AppState.empty();
    s = s.addPeriod(DateTime(2025, 11, 01), DateTime(2025, 11, 05));
    s = s.addPeriod(DateTime(2025, 11, 30), DateTime(2025, 12, 03));
    final Prediction pr = predict(s)!;

    await tester.pumpWidget(MaterialApp(home: CalendarScreen(state: s)));
    await tester.pumpAndSettle();

    final ValueKey<String> ovKey = ValueKey('cal-day-${iso(pr.ovulation)}');
    expect(find.byKey(ovKey), findsOneWidget);

    await tester.tap(find.byKey(ovKey));
    await tester.pump();

    expect(
      find.descendant(of: find.byKey(ovKey), matching: find.byIcon(Icons.circle)),
      findsWidgets,
    );

    final ValueKey<String> fertileKey = ValueKey('cal-day-${iso(pr.ovulation.subtract(const Duration(days: 3)))}');
    expect(find.byKey(fertileKey), findsOneWidget);
  });
}
