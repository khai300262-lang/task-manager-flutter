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
  DateTime? _selectedDeadline; // deadline
  int? _editingIndex;

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
        ),
      );
      _controller.clear();
      _selectedDeadline = null;
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
                  ElevatedButton(
                    onPressed: _addTask,
                    child: Text(_editingIndex != null ? "Edit Task" : "Add Task"),
                  ),
                ],
              ),
            ),
            TaskList(
              tasks: _tasks,
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