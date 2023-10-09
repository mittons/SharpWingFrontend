// lib/models/task_details_response.dart

import 'package:sharp_wing_frontend/models/task.dart';

class TaskDetailsResponse {
  final Task currentTask;
  final List<Task> subTasks;
  final List<Task> pathEnumeration;

  TaskDetailsResponse({
    required this.currentTask,
    required this.subTasks,
    required this.pathEnumeration,
  });

  factory TaskDetailsResponse.fromJson(Map<String, dynamic> json) {
    return TaskDetailsResponse(
      currentTask: Task.fromJson(json['currentTask']),
      subTasks: (json['subTasks'] as List)
          .map((taskJson) => Task.fromJson(taskJson))
          .toList(),
      pathEnumeration: (json['pathEnumeration'] as List)
          .map((taskJson) => Task.fromJson(taskJson))
          .toList(),
    );
  }
}
