import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../utils/priority_utils.dart';
import '../services/dialog_service.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    // Remove Get.lazyPut here, TaskController should already be registered
    final taskController = Get.find<TaskController>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (newValue) {
            if (newValue != null) {
              taskController.toggleComplete(task);
            }
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
              backgroundColor: PriorityHelper.color(
                task.priority,
              ).withOpacity(0.12),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => DialogService.showEditTaskDialog(task),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                taskController.removeTask(task);
                Get.snackbar(
                  'Success',
                  'Task deleted successfully',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
