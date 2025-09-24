import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/task_controller.dart';
import '../screens/login_page.dart';

class AppBarMenu extends StatelessWidget {
  const AppBarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleMenuSelection(value),
      itemBuilder: (BuildContext context) => _buildMenuItems(),
      icon: const Icon(Icons.more_vert, color: Colors.white),
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems() {
    return <PopupMenuEntry<String>>[
      const PopupMenuItem<String>(
        value: 'profile',
        child: Row(
          children: [
            Icon(Icons.person, color: Colors.blue),
            SizedBox(width: 8),
            Text('View Profile'),
          ],
        ),
      ),
      const PopupMenuItem<String>(
        value: 'edit_profile',
        child: Row(
          children: [
            Icon(Icons.edit, color: Colors.green),
            SizedBox(width: 8),
            Text('Edit Profile'),
          ],
        ),
      ),
      const PopupMenuDivider(),
      const PopupMenuItem<String>(
        value: 'logout',
        child: Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text('Logout'),
          ],
        ),
      ),
    ];
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'profile':
        _showProfileInfo();
        break;
      case 'edit_profile':
        _showEditProfile();
        break;
      case 'logout':
        _showLogoutConfirmation();
        break;
    }
  }

  void _showProfileInfo() {
    final authCtrl = Get.find<AuthController>();
    final user = authCtrl.user.value;
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

  Widget _buildInfoItem(String label, dynamic value) {
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

  void _showEditProfile() {
    Get.snackbar(
      'Coming Soon',
      'Edit profile feature is under development',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: _performLogout,
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout() async {
    final authCtrl = Get.find<AuthController>();

    Get.back(); // Close dialog
    await authCtrl.logout();
    Get.delete<TaskController>(force: true);
    Get.offAll(() => LoginPage());
  }
}
