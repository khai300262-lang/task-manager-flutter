class ApiTodo {
  final int id;
  final int userId;
  final String todo;
  final bool completed;

  ApiTodo({
    required this.id,
    required this.userId,
    required this.todo,
    required this.completed,
  });

  factory ApiTodo.fromJson(Map<String, dynamic> json) {
    return ApiTodo(
      id: json['id'],
      userId: json['userId'],
      todo: json['todo'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'userId': userId, 'todo': todo, 'completed': completed};
  }
}
