import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharp_wing_frontend/config/config.dart';
import 'package:sharp_wing_frontend/screens/task_edit_screen.dart';
import 'package:sharp_wing_frontend/models/task.dart';

import 'package:sharp_wing_frontend/services/task_service.dart';
import 'package:sharp_wing_frontend/services/task_service_result.dart';
import '../../mock/mock_task_data_layer.dart';
import '../../mock/mock_task_service.dart';

import 'package:mockito/mockito.dart';

// Create a MockNavigatorObserver class for navigation testing.
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('TaskEditScreen Widget Tests', () {
    AppConfig appConfig = TestConfig();
    MockTaskService mockTaskService =
        MockTaskService(baseApiUrl: appConfig.baseApiUrl);

    MockTaskDataLayer mockTaskDataLayer = MockTaskDataLayer();
    Task testTask = mockTaskDataLayer.getTaskById(1)!;

    tearDown(() => {
          mockTaskService.onCreateTask = null,
          mockTaskService.onDeleteTask = null,
          mockTaskService.onGetAllTasks = null,
          mockTaskService.onGetRootTask = null,
          mockTaskService.onGetTaskById = null,
          mockTaskService.onGetTaskDetails = null,
          mockTaskService.onUpdateTask = null,
        });

    testWidgets('TaskEditScreen contains all elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TaskEditScreen(
          task: testTask,
          onSave: (Task updatedTask) {},
          taskService: mockTaskService,
        ),
      ));

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Edit Task'), findsOneWidget);
      expect(find.text('Task Name'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);
    });

    testWidgets('TextFields display the task\'s current name and description',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: TaskEditScreen(
          task: testTask,
          onSave: (Task updatedTask) {},
          taskService: mockTaskService,
        ),
      ));

      // We use the 'find' method to locate the TextFields on the screen.
      final Finder taskNameField = find.byWidgetPredicate(
        (Widget widget) =>
            widget is TextField && widget.controller?.text == testTask.taskName,
      );
      final Finder descriptionField = find.byWidgetPredicate(
        (Widget widget) =>
            widget is TextField &&
            widget.controller?.text == testTask.description,
      );

      // Verify that the TextFields contain the initial values.
      expect(taskNameField, findsOneWidget);
      expect(descriptionField, findsOneWidget);
    });

    testWidgets('Entering text updates TextEditingControllers',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: TaskEditScreen(
          task: testTask,
          onSave: (Task updatedTask) {},
          taskService: mockTaskService,
        ),
      ));

      // Define text fields keys
      const Key taskNameKey = Key('taskNameEditField');
      const Key descriptionKey = Key('taskDescriptionEditField');

      String updatedTaskNameText = 'Updated Task Name Test';
      String updatedTaskDescriptionText = 'Updated Description Test';

      // Enter new text into the text fields.
      await tester.enterText(find.byKey(taskNameKey), updatedTaskNameText);
      await tester.enterText(
          find.byKey(descriptionKey), updatedTaskDescriptionText);
      await tester.pump(); // Rebuild the widget after the state has changed.

      // Retrieve the text from the TextFields
      final TextField taskNameField = tester.widget(find.byKey(taskNameKey));
      final TextField descriptionField =
          tester.widget(find.byKey(descriptionKey));

      // Verify that the TextFields contain the initial values.
      expect(find.byKey(taskNameKey), findsOneWidget);
      expect(find.byKey(descriptionKey), findsOneWidget);

      // Check if the TextEditingControllers' text matches the entered text
      expect(taskNameField.controller!.text, equals(updatedTaskNameText));
      expect(descriptionField.controller!.text,
          equals(updatedTaskDescriptionText));
    });

    // Tests whether the onSave callback and the TaskService both receive the updated task with correct values
    testWidgets(
        'Entering text in TextFields and pressing save updates the task',
        (WidgetTester tester) async {
      // Define text to update the task with and test for.
      String updatedTaskNameText = 'Updated Task Name Test';
      String updatedTaskDescriptionText = 'Updated Description Test';

      // Expect the task services receives the updated task
      mockTaskService.onUpdateTask = (res, updatedTask) {
        // Assert updated values are changed
        expect(updatedTask.taskName, updatedTaskNameText);
        expect(updatedTask.description, updatedTaskDescriptionText);

        // Assert values that dont get updated stay the same
        expect(updatedTask.taskId, testTask.taskId);
        expect(updatedTask.parentId, testTask.parentId);
        expect(updatedTask.createdDate, testTask.createdDate);
        expect(updatedTask.status, testTask.status);
        expect(updatedTask.taskLifecycleType, testTask.taskLifecycleType);
        return res;
      };

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: TaskEditScreen(
          task: testTask,
          // Assert the callback handler receives the updated task
          onSave: (Task updatedTask) {
            // Assert updated values are changed
            expect(updatedTask.taskName, updatedTaskNameText);
            expect(updatedTask.description, updatedTaskDescriptionText);

            // Assert values that dont get updated stay the same
            expect(updatedTask.taskId, testTask.taskId);
            expect(updatedTask.parentId, testTask.parentId);
            expect(updatedTask.createdDate, testTask.createdDate);
            expect(updatedTask.status, testTask.status);
            expect(updatedTask.taskLifecycleType, testTask.taskLifecycleType);
          },
          taskService: mockTaskService,
        ),
      ));

      // Define text fields keys
      const Key taskNameKey = Key('taskNameEditField');
      const Key descriptionKey = Key('taskDescriptionEditField');

      // Enter new text into the text fields.
      await tester.enterText(find.byKey(taskNameKey), updatedTaskNameText);
      await tester.enterText(
          find.byKey(descriptionKey), updatedTaskDescriptionText);
      await tester.pump(); // Rebuild the widget after the state has changed.

      // Tap the save button.
      await tester.tap(find.byType(ElevatedButton));

      await tester.pump(); // Rebuild the widget after the state has changed.
      // The onTaskUpdate and onSave functions defined at the start of this function
      // should be triggered after this pump.

      // Clean up the mockTaskService
      mockTaskService.onUpdateTask = null;
    });

    testWidgets(
        'Getting unsuccessful update message from TaskService displays snackbar',
        (WidgetTester tester) async {
      // Set the task service to return unsuccessful task update
      mockTaskService.onUpdateTask = (res, updatedTask) {
        return TaskServiceResult(data: null, success: false);
      };

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: TaskEditScreen(
          task: testTask,
          onSave: (Task updatedTask) {},
          taskService: mockTaskService,
        ),
      ));

      // Define text field keys
      const Key taskNameKey = Key('taskNameEditField');
      const Key descriptionKey = Key('taskDescriptionEditField');

      // Enter new text into the text fields.
      await tester.enterText(find.byKey(taskNameKey), "Updated task name");
      await tester.enterText(
          find.byKey(descriptionKey), "Updated task description");
      await tester.pump(); // Rebuild the widget after the state has changed.

      // The user error snackbar should not be visible right now.
      expect(find.byType(SnackBar), findsNothing);

      // Tap the save button.
      await tester.tap(find.byType(ElevatedButton));

      await tester.pump(); //Rebuild the widget after the state has changed.

      // The user error snackbar should be visible right now.
      expect(find.byType(SnackBar), findsOneWidget);
      // This should be the text in the user error snackbar.
      expect(
          find.text("Failed to update task. Service error."), findsOneWidget);

      // Clean up the mockTaskService
      mockTaskService.onUpdateTask = null;
    });

    testWidgets('Navigator pops on successful update',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();

      // Build the navigation route
      final route = MaterialPageRoute(
        builder: (context) => TaskEditScreen(
          task: testTask,
          onSave: (Task updatedTask) {},
          taskService: mockTaskService,
        ),
      );

      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            observers: [mockObserver],
            onGenerateRoute: (RouteSettings settings) {
              return route;
            },
          ),
        ),
      );

      // Define text fields keys
      const Key taskNameKey = Key('taskNameEditField');
      const Key descriptionKey = Key('taskDescriptionEditField');

      // Enter new text into the text fields.
      await tester.enterText(find.byKey(taskNameKey), 'Updated Task Name Test');
      await tester.enterText(
          find.byKey(descriptionKey), 'Updated Description Test');
      await tester.pump(); // Rebuild the widget after the state has changed.

      // Tap the save button.
      await tester.tap(find.byType(ElevatedButton));

      await tester.pump(); //Rebuild the widget after the state has changed.

      verify(mockObserver.didPop(route, any)).called(1);
    });

    testWidgets(
        'Navigator doesn\'t pop on unsuccessful update call to TaskService',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();

      mockTaskService.onUpdateTask = (res, updatedTask) {
        return TaskServiceResult(data: null, success: false);
      };

      // Build the navigation route
      final route = MaterialPageRoute(
        builder: (context) => TaskEditScreen(
          task: testTask,
          onSave: (Task updatedTask) {},
          taskService: mockTaskService,
        ),
      );

      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            observers: [mockObserver],
            onGenerateRoute: (RouteSettings settings) {
              return route;
            },
          ),
        ),
      );

      // Define text fields keys
      const Key taskNameKey = Key('taskNameEditField');
      const Key descriptionKey = Key('taskDescriptionEditField');

      // Enter new text into the text fields.
      await tester.enterText(find.byKey(taskNameKey), 'Updated Task Name Test');
      await tester.enterText(
          find.byKey(descriptionKey), 'Updated Description Test');
      await tester.pump(); // Rebuild the widget after the state has changed.

      // Tap the save button.
      await tester.tap(find.byType(ElevatedButton));

      await tester.pump(); //Rebuild the widget after the state has changed.

      verifyNever(mockObserver.didPop(route, any));
    });
  });
}
