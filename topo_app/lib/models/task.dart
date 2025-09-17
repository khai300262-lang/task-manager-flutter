class Task {
  String title;
  bool isDone;
  DateTime? deadline;

  Task({
    required this.title,
    this.isDone = false,
    this.deadline}
      );
}
