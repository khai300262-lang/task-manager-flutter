import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> _tasks = [];
  final _controller = TextEditingController();
  DateTime? _selectedDeadline;
  int? _editingIndex;
  Priority _selectedPriority = Priority.low; // New state for priority
  Priority? _filterPriority; // New state for filter

  void _addTask() {
    if (_controller.text.isEmpty) return;
    setState(() {
      if (_editingIndex != null) {
        _tasks.removeAt(_editingIndex!);
        _editingIndex = null;
      }
      _tasks.insert(
        0,
        Task(
          title: _controller.text,
          deadline: _selectedDeadline,
          priority: _selectedPriority, // Add priority to new task
        ),
      );
      _controller.clear();
      _selectedDeadline = null;
      _selectedPriority = Priority.low;
    });
  }

  void _toggleTaskDone(int index) {
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _editTask(int index) {
    setState(() {
      _editingIndex = index;
      _controller.text = _tasks[index].title;
      _selectedDeadline = _tasks[index].deadline;
      _selectedPriority = _tasks[index].priority; // Set priority for editing
    });
  }

  Future<void> _pickDeadline() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _selectedDeadline = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks = _tasks.where((task) {
      if (_filterPriority == null) {
        return true;
      }
      return task.priority == _filterPriority;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Topo App - Task Manager")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Enter a task",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDeadline == null
                              ? "No deadline chosen"
                              : "Deadline: ${_selectedDeadline.toString()}",
                        ),
                      ),
                      TextButton(
                        onPressed: _pickDeadline,
                        child: const Text("Pick Deadline"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Priority:"),
                      ...Priority.values.map((priority) {
                        return IconButton(
                          icon: Icon(
                            _selectedPriority.index >= priority.index
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedPriority = priority;
                            });
                          },
                        );
                      }).toList(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _addTask,
                    child: Text(_editingIndex != null ? "Edit Task" : "Add Task"),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Filter section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Filter by Priority:"),
                IconButton(
                  icon: Icon(
                    _filterPriority == null ? Icons.filter_alt : Icons.filter_alt_off,
                    color: _filterPriority == null ? Colors.blue : Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      _filterPriority = null;
                    });
                  },
                ),
                ...Priority.values.map((priority) {
                  return IconButton(
                    icon: Icon(
                      priority.index >= Priority.low.index ? Icons.star : Icons.star_border,
                      color: _filterPriority == priority ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _filterPriority = priority;
                      });
                    },
                  );
                }).toList(),
              ],
            ),
            const Divider(),
            TaskList(
              tasks: filteredTasks, // Use the filtered list
              onToggleDone: _toggleTaskDone,
              onRemove: _removeTask,
              onEdit: _editTask,
            ),
          ],
        ),
      ),
    );
  }
}