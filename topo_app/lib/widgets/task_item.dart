import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleDone;
  final VoidCallback onRemove;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggleDone,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final deadlineText = task.deadline != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(task.deadline!)
        : "No deadline";

    return ListTile(
      leading: Checkbox(
        value: task.isDone,
        onChanged: (_) => onToggleDone(),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(deadlineText),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onRemove,
      ),
    );
  }
}
