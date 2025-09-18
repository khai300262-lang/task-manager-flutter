import 'package:flutter/material.dart';

class PriorityHelper {
  static Color color(int p) {
    switch (p) {
      case 1:
        return Colors.redAccent;
      case 2:
        return Colors.orangeAccent;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  static String label(int p) {
    switch (p) {
      case 1:
        return 'High';
      case 2:
        return 'Medium';
      case 3:
        return 'Low';
      default:
        return 'Unknown';
    }
  }
}
