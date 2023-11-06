// lib/models/task.dart

// ignore_for_file: constant_identifier_names

enum TaskLifecycleType { Setup, Recurring, Closure, AdHoc }

class Task {
  int taskId;
  int? parentId;
  String taskName;
  String description;
  DateTime createdDate;
  String status;
  TaskLifecycleType taskLifecycleType;

  Task({
    required this.taskId,
    required this.parentId,
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
