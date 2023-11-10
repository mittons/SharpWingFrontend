import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharp_wing_frontend/widgets/current_task_item.dart';

import '../../mock/mock_task_data_layer.dart';
import 'package:sharp_wing_frontend/models/task.dart';

void main() {
  group('CurrentTaskItem Widget Tests - Non root task', () {
    MockTaskDataLayer mockTaskDataLayer = MockTaskDataLayer();
    Task currentTask = mockTaskDataLayer.getTaskById(1)!;

    String testTaskName = "TaskName123123";
    String testTaskDescription = "description123123";

    currentTask.taskName = testTaskName;
    currentTask.description = testTaskDescription;

    testWidgets('CurrentTaskItem contains all elements - non root',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrentTaskItem(
              task: currentTask,
              onCheckboxToggle: (taskToUpdate, newValue) {},
              onDelete: (taskToDelete) {},
              onEdit: (editTask) {},
              onBackPressed: () {},
            ),
          ),
        ),
      );
      expect(find.widgetWithIcon(IconButton, Icons.edit), findsOneWidget);

      expect(find.widgetWithIcon(IconButton, Icons.delete), findsOneWidget);

      expect(find.widgetWithIcon(IconButton, Icons.turn_left), findsOneWidget);

      expect(find.byType(Checkbox), findsOneWidget);

      testForCurrentTaskItemColor(
          tester, const Color.fromRGBO(238, 238, 238, 1.0));
    });

    testWidgets(
        'CurrentTaskItem displays the task\'s current name and description - non root',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrentTaskItem(
              task: currentTask,
              onCheckboxToggle: (taskToUpdate, newValue) {},
              onDelete: (taskToDelete) {},
              onEdit: (editTask) {},
              onBackPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text(testTaskName), findsOneWidget);
      expect(find.text(testTaskDescription), findsOneWidget);
    });

    testWidgets('CurrentTaskItem callback handlers work - non root',
        (WidgetTester tester) async {
      bool deleteTapped = false;
      bool editTapped = false;
      bool onBackTapped = false;

      await tester.pumpWidget(
        StatefulBuilder(builder: (context, setState) {
          return MaterialApp(
            home: Scaffold(
              body: CurrentTaskItem(
                task: currentTask,
                onCheckboxToggle: (taskToUpdate, newValue) {
                  expect(taskToUpdate, currentTask);
                  expect(newValue, currentTask.status != 'completed');
                  setState(() {
                    currentTask.status =
                        (newValue! ? 'completed' : 'not completed');
                  });
                },
                onDelete: (taskToDelete) {
                  deleteTapped = true;
                },
                onEdit: (editTask) {
                  editTapped = true;
                },
                onBackPressed: () {
                  onBackTapped = true;
                },
              ),
            ),
          );
        }),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(deleteTapped, false);
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();
      expect(deleteTapped, true);

      expect(editTapped, false);
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();
      expect(editTapped, true);

      expect(onBackTapped, false);
      await tester.tap(find.byIcon(Icons.turn_left));
      await tester.pump();
      expect(onBackTapped, true);
    });
  });

  group('CurrentTaskItem Widget Tests - Root task', () {
    MockTaskDataLayer mockTaskDataLayer = MockTaskDataLayer();

    Task rootTask = mockTaskDataLayer.getTaskById(0)!;

    //ensure root task has no parentId, as this defines the root task.
    rootTask.parentId = null;

    String testTaskName = "Home123123";
    String testTaskDescription = "description123123";

    rootTask.taskName = testTaskName;
    rootTask.description = testTaskDescription;

    testWidgets('CurrentTaskItem contains all elements - root',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CurrentTaskItem(
            task: rootTask,
            onCheckboxToggle: (taskToUpdate, newValue) {},
            onBackPressed: () {},
            onDelete: (taskToDelete) {},
            onEdit: (editTask) {},
          ),
        ),
      ));

      expect(find.widgetWithIcon(IconButton, Icons.edit), findsOneWidget);

      // Delete button disabled for root task
      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.widgetWithIcon(IconButton, Icons.delete), findsNothing);

      // Back button disabled for root task
      expect(find.byIcon(Icons.turn_left), findsOneWidget);
      expect(find.widgetWithIcon(IconButton, Icons.turn_left), findsNothing);

      // No checkbox for root task
      expect(find.byType(Checkbox), findsNothing);

      testForCurrentTaskItemColor(
          tester, const Color.fromRGBO(238, 238, 238, 1.0));
    });

    testWidgets(
        'CurrentTaskItem displays the task\'s current name and description - root',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CurrentTaskItem(
            task: rootTask,
            onCheckboxToggle: (taskToUpdate, newValue) {},
            onBackPressed: () {},
            onDelete: (taskToDelete) {},
            onEdit: (editTask) {},
          ),
        ),
      ));

      expect(find.text(testTaskName), findsOneWidget);
      expect(find.text(testTaskDescription), findsOneWidget);
    });
  });
}

void testForCurrentTaskItemColor(WidgetTester tester, Color testColor) {
  final Finder containerFinder = find.descendant(
    of: find.byType(Card),
    matching: find.byWidgetPredicate(
      (Widget widget) => widget is Container && widget.child is ListTile,
    ),
  );
  final Container container = tester.widget<Container>(containerFinder);

  expect(container.color, equals(testColor));
}
