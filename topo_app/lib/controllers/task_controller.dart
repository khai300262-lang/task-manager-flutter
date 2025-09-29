import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import '../models/task.dart';
import '../services/api_service.dart';
import 'auth_controller.dart';

class TaskController extends GetxController {
  final RxList<Task> tasks = <Task>[].obs;
  final RxInt selectedPriority = 0.obs;
  final RxBool isLoading = false.obs;

  int get currentUserId {
    final user = Get.find<AuthController>().user.value;
    if (user == null) return 0;
    return ApiService.generateUserId(user.uid);
  }

  @override
  void onInit() {
    super.onInit();
    ever(Get.find<AuthController>().user, (User? user) {
      if (user != null) {
        loadTasks();
      } else {
        tasks.clear();
      }
    });
    if (currentUserId != 0) {
      loadTasks();
    }
  }

  void clearTasks() {
    tasks.clear();
    selectedPriority.value = 0;
  }

  Future<void> loadTasks() async {
    if (currentUserId == 0) return;

    isLoading.value = true;
    try {
      final response = await ApiService.get('todos/user/$currentUserId');
      final Map<String, dynamic> data = json.decode(response.body);

      final List<dynamic> todos = data['todos'] ?? [];

      tasks.assignAll(
        todos.map<Task>((json) => Task.fromJson(json, currentUserId)),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tasks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTask(String title, DateTime? deadline, int priority) async {
    final newTask = Task(
      title: title,
      deadline: deadline,
      priority: priority,
      userId: currentUserId,
    );

    try {
      final response = await ApiService.post('todos/add', newTask.toJson());
      final Map<String, dynamic> data = json.decode(response.body);

      newTask.id = data['id'];
      tasks.insert(0, newTask);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add task: $e');
      rethrow;
    }
  }

  Future<void> removeTask(Task task) async {
    if (task.id == null || task.id == 0) {
      tasks.remove(task);
      return;
    }

    try {
      await ApiService.delete('todos/${task.id}');
      tasks.remove(task);
    } catch (e) {
      if (e.toString().contains('404')) {
        tasks.remove(task);
        Get.snackbar('Info', 'Task was removed ');
      } else {
        Get.snackbar('Error', 'Failed to delete task: $e');
        rethrow;
      }
    }
  }

  Future<void> toggleComplete(Task task) async {
    final oldValue = task.isCompleted;
    task.isCompleted = !task.isCompleted;
    tasks.refresh();

    if (task.id != null && task.id != 0) {
      try {
        await ApiService.put('todos/${task.id}', task.toJson());
        tasks.refresh();
      } catch (e) {
        if (e.toString().contains('404')) {
          tasks.refresh();
          Get.snackbar('Info', 'Task updated ');
        } else {
          task.isCompleted = oldValue;
          tasks.refresh();
          Get.snackbar('Error', 'Failed to update task: $e');
        }
      }
    }
  }

  Future<void> editTask({
    required Task task,
    required String newTitle,
    required DateTime? newDeadline,
    required int newPriority,
  }) async {
    final oldTitle = task.title;
    final oldDeadline = task.deadline;
    final oldPriority = task.priority;
    final int originalIndex = tasks.indexOf(task);

    task.title = newTitle;
    task.deadline = newDeadline;
    task.priority = newPriority;

    tasks.remove(task);
    tasks.insert(0, task);
    tasks.refresh();

    if (task.id != null && task.id != 0) {
      try {
        await ApiService.put('todos/${task.id}', task.toJson());
      } catch (e) {
        if (e.toString().contains('404')) {
          Get.snackbar('Info', 'Task updated ');
        } else {
          task.title = oldTitle;
          task.deadline = oldDeadline;
          task.priority = oldPriority;
          tasks.remove(task);
          tasks.insert(originalIndex, task);

          tasks.refresh();
          Get.snackbar('Error', 'Failed to update task: $e');
        }
      }
    }
  }

  void changeFilter(int priority) {
    selectedPriority.value = priority;
  }

  List<Task> get filteredTasks {
    final allTasks = tasks.toList();
    if (selectedPriority.value == 0) {
      return allTasks;
    }
    return allTasks
        .where((task) => task.priority == selectedPriority.value)
        .toList();
  }

  void sortByPriority() {
    final sorted = tasks.toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
    tasks.assignAll(sorted);
  }
}
