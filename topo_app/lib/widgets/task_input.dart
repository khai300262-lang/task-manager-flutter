import 'package:flutter/material.dart';

class TaskInput extends StatefulWidget {
  final Function(String) onSubmit;

  const TaskInput({super.key, required this.onSubmit});

  @override
  State<TaskInput> createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  final TextEditingController _controller = TextEditingController();

  void _handleSubmit() {
    if (_controller.text.isNotEmpty) {
      widget.onSubmit(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Enter your task...",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _handleSubmit(),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: _handleSubmit,
            child: const Text("Add"),
          )
        ],
      ),
    );
  }
}
