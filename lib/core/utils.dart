import 'package:flutter/material.dart';


Future<T?> showConfirm<T>({required BuildContext context, required String title, String? message}) {
return showDialog<T>(
context: context,
builder: (c) => AlertDialog(
title: Text(title),
content: message != null ? Text(message) : null,
actions: [
TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
FilledButton(onPressed: () => Navigator.pop(c, true as T?), child: const Text('OK')),
],
),
);
}