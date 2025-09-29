class Task {
  int? id;
  String title;
  DateTime? deadline;
  int priority; // 1 = High, 2 = Medium, 3 = Low
  bool isCompleted;
  int userId;

  Task({
    this.id,
    required this.title,
    this.deadline,
    this.priority = 2,
    this.isCompleted = false,
    required this.userId,
  });

  factory Task.fromJson(Map<String, dynamic> json, int apiUserId) {
    return Task(
      id: json['id'],
      title: json['todo'],
      isCompleted: json['completed'] ?? false,
      priority: 2,
      userId: apiUserId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'todo': title,
      'completed': isCompleted,
      'userId': userId,
    };
  }
}
