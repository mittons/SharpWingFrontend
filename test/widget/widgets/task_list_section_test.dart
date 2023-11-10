import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharp_wing_frontend/widgets/task_list_item.dart';
import 'package:sharp_wing_frontend/widgets/task_list_section.dart';
import 'package:sharp_wing_frontend/models/task.dart';

import '../../mock/mock_task_data_layer.dart';

void main() {
  group('TaskListSection Widget Tests', () {
    testWidgets('TaskListSection displays correct title - Setup',
        (WidgetTester tester) async {
      checkForLifecycleHeader(TaskLifecycleType.Setup, tester);
    });

    testWidgets('TaskListSection displays correct title - AdHoc',
        (WidgetTester tester) async {
      checkForLifecycleHeader(TaskLifecycleType.AdHoc, tester);
    });

    testWidgets('TaskListSection displays correct title - Closure',
        (WidgetTester tester) async {
      checkForLifecycleHeader(TaskLifecycleType.Closure, tester);
    });

    testWidgets('TaskListSection displays correct title - Recurring',
        (WidgetTester tester) async {
      checkForLifecycleHeader(TaskLifecycleType.Recurring, tester);
    });

    testWidgets('TaskListSection expands and collapses',
        (WidgetTester tester) async {
      // Create a list of dummy tasks
      final tasks = List.generate(
          3,
          (index) => Task(
              taskId: index + 1,
              taskName: 'Task ${index + 1}',
              parentId: 0,
              description: 'Task description ${index + 2}',
              createdDate: DateTime.now(),
              status: 'not completed',
              taskLifecycleType: TaskLifecycleType.AdHoc));

      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskListSection(
              lifecycleType: TaskLifecycleType.AdHoc,
              tasks: tasks,
              onEdit: (_) {},
              onDelete: (_) {},
              onCheckboxToggle: (_, __) {},
              onTap: (_) {},
            ),
          ),
        ),
      );

      // Verify initially that TaskListItems are shown.
      expect(find.byType(TaskListItem), findsNWidgets(tasks.length));

      String expectedLifecycleTypeHeader =
          "${TaskLifecycleType.AdHoc.toString().split('.').last} Tasks";

      // Tap on ListTile to collapse the TaskListSection
      await tester.tap(find.text(expectedLifecycleTypeHeader));
      await tester.pumpAndSettle();

      // Verify that TaskListItems are not shown after collapse.
      expect(find.byType(TaskListItem), findsNothing);

      // Tap on ListTile to expand the TaskListSection
      await tester.tap(find.text(expectedLifecycleTypeHeader));
      await tester.pumpAndSettle();

      // Verify that TaskListItems are shown after expansion.
      expect(find.byType(TaskListItem), findsNWidgets(tasks.length));
    });
  });
}

Future<void> checkForLifecycleHeader(
    TaskLifecycleType currLifecycleType, WidgetTester tester) async {
  MockTaskDataLayer mockTaskDataLayer = MockTaskDataLayer();
  List<Task> testTasks = mockTaskDataLayer
      .getAllTasks()
      .where((task) => task.taskLifecycleType == currLifecycleType)
      .toList();
  if (testTasks.length >= 4) {
    testTasks = testTasks.sublist(0, 4);
  }

  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: TaskListSection(
        lifecycleType: currLifecycleType,
        tasks: testTasks,
        onEdit: (editTask) {},
        onDelete: (taskToDelete) {},
        onCheckboxToggle: (taskToUpdate, newValue) {},
        onTap: (selectedTask) {},
      ),
    ),
  ));

  String expectedLifecycleTypeHeader =
      "${currLifecycleType.toString().split('.').last} Tasks";

  expect(find.text(expectedLifecycleTypeHeader), findsOneWidget);
}
