import 'package:ai_prompt_organizer/ai_prompt_organizer.dart';
import 'package:flutter/material.dart';

class DeleteAlertDialog extends StatelessWidget {
  const DeleteAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(DeleteAlertMessage.title),
      content: const Text(DeleteAlertMessage.content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("キャンセル"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text("削除"),
        ),
      ],
    );
  }
}
