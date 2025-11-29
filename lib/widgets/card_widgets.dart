import 'package:flutter/material.dart';

class CardBox extends StatelessWidget {
  final Widget child; const CardBox({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: child));
}

class CardTitle extends StatelessWidget {
  final String text; const CardTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16));
}

class EmojiChoice extends StatelessWidget {
  final String emoji; final String label; final bool selected; final VoidCallback onTap;
  const EmojiChoice({super.key, required this.emoji, required this.label, required this.selected, required this.onTap});
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
        child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text(emoji, style: const TextStyle(fontSize: 18)), const SizedBox(width: 8), Text(label),
        ]),
      ),
    );
  }
}