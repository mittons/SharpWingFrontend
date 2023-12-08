import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharp_wing_frontend/config/config.dart';
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/models/task_details_response.dart';
import 'package:sharp_wing_frontend/screens/task_edit_screen.dart';
import 'package:sharp_wing_frontend/screens/task_list_screen.dart';
import 'package:sharp_wing_frontend/services/task_service.dart';
import 'package:sharp_wing_frontend/services/task_service_result.dart';
import 'package:sharp_wing_frontend/utils/service_locator.dart';
import 'package:sharp_wing_frontend/widgets/current_task_item.dart';
import 'package:sharp_wing_frontend/widgets/task_create_widget.dart';
import 'package:sharp_wing_frontend/widgets/task_list_item.dart';

import 'package:integration_test/integration_test.dart';

// import '../../test/mock/mock_task_service.dart';
import 'utils/docker_utils.dart' as dockerUtils;

import 'package:http/http.dart' as http;

void main() {
  group('TaskListScreen Integration Tests - Full sequence', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    // Get the app config for testing
    TestConfig config = TestConfig();

    /// Tests a full range of CRUD actions along with navigation inside the [TaskListScreen] screen to the [TaskEditScreen] subwindow.
    testWidgets(
        'Test full crud and navigation - TaskService and docker container',
        (tester) async {
      // // Start the docker container running the mock web api image
      // String containerId = await dockerUtils.startContainer(
      //     config.dockerImage, config.hostPort, config.containerPort);
      // await Future.delayed(const Duration(seconds: 1));

      // Sets up the http.Client dependency injection for service layer to use
      setupServiceLocator();

      // Set up the TaskService
      TaskService taskService = TaskService(baseApiUrl: config.baseApiUrl);

      // Performe the test sequence with the task service provided
      await _performTestSequence(taskService, tester);

      // Unregister the http.Client dependency injection used by the service layer
      serviceLocator.unregister<http.Client>();

      // // Stop the docker container
      // await dockerUtils.stopContainer(containerId);
    });

    // testWidgets('Test full crud and navigation - Mock task service',
    //     (tester) async {
    //   // Set up the mock TaskService
    //   MockTaskService taskService =
    //       MockTaskService(baseApiUrl: config.baseApiUrl);

    //   // Performe the test sequence with the task service provided
    //   await _performTestSequence(taskService, tester);
    // });
  });
}

