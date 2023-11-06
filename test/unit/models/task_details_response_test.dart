import 'package:flutter_test/flutter_test.dart';
import 'package:sharp_wing_frontend/models/task_details_response.dart';
import 'package:sharp_wing_frontend/models/task.dart';

void main() {
  group('TaskDetailsResponse Unit Tests - Simple', () {
    test('fromJson creates correct TaskDetailsResponse', () {
      // Mock JSON data
      final Map<String, dynamic> mockJson = {
        'currentTask': {
          'taskId': 1,
          'parentId': null,
          'taskName': 'Test Task',
          'description': 'This is a test task',
          'createdDate': DateTime.now().toIso8601String(),
          'status': 'not completed',
          'taskLifecycleType': 0,
        },
        'subTasks': [],
        'pathEnumeration': [],
      };

      // Using fromJson to create a TaskDetailsResponse instance
      final result = TaskDetailsResponse.fromJson(mockJson);

      // Asserts to ensure the deserialization worked as expected
      expect(result.currentTask.taskId, 1);
      expect(result.currentTask.taskName, 'Test Task');
      expect(result.subTasks, isEmpty);
      expect(result.pathEnumeration, isEmpty);
    });
  });

  //Each test uses the _getMockJsonForDateValidation function to generate
  //  valid/invalid data.
  group('TaskDetailsResponse - handling of valid/invalid date formats', () {
    test('fromJson creates TaskDetailsResponse on valid date data', () {
      // Mock JSON data using dynamic mock data generation function without any invalid date data.
      final Map<String, dynamic> mockJson = _getMockJsonForDateValidation(
          useInvalidCurrentTask: false,
          useInvalidSubTask: false,
          useInvalidPathEnumerationTask: false);

      // Using fromJson to create a TaskDetailsResponse instance
      final result = TaskDetailsResponse.fromJson(mockJson);

      // Asserts to ensure the deserialization worked as expected
      expect(result.currentTask, isInstanceOf<Task>());
      expect(result.subTasks.length, 2);
      expect(result.pathEnumeration.length, 2);
    });

    test('fromJson throws error on invalid current task date data', () {
      // Mock JSON data using dynamic mock data generation function with invalid current task data.
      final Map<String, dynamic> mockJson = _getMockJsonForDateValidation(
          useInvalidCurrentTask: true,
          useInvalidSubTask: false,
          useInvalidPathEnumerationTask: false);

      expect(
          () => TaskDetailsResponse.fromJson(mockJson), throwsFormatException);
    });

    test('fromJson throws error on invalid subtask date data', () {
      // Mock JSON data using dynamic mock data generation function with invalid subtask data.
      final Map<String, dynamic> mockJson = _getMockJsonForDateValidation(
          useInvalidCurrentTask: false,
          useInvalidSubTask: true,
          useInvalidPathEnumerationTask: false);

      expect(
          () => TaskDetailsResponse.fromJson(mockJson), throwsFormatException);
    });

    test('fromJson throws error on invalid path enumeration task date data',
        () {
      // Mock JSON data using dynamic mock data generation function with invalid path enumeration task data.
      final Map<String, dynamic> mockJson = _getMockJsonForDateValidation(
          useInvalidCurrentTask: false,
          useInvalidSubTask: false,
          useInvalidPathEnumerationTask: true);

      expect(
          () => TaskDetailsResponse.fromJson(mockJson), throwsFormatException);
    });
  });

  //Each test uses the _getMockJsonForLifeCycleTypeValidation function to generate
  //  valid/invalid data.
  group('TaskDetailsResponse - handling of valid/invalid LifeCycleType values',
      () {
    test('fromJson creates TaskDetailsResponse on valid LifeCycleTypeData', () {
      // Mock JSON data using dynamic mock data generation function without any invalid data.
      final Map<String, dynamic> mockJson =
          _getMockJsonForLifeCycleTypeValidation(
              useInvalidCurrentTask: false,
              useInvalidSubTask: false,
              useInvalidPathEnumerationTask: false);

      // Using fromJson to create a TaskDetailsResponse instance
      final result = TaskDetailsResponse.fromJson(mockJson);

      // Asserts to ensure the deserialization worked as expected
      expect(result.currentTask, isInstanceOf<Task>());
      expect(result.subTasks.length, 2);
      expect(result.pathEnumeration.length, 2);
    });

    test('fromJson throws error on invalid current task LifeCycleType data',
        () {
      // Mock JSON data using dynamic mock data generation function with invalid current task data.
      final Map<String, dynamic> mockJson =
          _getMockJsonForLifeCycleTypeValidation(
              useInvalidCurrentTask: true,
              useInvalidSubTask: false,
              useInvalidPathEnumerationTask: false);

      expect(() => TaskDetailsResponse.fromJson(mockJson), throwsRangeError);
    });

    test('fromJson throws error on invalid subtask LifeCycleType data', () {
      // Mock JSON data using dynamic mock data generation function with invalid subtask data.
      final Map<String, dynamic> mockJson =
          _getMockJsonForLifeCycleTypeValidation(
              useInvalidCurrentTask: false,
              useInvalidSubTask: true,
              useInvalidPathEnumerationTask: false);

      expect(() => TaskDetailsResponse.fromJson(mockJson), throwsRangeError);
    });

    test(
        'fromJson throws error on invalid path enumeration LifeCycleType date data',
        () {
      // Mock JSON data using dynamic mock data generation function with invalid path enumeration task data.
      final Map<String, dynamic> mockJson =
          _getMockJsonForLifeCycleTypeValidation(
              useInvalidCurrentTask: false,
              useInvalidSubTask: false,
              useInvalidPathEnumerationTask: true);

      expect(() => TaskDetailsResponse.fromJson(mockJson), throwsRangeError);
    });
  });
}

