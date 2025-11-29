import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import '../../widgets/card_widgets.dart';

class MoodScreen extends StatelessWidget {
  final AppState state;
  final void Function(DateTime, MoodKind) onToggleMood;
  const MoodScreen({super.key, required this.state, required this.onToggleMood});

  @override
  Widget build(BuildContext context) {
    final DateTime today = stripTime(DateTime.now());
    final Set<MoodKind> selected = state.moodByDate[iso(today)] ?? <MoodKind>{};

    return CardBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const CardTitle('How do you feel today?'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: <Widget>[
              for (final MoodKind m in MoodKind.values)
                EmojiChoice(
                  emoji: m.emoji,
                  label: m.label,
                  selected: selected.contains(m),
                  onTap: () => onToggleMood(today, m),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Selected: ${selected.map((MoodKind e) => e.label).join(', ')}'),
        ],
      ),
    );
  }
}

/// Tiny reusable chip
class EmojiChoice extends StatelessWidget {
  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const EmojiChoice({
    super.key,
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? cs.primary.withOpacity(.10) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? cs.primary : const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