Future<void> _performTestSequence(
    TaskService taskService, WidgetTester tester) async {
  // Get root task and root subtasks so we have access to the initial state data
  TaskServiceResult<Task?> rootTaskResult = await taskService.getRootTask();
  Task rootTask = rootTaskResult.data!;

  TaskServiceResult<TaskDetailsResponse?> rootTaskDetails =
      await taskService.getTaskDetails(rootTask.taskId);
  List<Task> rootSubTasks = rootTaskDetails.data!.subTasks;

  // Set the physical size of the tester screen so it fits the whole widget
  tester.view.physicalSize = const Size(2000, 5000);

  // ---------------------------------------------------------------------
  // | Initialize the app with the task list screen
  // ---------------------------------------------------------------------

  await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: TaskListScreen(taskService: taskService))));

  // Expect there to be a circular progress indicator when the screen in its first frame, before any data is loaded.
  expect(find.byType(CircularProgressIndicator), findsOneWidget);

  // Run the app until nothing is happening
  await tester.pumpAndSettle();

  // Expect the progress indicator to be gone
  expect(find.byType(CircularProgressIndicator), findsNothing);

  // Verify root task and its subtasks are visible on the screen
  _findByCurrentTaskAndSubTasks(rootTask, rootSubTasks, findsOneWidget);

  // ---------------------------------------------------------------------
  // | Navigate to task one level down - Navigate back up to root level
  // ---------------------------------------------------------------------

  // Decide on a task no navigate to
  Task navTask = rootSubTasks[0];
  TaskDetailsResponse navTaskDetails =
      (await taskService.getTaskDetails(navTask.taskId)).data!;
  List<Task> navSubTasks = navTaskDetails.subTasks;
  // Ensure the test is navigating to a task with sub tasks
  expect(navSubTasks.isNotEmpty, true);

  // Find task to tap

  // Tap it with tester
  await tester.tap(find.byKey(_getTaskItemWidgetKey(navTask.taskId)));
  await tester.pumpAndSettle();

  // Very root task and its subtasks are no longer being displayed
  _findByCurrentTaskAndSubTasks(rootTask, rootSubTasks, findsNothing);

  // Verify the new task and its subtasks is being displayed
  _findByCurrentTaskAndSubTasks(navTask, navSubTasks, findsOneWidget);

  // Navigate back up using the back button in the [CurrentTaskItem] widget
  await tester.tap(find.descendant(
      of: find.byType(CurrentTaskItem),
      matching: find.widgetWithIcon(IconButton, Icons.turn_left)));
  await tester.pumpAndSettle();

  // Verify the new task and its subtasks are no longer being displayed
  _findByCurrentTaskAndSubTasks(navTask, navSubTasks, findsNothing);

  // Verify the root task and its subtasks are again the displayed tasks
  _findByCurrentTaskAndSubTasks(rootTask, rootSubTasks, findsOneWidget);

  // ---------------------
  // | Add task
  // ---------------------

  // Determine data to add
  String newTaskName = "a1b2c3TaskName";
  String newTaskDescription = "a1b2c3TaskDescription";
  late Task createdTask;

  // Expect the task with this name and description isn't in the displayed task list yet
  expect(find.widgetWithText(TaskListItem, newTaskName), findsNothing);
  expect(find.widgetWithText(TaskListItem, newTaskDescription), findsNothing);

  // Find task create widget
  Finder taskCreateWidgetFinder = find.byType(TaskCreateWidget);

  // Expand the form
  await tester.tap(find.descendant(
      of: taskCreateWidgetFinder, matching: find.text("Create a New Task")));
  await tester.pump();

  // Fill in the form
  await tester.enterText(
      find.descendant(
          of: taskCreateWidgetFinder,
          matching: find.widgetWithText(TextFormField, 'Task Name')),
      newTaskName);
  await tester.enterText(
      find.descendant(
          of: taskCreateWidgetFinder,
          matching: find.widgetWithText(TextField, 'Description')),
      newTaskDescription);

  final dropdownFinder = find.descendant(
      of: taskCreateWidgetFinder,
      matching: find.byType(DropdownButtonFormField<TaskLifecycleType>));

  // Assert the default value for TaskLifecycle in the task creation widget is TaskLifecycleType.Setup
  expect(find.descendant(of: dropdownFinder, matching: find.text("Setup")),
      findsOneWidget);

  // Submit the form
  await tester.tap(find.descendant(
      of: taskCreateWidgetFinder,
      matching: find.widgetWithText(ElevatedButton, 'Create Task')));
  await tester.pumpAndSettle();

  // Collapse the form
  await tester.tap(find.descendant(
      of: taskCreateWidgetFinder, matching: find.text("Create a New Task")));
  await tester.pump();

  // Expect task to be displayed
  expect(find.widgetWithText(TaskListItem, newTaskName), findsOneWidget);

  TaskListItem taskListItemFound =
      tester.widget(find.widgetWithText(TaskListItem, newTaskName));
  expect(find.widgetWithText(TaskListItem, newTaskDescription), findsOneWidget);

  // Get an instance of the created task from service
  createdTask =
      (await taskService.getTaskById(taskListItemFound.task.taskId)).data!;

  // Expect the created task wasn't already in the list of root sub tasks
  expect(
      rootSubTasks
          .where((element) => element.taskId == createdTask.taskId)
          .isEmpty,
      true);

  // Add the new task to our rootSubTask list (to maintain our expected state data to test the displayed state against)
  rootSubTasks.add(createdTask);

  // Expect to find the root task and all the tasks in the root sub task list in the display
  //   (Mainly doing this to test if the root task and the other tasks are all there and unchanged)
  _findByCurrentTaskAndSubTasks(rootTask, rootSubTasks, findsOneWidget);

  // ---------------------
  // | Delete task
  // ---------------------

  // Pick a task to delete
  Task taskToDelete = rootSubTasks[1];

  // Expect the widget is here
  _findByCurrentTaskAndSubTasks(rootTask, rootSubTasks, findsOneWidget);

  // Find task display widget by key and do another existence check on that
  Finder taskToDeleteFinder =
      find.byKey(_getTaskItemWidgetKey(taskToDelete.taskId));
  expect(taskToDeleteFinder, findsOneWidget);

  // Tap delete button on the task display widget
  await tester.tap(find.descendant(
      of: taskToDeleteFinder,
      matching: find.widgetWithIcon(IconButton, Icons.delete)));
  await tester.pumpAndSettle();

  // Expect that we can not find the task display widget by key anymore
  expect(taskToDeleteFinder, findsNothing);

  // Remove task from our list of tasks
  rootSubTasks.remove(taskToDelete);

  // Expect the root task and all the other subTasks are unchanged and still there
  _findByCurrentTaskAndSubTasks(rootTask, rootSubTasks, findsOneWidget);

  // ---------------------
  // | Edit task
  // ---------------------

  // Pick a task to edit and new values
  Task taskToEdit = rootSubTasks[1];
  String newEditName = "blargarg";
  String newEditDescription = "orgalorg";

  // Ensure our the task data in our test data is not the same as these new values
  expect(taskToEdit.taskName != newEditName, true);
  expect(taskToEdit.description != newEditDescription, true);

  await _performEditTaskSequence(
      tester, taskToEdit, newEditName, newEditDescription);

  taskToEdit.taskName = newEditName;
  taskToEdit.description = newEditDescription;

  // Ensure the task editing sequence didnt remove any tasks
  _findByCurrentTaskAndSubTasks(rootTask, rootSubTasks, findsOneWidget);

  // Reset physical size of tester after testing.
  tester.view.resetPhysicalSize();
}

