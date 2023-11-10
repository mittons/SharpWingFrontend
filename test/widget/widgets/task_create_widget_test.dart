import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharp_wing_frontend/widgets/task_create_widget.dart';
import 'package:sharp_wing_frontend/models/task.dart';

void main() {
  group('TaskCreateWidget Widget Tests', () {
    testWidgets('Expand/Collapse functionality works',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body:
              TaskCreateWidget(onCreateTask: (task) {}, currentParentTaskId: 1),
        ),
      ));

      // Widget should start out in collapsed mode
      expect(find.byType(Form), findsNothing);

      await tester.tap(find.text("Create a New Task"));
      await tester.pump();

      // Widget should expand when we click the header text
      expect(find.byType(Form), findsOneWidget);

      await tester.tap(find.text("Create a New Task"));
      await tester.pump();

      // Widget should collapse when we click the header text again
      expect(find.byType(Form), findsNothing);
    });

    testWidgets('Input data and create task works',
        (WidgetTester tester) async {
      //test with name input and no description
      //test with name input and a description
      //test with all types of lifecycle types

      Task? createdTask;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TaskCreateWidget(
              onCreateTask: (task) {
                createdTask = task;
              },
              currentParentTaskId: 1),
        ),
      ));

      // Expand the form
      await tester.tap(find.text("Create a New Task"));
      await tester.pump();

      // Fill in the form
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Task Name'), 'Test Task');
      await tester.enterText(
          find.widgetWithText(TextField, 'Description'), 'Test Description');

      // Submit the form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Task'));
      await tester.pump();

      // Verify the task is created
      expect(createdTask!.taskName, 'Test Task');
      expect(createdTask!.description, 'Test Description');
    });

    testWidgets('Input validation works', (WidgetTester tester) async {
      //submit without inputs
      //test if it gets blocked
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body:
              TaskCreateWidget(onCreateTask: (task) {}, currentParentTaskId: 1),
        ),
      ));

      // Expand the form
      await tester.tap(find.text("Create a New Task"));
      await tester.pump();

      // Submit the form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Task'));
      await tester.pump();

      // Verify validation error is shown
      expect(find.text('Task Name is required'), findsOneWidget);
    });
  });
}
