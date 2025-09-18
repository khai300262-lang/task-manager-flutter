import 'package:get/get.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  // main tasks list (observable)
  final RxList<Task> tasks = <Task>[].obs;

  // filter: 0 = All, 1 = High, 2 = Medium, 3 = Low
  final RxInt selectedPriority = 0.obs;

  // Add new task -> push to head
  void addTask(String title, DateTime? deadline, int priority) {
    final t = Task(title: title, deadline: deadline, priority: priority);
    tasks.insert(0, t);
  }

  // Remove by actual index in tasks
  void removeTaskAtIndex(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
    }
  }

  // Remove by reference (safe)
  void removeTask(Task task) {
    tasks.remove(task);
  }

  // Toggle completion by actual index
  void toggleCompleteAtIndex(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      tasks.refresh();
    }
  }

  // Edit: update fields and move to head
  void editTaskAtIndex(int index, String newTitle, DateTime? newDeadline, int newPriority) {
    if (index < 0 || index >= tasks.length) return;
    final old = tasks[index];
    old.title = newTitle;
    old.deadline = newDeadline;
    old.priority = newPriority;
    // move updated to head
    tasks.removeAt(index);
    tasks.insert(0, old);
    tasks.refresh();
  }

  // Change current filter
  void changeFilter(int priority) {
    selectedPriority.value = priority;
  }

  // Get filtered tasks (returns a list view - NOT RxList)
  List<Task> get filteredTasks {
    if (selectedPriority.value == 0) {
      return tasks;
    }
    return tasks.where((t) => t.priority == selectedPriority.value).toList();
  }

  // Helper: find actual index of a task in tasks list
  int indexOf(Task task) {
    return tasks.indexWhere((t) => identical(t, task) || (t.title == task.title && t.deadline == task.deadline && t.priority == task.priority && t.isCompleted == task.isCompleted));
  }
}
