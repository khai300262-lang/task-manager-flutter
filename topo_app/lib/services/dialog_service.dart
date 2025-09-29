import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/task.dart';
import '../screens/login_page.dart';

class DialogService {
  static void showEditTaskDialog(Task task) {
    final taskController = Get.find<TaskController>();
    final editTitleController = TextEditingController(text: task.title);
    DateTime? pickedDeadline = task.deadline;
    int selectedPriority = task.priority;

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Task'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: editTitleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final now = DateTime.now();
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: pickedDeadline ?? now,
                            firstDate: DateTime(now.year - 1),
                            lastDate: DateTime(now.year + 5),
                          );
                          if (selectedDate == null) return;
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                              pickedDeadline ?? now,
                            ),
                          );
                          if (selectedTime == null) return;
                          setState(() {
                            pickedDeadline = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          pickedDeadline == null
                              ? 'No deadline chosen'
                              : 'Deadline: ${pickedDeadline.toString().substring(0, 16)}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Priority:'),
                      const SizedBox(width: 16),
                      DropdownButton<int>(
                        value: selectedPriority,
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('High')),
                          DropdownMenuItem(value: 2, child: Text('Medium')),
                          DropdownMenuItem(value: 3, child: Text('Low')),
                        ],
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() => selectedPriority = newValue);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (editTitleController.text.trim().isEmpty) return;

              taskController.editTask(
                task: task,
                newTitle: editTitleController.text.trim(),
                newDeadline: pickedDeadline,
                newPriority: selectedPriority,
              );
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  static void showProfileDialog() {
    final authController = Get.find<AuthController>();
    final user = authController.user.value;
    if (user == null) return;

    Get.dialog(
      AlertDialog(
        title: const Text('User Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem('Email', user.email ?? 'Not available'),
            _buildInfoItem('UID', user.uid),
            _buildInfoItem('Email Verified', user.emailVerified ? 'Yes' : 'No'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }

  static Widget _buildInfoItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value.toString()),
          ],
        ),
      ),
    );
  }

  static void showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              _performLogout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  static Future<void> _performLogout() async {
    final authController = Get.find<AuthController>();

    if (Get.isRegistered<TaskController>()) {
      Get.delete<TaskController>(force: true);
    }

    await authController.logout();
    Get.offAll(() => LoginPage());
  }
}
