// lib/models/task.dart

// ignore_for_file: constant_identifier_names

enum TaskLifecycleType { Setup, Recurring, Closure, AdHoc }

class Task {
  final int taskId;
  final int? parentId;
  final String taskName;
  final String description;
  final DateTime createdDate;
  String status;
  final TaskLifecycleType taskLifecycleType;

  Task({
    required this.taskId,
    this.parentId,
    required this.taskName,
    required this.description,
    required this.createdDate,
    required this.status,
    required this.taskLifecycleType,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      parentId: json['parentId'],
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
      'parentId': parentId,
      'taskName': taskName,
      'description': description,
      'createdDate': createdDate.toIso8601String(),
      'status': status,
      'taskLifecycleType': taskLifecycleType.index,
    };
  }
}
