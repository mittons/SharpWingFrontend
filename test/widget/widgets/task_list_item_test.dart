import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharp_wing_frontend/widgets/task_list_item.dart';

import '../../mock/mock_task_data_layer.dart';
import 'package:sharp_wing_frontend/models/task.dart';

void main() {
  group('TaskListItem Widget Tests', () {
    MockTaskDataLayer mockTaskDataLayer = MockTaskDataLayer();
    Task currentTask = mockTaskDataLayer.getTaskById(1)!;

    String testTaskName = "TaskName123123";
    String testTaskDescription = "description123123";

    currentTask.taskName = testTaskName;
    currentTask.description = testTaskDescription;

    testWidgets('TaskListItem contains all elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskListItem(
              task: currentTask,
              onCheckboxToggle: (taskToUpdate, newValue) {},
              onDelete: (taskToDelete) {},
              onEdit: (editTask) {},
              onTap: (tappedTask) {},
            ),
          ),
        ),
      );
      expect(find.widgetWithIcon(IconButton, Icons.edit), findsOneWidget);

      expect(find.widgetWithIcon(IconButton, Icons.delete), findsOneWidget);

      expect(find.byType(Checkbox), findsOneWidget);

      testForTaskListItemColor(tester, Colors.white);
    });

    testWidgets(
        'TaskListItem displays the task\'s current name and description',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskListItem(
              task: currentTask,
              onCheckboxToggle: (taskToUpdate, newValue) {},
              onDelete: (taskToDelete) {},
              onEdit: (editTask) {},
              onTap: (tappedTask) {},
            ),
          ),
        ),
      );

      expect(find.text(testTaskName), findsOneWidget);
      expect(find.text(testTaskDescription), findsOneWidget);
    });

    testWidgets('TaskListItem callback handlers work',
        (WidgetTester tester) async {
      bool deleteTapped = false;
      bool editTapped = false;
      bool taskTapped = false;

      await tester.pumpWidget(
        StatefulBuilder(builder: (context, setState) {
          return MaterialApp(
            home: Scaffold(
              body: TaskListItem(
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
                onTap: (tappedTask) {
                  taskTapped = true;
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

      expect(taskTapped, false);
      await tester.tap(find.byType(TaskListItem));
      await tester.pump();
      expect(taskTapped, true);
    });
  });
}

void testForTaskListItemColor(WidgetTester tester, Color testColor) {
  final Finder containerFinder = find.descendant(
    of: find.byType(Card),
    matching: find.byWidgetPredicate(
      (Widget widget) => widget is Container && widget.child is ListTile,
    ),
  );
  final Container container = tester.widget<Container>(containerFinder);

  expect(container.color, equals(testColor));
}
