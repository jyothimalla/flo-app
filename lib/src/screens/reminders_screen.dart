import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import '../../widgets/card_widgets.dart';

class RemindersScreen extends StatelessWidget {
  final AppState state;
  final VoidCallback onScheduleReminder;
  const RemindersScreen({super.key, required this.state, required this.onScheduleReminder});

  @override
  Widget build(BuildContext context) {
    final Prediction? pr = predict(state);

    return CardBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const CardTitle('Reminders'),
          const SizedBox(height: 8),
          if (pr == null)
            const Text('Add a period to enable reminders.')
          else ...<Widget>[
            Text('Next period: ${iso(pr.nextPeriodStart)}'),
            Text('We will remind you on ${iso(reminderTwoDaysBefore(pr.nextPeriodStart))}.'),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: onScheduleReminder,
              icon: const Icon(Icons.notifications_active_outlined),
              label: const Text('Set reminder'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Note: demo uses in-app confirmation. Integrate notifications later.',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ],
        ],
      ),
    );
  }
}
