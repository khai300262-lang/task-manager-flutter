import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_item.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final void Function(int) onToggleDone;
  final void Function(int) onRemove;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onToggleDone,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (ctx, i) => TaskItem(
        task: tasks[i],
        onToggleDone: () => onToggleDone(i),
        onRemove: () => onRemove(i),
      ),
    );
  }
}
