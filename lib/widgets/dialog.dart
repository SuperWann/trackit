import 'package:flutter/material.dart';

class YesNoDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onYes;
  final VoidCallback onNo;

  const YesNoDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onYes,
    required this.onNo,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(child: const Text('Yes'), onPressed: onYes),
        TextButton(child: const Text('No'), onPressed: onNo),
      ],
    );
  }
}

class YesDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onYes;

  const YesDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onYes,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [TextButton(child: const Text('Ok'), onPressed: onYes)],
    );
  }
}
