import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';

class TaskInput extends StatefulWidget {
  const TaskInput({super.key});

  @override
  State<TaskInput> createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  final TextEditingController titleController = TextEditingController();
  final TaskController ctrl = Get.find();

  DateTime? _pickedDeadline;
  int _priority = 2; // default Medium

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _pickedDeadline ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_pickedDeadline ?? now),
    );
    if (time == null) return;
    setState(() {
      _pickedDeadline = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _add() {
    final t = titleController.text.trim();
    if (t.isEmpty) return;
    ctrl.addTask(t, _pickedDeadline, _priority);
    titleController.clear();
    setState(() {
      _pickedDeadline = null;
      _priority = 2;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Enter a task",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _add(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _add,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_calendar),
                  onPressed: _pickDateTime,
                ),
                Expanded(
                  child: Text(
                    _pickedDeadline == null
                        ? 'No deadline chosen'
                        : 'Deadline: ${_pickedDeadline.toString().substring(0, 16)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Priority:'),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _priority,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('High')),
                    DropdownMenuItem(value: 2, child: Text('Medium')),
                    DropdownMenuItem(value: 3, child: Text('Low')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _priority = v);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
