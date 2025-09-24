import 'package:flutter/material.dart';

class MenuItemsBuilder {
  static List<PopupMenuEntry<String>> buildMenuItems() {
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
}
