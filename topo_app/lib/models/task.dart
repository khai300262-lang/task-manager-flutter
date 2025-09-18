class Task {
  String title;
  DateTime? deadline;
  int priority; // 1 = High, 2 = Medium, 3 = Low
  bool isCompleted;

  Task({
    required this.title,
    this.deadline,
    this.priority = 2,
    this.isCompleted = false,
  });
}
