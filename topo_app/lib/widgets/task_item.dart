import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../utils/priority_utils.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<TaskController>();
    final int index = ctrl.indexOf(task);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (val) {
            if (val == true && index != -1) ctrl.toggleCompleteAtIndex(index);
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.deadline != null)
              Text(task.deadline.toString().substring(0, 16)),
            const SizedBox(height: 4),
            Chip(
              label: Text("Priority: ${PriorityHelper.label(task.priority)}"),
              labelStyle: TextStyle(color: PriorityHelper.color(task.priority)),
              backgroundColor: PriorityHelper.color(task.priority).withOpacity(0.12),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditDialog(context, ctrl, index, task),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                if (index != -1) ctrl.removeTaskAtIndex(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, TaskController ctrl, int index, Task t) {
    final editTitle = TextEditingController(text: t.title);
    DateTime? picked = t.deadline;
    int priority = t.priority;

    Future<void> pickDateTime(StateSetter setState) async {
      final now = DateTime.now();
      final date = await showDatePicker(
        context: context,
        initialDate: picked ?? now,
        firstDate: DateTime(now.year - 1),
        lastDate: DateTime(now.year + 5),
      );
      if (date == null) return;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(picked ?? now),
      );
      if (time == null) return;
      setState(() {
        picked = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      });
    }

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setState) => AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editTitle,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_calendar_outlined),
                    onPressed: () => pickDateTime(setState),
                  ),
                  Expanded(
                    child: Text(
                      picked == null ? 'No deadline chosen' : picked.toString().substring(0, 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Priority:'),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: priority,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('High')),
                      DropdownMenuItem(value: 2, child: Text('Medium')),
                      DropdownMenuItem(value: 3, child: Text('Low')),
                    ],
                    onChanged: (v) => setState(() => priority = v!),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx2), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (editTitle.text.trim().isEmpty || index == -1) return;
                ctrl.editTaskAtIndex(index, editTitle.text.trim(), picked, priority);
                Navigator.pop(ctx2);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
