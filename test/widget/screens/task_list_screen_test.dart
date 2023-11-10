import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharp_wing_frontend/config/config.dart';
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/models/task_details_response.dart';
import 'package:sharp_wing_frontend/screens/task_list_screen.dart';
import 'package:sharp_wing_frontend/services/task_service_result.dart';
import 'package:sharp_wing_frontend/widgets/current_task_display.dart';
import 'package:sharp_wing_frontend/widgets/task_create_widget.dart';
import 'package:sharp_wing_frontend/widgets/task_list_section.dart';
import '../../mock/mock_task_service.dart';

void main() {
  group('TaskListScreen Widget Tests', () {
    AppConfig appConfig = TestConfig();
    var mockTaskService = MockTaskService(baseApiUrl: appConfig.baseApiUrl);

    tearDown(() => {
          mockTaskService.onCreateTask = null,
          mockTaskService.onDeleteTask = null,
          mockTaskService.onGetAllTasks = null,
          mockTaskService.onGetRootTask = null,
          mockTaskService.onGetTaskById = null,
          mockTaskService.onGetTaskDetails = null,
          mockTaskService.onUpdateTask = null,
        });

    testWidgets('TaskListScreen contains all elements',
        (WidgetTester tester) async {
      //Set the size of the screen so that all task list sections get loaded.
      tester.view.physicalSize = const Size(2000, 5000);

      await tester.pumpWidget(
          MaterialApp(home: TaskListScreen(taskService: mockTaskService)));

      // Loading indicator should display while awaiting for initial tasks from task service.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      // Loading indicator should be gone after awaiting for initial tasks from task service.
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Main layout elements should be visible at this point
      expect(find.byType(CurrentTaskDisplay), findsOneWidget);

      for (var type in TaskLifecycleType.values) {
        expect(
            find.byWidgetPredicate((widget) =>
                widget is TaskListSection && widget.lifecycleType == type),
            findsOneWidget,
            reason: 'Should find exactly one TaskListSection for $type');
      }

      expect(find.byType(TaskCreateWidget), findsOneWidget);

      //Reset physical size of tester after testing.
      tester.view.resetPhysicalSize();
    });

    testWidgets('TaskListScreen correctly categorizes tasks',
        (WidgetTester tester) async {
      // Set the size of the screen so that all task list sections get loaded.
      tester.view.physicalSize = const Size(2000, 5000);

      var allTasksResponse = await mockTaskService.getAllTasks();
      var allTasks = allTasksResponse.data as List<Task>;

      // Hijack the task details function in the mock task service
      //   Make it return two subtasks for each life cycle type.
      mockTaskService.onGetTaskDetails = (res, taskId) {
        TaskDetailsResponse response = res.data as TaskDetailsResponse;
        var allTasksButCurrent =
            allTasks.where((task) => taskId != response.currentTask.taskId);
        List<Task> twoOfEach = [];
        twoOfEach.addAll(allTasksButCurrent
            .where((task) => task.taskLifecycleType == TaskLifecycleType.Setup)
            .toList()
            .sublist(0, 2));
        twoOfEach.addAll(allTasksButCurrent
            .where(
                (task) => task.taskLifecycleType == TaskLifecycleType.Recurring)
            .toList()
            .sublist(0, 2));
        twoOfEach.addAll(allTasksButCurrent
            .where(
                (task) => task.taskLifecycleType == TaskLifecycleType.Closure)
            .toList()
            .sublist(0, 2));
        twoOfEach.addAll(allTasksButCurrent
            .where((task) => task.taskLifecycleType == TaskLifecycleType.AdHoc)
            .toList()
            .sublist(0, 2));

        return TaskServiceResult(
          data: TaskDetailsResponse(
              currentTask: response.currentTask,
              subTasks: twoOfEach,
              pathEnumeration: response.pathEnumeration),
          success: true,
        );
      };

      await tester.pumpWidget(
          MaterialApp(home: TaskListScreen(taskService: mockTaskService)));

      await tester.pumpAndSettle();

      for (var type in TaskLifecycleType.values) {
        expect(
            find.byWidgetPredicate((widget) =>
                widget is TaskListSection && widget.lifecycleType == type),
            findsOneWidget,
            reason: 'Should find exactly one TaskListSection for $type');
        Finder sectionByTypeFinder = find.byWidgetPredicate((widget) =>
            widget is TaskListSection && widget.lifecycleType == type);
        TaskListSection typeSection =
            tester.widget<TaskListSection>(sectionByTypeFinder);
        for (Task sectionTask in typeSection.tasks) {
          expect(sectionTask.taskLifecycleType, type);
        }
      }
      // Reset physical size of tester after testing.
      tester.view.resetPhysicalSize();
    });

    testWidgets('TaskListScreen shows error message on service call failure',
        (WidgetTester tester) async {
      TaskServiceResult? rootRes;
      TaskServiceResult? taskDetailsRes;
      // Mock the task service to simulate a failure response for getting root task and task details.
      mockTaskService.onGetRootTask = (res) {
        rootRes = res;
        return TaskServiceResult(data: null, success: false);
      };
      mockTaskService.onGetTaskDetails = (res, taskId) {
        taskDetailsRes = res;
        return TaskServiceResult(data: null, success: false);
      };

      // Build our app and trigger a frame.
      await tester.pumpWidget(
          MaterialApp(home: TaskListScreen(taskService: mockTaskService)));

      // Verify that a loading indicator is shown first.
      // The user error alert dialog should not be visible right now.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);

      // Trigger a frame to simulate the task service returning the unsuccessful root task result.
      await tester.pump();

      // The user error alert dialog should be visible right now.
      expect(find.byType(AlertDialog), findsOneWidget);
      // This should be the text in the user error AlertDialog.
      expect(find.text("Failed to load home task. Service error."),
          findsOneWidget);
      // Retry button should be visible
      expect(find.widgetWithText(TextButton, 'Retry'), findsOneWidget);

      // Promt a retry
      await tester.tap(find.widgetWithText(TextButton, 'Retry'));
      await tester.pump();

      // The user error alert dialog should be visible right now.
      expect(find.byType(AlertDialog), findsOneWidget);
      // This should be the text in the user error AlertDialog.
      expect(find.text("Failed to load home task. Service error."),
          findsOneWidget);

      // We change the mockservice so that it now returns the root task.
      // But it still returns unsuccessful on the task details call.
      mockTaskService.onGetRootTask = (res) {
        return rootRes!;
      };

      // Promt a retry
      await tester.tap(find.widgetWithText(TextButton, 'Retry'));
      await tester.pump();

      // The user error alert dialog should be visible right now.
      expect(find.byType(AlertDialog), findsOneWidget);
      // This should be the text in the user error AlertDialog.
      expect(find.text("Failed to load task list. Service error."),
          findsOneWidget);
      // Retry button should be visible
      expect(find.widgetWithText(TextButton, 'Retry'), findsOneWidget);
      // Promt a retry
      await tester.tap(find.widgetWithText(TextButton, 'Retry'));
      await tester.pump();

      // The user error alert dialog should be visible right now.
      expect(find.byType(AlertDialog), findsOneWidget);
      // This should be the text in the user error AlertDialog.
      expect(find.text("Failed to load task list. Service error."),
          findsOneWidget);

      // We change the mockservice so that it now returns the task details successfully.
      // The interface should now be able to continue to the default happy path initial state.
      mockTaskService.onGetTaskDetails = (res, taskId) {
        return taskDetailsRes;
      };

      // Promt a retry
      await tester.tap(find.widgetWithText(TextButton, 'Retry'));
      await tester.pump();

      // Verify that the loading indicator is gone.
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Verify that the basic interface elements are now displayed.
      expect(find.byType(CurrentTaskDisplay), findsOneWidget);
      expect(find.byType(TaskListSection), findsAtLeastNWidgets(1));
      expect(find.byType(TaskCreateWidget), findsOneWidget);
    });
  });
}
