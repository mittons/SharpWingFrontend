// lib/models/task.dart

enum TaskLifecycleType { Setup, Recurring, Closure, AdHoc }

class Task {
  final int taskId;
  final String taskName;
  final String description;
  final DateTime createdDate;
  String status;
  final TaskLifecycleType taskLifecycleType;

  Task({
    required this.taskId,
    required this.taskName,
    required this.description,
    required this.createdDate,
    required this.status,
    required this.taskLifecycleType,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      taskName: json['taskName'],
      description: json['description'],
      createdDate: DateTime.parse(json['createdDate']),
      status: json['status'],
      taskLifecycleType:
          TaskLifecycleType.values[json['taskLifecycleType'] as int],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'taskName': taskName,
      'description': description,
      'createdDate': createdDate.toIso8601String(),
      'status': status,
      'taskLifecycleType': taskLifecycleType.index,
    };
  }
}
