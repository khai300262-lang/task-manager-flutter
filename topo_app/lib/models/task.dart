enum Priority{
  low,
  medium,
  high,
}
class Task {
  String title;
  bool isDone;
  DateTime? deadline;
  Priority priority;


  Task({
    required this.title,
    this.isDone = false,
    this.deadline,
    this.priority = Priority.low,

  }
      );
}
