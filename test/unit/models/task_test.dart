import 'package:flutter_test/flutter_test.dart';
import 'package:sharp_wing_frontend/models/task.dart';

void main() {
  group('Task Unit Tests', () {
    const int taskId0 = 0;
    const int? parentId0 = null;

    const int taskId1 = 1;
    const int? parentId1 = 0;
    const String taskName = "Sample task";
    const String description = "Sample description";
    DateTime createdDate = DateTime.now();
    const String status = "not completed";
    const TaskLifecycleType taskLifecycleType = TaskLifecycleType.AdHoc;

    test('Task should create a valid task object', () {
      final rootTask = Task(
        taskId: taskId0,
        parentId: parentId0,
        taskName: taskName,
        description: description,
        createdDate: createdDate,
        status: status,
        taskLifecycleType: taskLifecycleType,
      );

      final task1 = Task(
        taskId: taskId1,
        parentId: parentId1,
        taskName: taskName,
        description: description,
        createdDate: createdDate,
        status: status,
        taskLifecycleType: taskLifecycleType,
      );

      expect(rootTask.taskId, 0);
      expect(rootTask.parentId, null);

      expect(task1.taskId, taskId1);
      expect(task1.parentId, parentId1);
      expect(task1.taskName, taskName);
      expect(task1.description, description);
      expect(task1.createdDate, createdDate);
      expect(task1.status, status);
      expect(task1.taskLifecycleType, taskLifecycleType);
    });

    test('can be serialized to JSON', () {
      final Task task = Task(
        taskId: taskId1,
        parentId: parentId1,
        taskName: taskName,
        description: description,
        createdDate: createdDate,
        status: status,
        taskLifecycleType: taskLifecycleType,
      );

      final Map<String, dynamic> json = task.toJson();

      expect(json, {
        'taskId': taskId1,
        'parentId': parentId1,
        'taskName': taskName,
        'description': description,
        'createdDate': createdDate.toIso8601String(),
        'status': status,
        'taskLifecycleType': taskLifecycleType.index,
      });
    });

    test('can be created from JSON', () {
      final Map<String, dynamic> json = {
        'taskId': taskId1,
        'parentId': parentId1,
        'taskName': taskName,
        'description': description,
        'createdDate': createdDate.toIso8601String(),
        'status': status,
        'taskLifecycleType': taskLifecycleType.index,
      };

      final Task task = Task.fromJson(json);
      expect(task.taskId, taskId1);
      expect(task.parentId, parentId1);
      expect(task.taskName, taskName);
      expect(task.description, description);
      expect(task.createdDate, createdDate);
      expect(task.status, status);
      expect(task.taskLifecycleType, taskLifecycleType);
    });
  });
}