Key _getTaskItemWidgetKey(int taskId) {
  return Key("TaskItem_${taskId}");
}

/// This function checks if the supplied [currentTask] is displayed in a [CurrentTaskItem] widget
/// and the [currentSubTasks] are displayed in [TaskListItem] widgets
void _findByCurrentTaskAndSubTasks(
    Task currentTask, List<Task> currentSubTasks, Matcher matcher) {
  // Check if the the current task is displayed in the current task item widget
  expect(
      find.byWidgetPredicate((widget) =>
          widget is CurrentTaskItem &&
          widget.key == _getTaskItemWidgetKey(currentTask.taskId)),
      matcher);

  // Check if all the subtasks of the current task are displayed as task list item widgets
  for (Task subTask in currentSubTasks) {
    expect(
        find.byWidgetPredicate((widget) =>
            widget is TaskListItem &&
            widget.key == _getTaskItemWidgetKey(subTask.taskId)),
        matcher);
  }
}

/// This function finds the widget displaying the [taskToEdit]
///   Verifies that is has displayes values in the [taskToEdit] and neiher [newName] nor [newDescription]
///   Then uses the edit button on widget displaying that task to go through the [TaskEditScreen] process
///   After the task has been edited with [TaskEditScreen] this function finally verifies that that the
///   widget displaying the task is showing the new values, both [newName] and [newDescription]
Future<void> _performEditTaskSequence(WidgetTester tester, Task taskToEdit,
    String newName, String newDescription) async {
  //

  // Store old values for testing
  String oldName = taskToEdit.taskName;
  String oldDescription = taskToEdit.description;

  // Find widget by task id
  Finder taskToEditWidget =
      find.byKey(_getTaskItemWidgetKey(taskToEdit.taskId));

  // Expect current values are shown in widget
  expect(find.descendant(of: taskToEditWidget, matching: find.text(oldName)),
      findsOneWidget);
  if (oldDescription.isNotEmpty) {
    expect(
        find.descendant(
            of: taskToEditWidget, matching: find.text(oldDescription)),
        findsOneWidget);
  }

  // Expect the values we will edit in are not shown in the widget
  expect(find.descendant(of: taskToEditWidget, matching: find.text(newName)),
      findsNothing);
  expect(
      find.descendant(
          of: taskToEditWidget, matching: find.text(newDescription)),
      findsNothing);

  // Expect task list screen is shown
  // and
  // Task edit screen is NOT shown
  expect(find.byType(TaskListScreen), findsOneWidget);
  expect(find.byType(TaskEditScreen), findsNothing);

  // Tap edit button
  await tester.tap(find.descendant(
      of: taskToEditWidget,
      matching: find.widgetWithIcon(IconButton, Icons.edit)));
  await tester.pumpAndSettle();

  // Expect task list screen is NOT shown
  // and
  // Task edit screen is shown
  expect(find.byType(TaskListScreen), findsNothing);
  expect(find.byType(TaskEditScreen), findsOneWidget);

  // edit values with current values
  const Key taskNameKey = Key('taskNameEditField');
  const Key descriptionKey = Key('taskDescriptionEditField');

  TextField taskNameField =
      await tester.widget(find.byKey(taskNameKey)) as TextField;
  TextField taskDescriptionField =
      await tester.widget(find.byKey(descriptionKey)) as TextField;

  // Expect current values are shown
  expect(taskNameField.controller!.text, oldName);
  expect(taskDescriptionField.controller!.text, oldDescription);

  await tester.enterText(find.byKey(taskNameKey), newName);
  await tester.enterText(find.byKey(descriptionKey), newDescription);
  await tester.pump();

  // tap edit button
  await tester.tap(find.widgetWithText(ElevatedButton, 'Save Changes'));
  await tester.pumpAndSettle();

  // Expect task list screen is shown
  // and
  // Task edit screen is NOT shown
  expect(find.byType(TaskListScreen), findsOneWidget);
  expect(find.byType(TaskEditScreen), findsNothing);

  // find widget that was edited by id

  // Expect old values are not shown in the task display widget
  expect(find.descendant(of: taskToEditWidget, matching: find.text(oldName)),
      findsNothing);
  expect(
      find.descendant(
          of: taskToEditWidget, matching: find.text(oldDescription)),
      findsNothing);

  // Expect the values we just edited in are shown in the task display widget
  expect(find.descendant(of: taskToEditWidget, matching: find.text(newName)),
      findsOneWidget);
  expect(
      find.descendant(
          of: taskToEditWidget, matching: find.text(newDescription)),
      findsOneWidget);
}
