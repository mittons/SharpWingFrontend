// lib/models/task.dart

class Task {
  final int taskId;
  final String taskName;
  final String description;
  final DateTime createdDate;
  final DateTime dueDate;
  String status;
  final String priority;

  Task({
    required this.taskId,
    required this.taskName,
    required this.description,
    required this.createdDate,
    required this.dueDate,
    required this.status,
    required this.priority,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      taskName: json['taskName'],
      description: json['description'],
      createdDate: DateTime.parse(json['createdDate']),
      dueDate: DateTime.parse(json['dueDate']),
      status: json['status'],
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'taskId': taskId,
    'taskName': taskName,
    'description': description,
    'createdDate': createdDate.toIso8601String(),
    'dueDate': dueDate.toIso8601String(),
    'status': status,
    'priority': priority,
  };
}

}
