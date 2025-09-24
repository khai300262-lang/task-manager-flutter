import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../widgets/task_input.dart';
import '../widgets/task_list.dart';
import '../widgets/menu/app_bar_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToPo - Task Manager'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: const [AppBarMenu()],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: TaskInput(),
            ),
            const SizedBox(height: 12),
            _buildFilterSection(taskController),
            const SizedBox(height: 8),
            const Expanded(child: TaskList()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(TaskController taskController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          const Text('Filter:'),
          const SizedBox(width: 12),
          Obx(
            () => DropdownButton<int>(
              value: taskController.selectedPriority.value,
              items: const [
                DropdownMenuItem(value: 0, child: Text('All')),
                DropdownMenuItem(value: 1, child: Text('High')),
                DropdownMenuItem(value: 2, child: Text('Medium')),
                DropdownMenuItem(value: 3, child: Text('Low')),
              ],
              onChanged: (newValue) {
                if (newValue != null) taskController.changeFilter(newValue);
              },
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Sort by priority (asc)',
            icon: const Icon(Icons.sort),
            onPressed: () => taskController.sortByPriority(),
          ),
        ],
      ),
    );
  }
}
