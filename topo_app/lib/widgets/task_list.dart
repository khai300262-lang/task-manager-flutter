import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import 'task_item.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();

    return Obx(() {
      final List<Task> list = controller.filteredTasks;
      if (list.isEmpty) {
        return const Center(child: Text('No tasks available'));
      }
      return ListView.builder(
        itemCount: list.length,
        padding: const EdgeInsets.only(bottom: 16, top: 8),
        itemBuilder: (context, i) => TaskItem(task: list[i]),
      );
    });
  }
}
