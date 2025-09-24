import 'package:get/get.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> tasks = <Task>[].obs;
  final RxInt selectedPriority = 0.obs;

  void addTask(String title, DateTime? deadline, int priority) {
    final task = Task(title: title, deadline: deadline, priority: priority);
    tasks.insert(0, task);
  }

  void removeTask(Task task) {
    tasks.remove(task);
  }

  void removeTaskAtIndex(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
    }
  }

  void toggleComplete(Task task) {
    task.isCompleted = !task.isCompleted;
    tasks.refresh();
  }

  void editTask({
    required Task task,
    required String newTitle,
    required DateTime? newDeadline,
    required int newPriority,
  }) {
    final index = tasks.indexWhere((currentTask) => currentTask == task);
    if (index == -1) return;

    final updatedTask = tasks[index];
    updatedTask.title = newTitle;
    updatedTask.deadline = newDeadline;
    updatedTask.priority = newPriority;

    // Move to head
    tasks.removeAt(index);
    tasks.insert(0, updatedTask);
    tasks.refresh();
  }

  void changeFilter(int priority) {
    selectedPriority.value = priority;
  }

  List<Task> get filteredTasks {
    if (selectedPriority.value == 0) {
      return tasks.toList();
    }
    return tasks
        .where((task) => task.priority == selectedPriority.value)
        .toList();
  }

  void sortByPriority() {
    tasks.sort(
      (firstTask, secondTask) =>
          firstTask.priority.compareTo(secondTask.priority),
    );
    tasks.refresh();
  }
}
