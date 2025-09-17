import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleDone;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggleDone,
    required this.onRemove,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final deadlineText = task.deadline != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(task.deadline!)
        : "No deadline";

    // Build priority stars
    final List<Widget> priorityStars = List.generate(
      task.priority.index + 1,
          (index) => const Icon(
        Icons.star,
        color: Colors.amber,
        size: 16,
      ),
    );

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
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(deadlineText),
          Row(children: priorityStars), // Display the stars
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}