Map<String, dynamic> _getMockJsonForDateValidation(
    {required bool useInvalidCurrentTask,
    required bool useInvalidSubTask,
    required bool useInvalidPathEnumerationTask}) {
  String createDateCurrentTask =
      useInvalidCurrentTask ? "abc" : DateTime.now().toIso8601String();
  String createDateSubtask0 =
      useInvalidSubTask ? "abc" : DateTime.now().toIso8601String();
  String createDateEnumerationPathTask0 =
      useInvalidPathEnumerationTask ? "abc" : DateTime.now().toIso8601String();

  final Map<String, dynamic> mockJson = {
    'currentTask': {
      'taskId': 2,
      'parentId': 1,
      'taskName': 'Test Task',
      'description': 'This is a test task',
      'createdDate': createDateCurrentTask,
      'status': 'not completed',
      'taskLifecycleType': 0,
    },
    'subTasks': [
      // Adding first sub-task
      {
        'taskId': 3,
        'parentId': 2,
        'taskName': 'Sub Task 1',
        'description': 'This is the first sub-task',
        'createdDate': createDateSubtask0,
        'status': 'not completed',
        'taskLifecycleType': 0,
      },
      // Adding second sub-task
      {
        'taskId': 4,
        'parentId': 2,
        'taskName': 'Sub Task 2',
        'description': 'This is the second sub-task',
        'createdDate': DateTime.now().toIso8601String(),
        'status': 'not completed',
        'taskLifecycleType': 0,
      }
    ],
    'pathEnumeration': [
      // Adding first path enumeration task
      {
        'taskId': 0,
        'parentId': null,
        'taskName': 'Path Task 1',
        'description': 'This is the first path enumeration task',
        'createdDate':
            createDateEnumerationPathTask0, // Example date in YYYY-MM-DD format
        'status': 'not completed',
        'taskLifecycleType': 0,
      },
      // Adding second path enumeration
      {
        'taskId': 1,
        'parentId': 0,
        'taskName': 'Path Task 2',
        'description': 'This is the second path enumeration task',
        'createdDate': DateTime.now()
            .toIso8601String(), // Example date in YYYY-MM-DD format
        'status': 'not completed',
        'taskLifecycleType': 0,
      }
    ],
  };

  return mockJson;
}

Map<String, dynamic> _getMockJsonForLifeCycleTypeValidation(
    {required bool useInvalidCurrentTask,
    required bool useInvalidSubTask,
    required bool useInvalidPathEnumerationTask}) {
  int lcTypeCurrentTask = useInvalidCurrentTask ? 4 : 0;
  int lcTypeSubtask0 = useInvalidSubTask ? 4 : 0;
  int lcTypeEnumerationPathTask0 = useInvalidPathEnumerationTask ? 4 : 0;

  final Map<String, dynamic> mockJson = {
    'currentTask': {
      'taskId': 2,
      'parentId': 1,
      'taskName': 'Test Task',
      'description': 'This is a test task',
      'createdDate': DateTime.now().toIso8601String(),
      'status': 'not completed',
      'taskLifecycleType': lcTypeCurrentTask,
    },
    'subTasks': [
      // Adding first sub-task
      {
        'taskId': 3,
        'parentId': 2,
        'taskName': 'Sub Task 1',
        'description': 'This is the first sub-task',
        'createdDate': DateTime.now().toIso8601String(),
        'status': 'not completed',
        'taskLifecycleType': lcTypeSubtask0,
      },
      // Adding second sub-task
      {
        'taskId': 4,
        'parentId': 2,
        'taskName': 'Sub Task 2',
        'description': 'This is the second sub-task',
        'createdDate': DateTime.now().toIso8601String(),
        'status': 'not completed',
        'taskLifecycleType': 0,
      }
    ],
    'pathEnumeration': [
      // Adding first path enumeration task
      {
        'taskId': 0,
        'parentId': null,
        'taskName': 'Path Task 1',
        'description': 'This is the first path enumeration task',
        'createdDate': DateTime.now()
            .toIso8601String(), // Example date in YYYY-MM-DD format
        'status': 'not completed',
        'taskLifecycleType': lcTypeEnumerationPathTask0,
      },
      // Adding second path enumeration
      {
        'taskId': 1,
        'parentId': 0,
        'taskName': 'Path Task 2',
        'description': 'This is the second path enumeration task',
        'createdDate': DateTime.now()
            .toIso8601String(), // Example date in YYYY-MM-DD format
        'status': 'not completed',
        'taskLifecycleType': 0,
      }
    ],
  };

  return mockJson;
}
