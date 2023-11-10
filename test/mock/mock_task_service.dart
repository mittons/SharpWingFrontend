import 'dart:async';
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/models/task_details_response.dart';
import 'package:sharp_wing_frontend/services/task_service_result.dart';
import 'package:sharp_wing_frontend/services/task_service.dart';

import 'mock_task_data_layer.dart';

// Mock class for TaskService
class MockTaskService extends TaskService {
  //===================================================================================================
  //|     Callback functions that get called at the end of each function in this class
  //|     - Does not get called if the callback function is set to null
  //|     - Input arguments are
  //|     --- Successful, valid, complete TaskServiceResult objects created by the function
  //|     --- [Optional] Input arguments the TaskService function was provided with, if any
  //|     - Output argument is
  //|     --- The TaskServiceResult object that will actually be returned by the TaskService Function
  //===================================================================================================
  Function(TaskServiceResult res)? onGetAllTasks;
  Function(TaskServiceResult res, int taskId)? onGetTaskById;

  Function(TaskServiceResult res, int taskId)? onGetTaskDetails;
  Function(TaskServiceResult res)? onGetRootTask;
  Function(TaskServiceResult res, Task taskToCreate)? onCreateTask;
  Function(TaskServiceResult res, Task updatedTask)? onUpdateTask;
  Function(TaskServiceResult res, int taskId)? onDeleteTask;

  MockTaskDataLayer mockTaskDataLayer = MockTaskDataLayer();

  MockTaskService({String baseApiUrl = 'http://mockapi'})
      : super(baseApiUrl: baseApiUrl);

  @override
  Future<TaskServiceResult<List<Task>?>> getAllTasks() async {
    // Return mock data for testing
    TaskServiceResult<List<Task>?> result = TaskServiceResult(
      data: mockTaskDataLayer.getAllTasks(),
      success: true,
    );

    if (onGetAllTasks != null) {
      result = onGetAllTasks!(result);
    }
    return result;
  }

  @override
  Future<TaskServiceResult<Task?>> getTaskById(int taskId) async {
    // Return a mock task or null based on the taskId
    Task mockTask = mockTaskDataLayer.getTaskById(taskId)!;

    TaskServiceResult<Task?> result = TaskServiceResult(
      data: mockTask,
      success: true,
    );

    //HERE
    if (onGetTaskById != null) {
      result = onGetTaskById!(result, taskId);
    }
    return result;
  }

  @override
  Future<TaskServiceResult<TaskDetailsResponse?>> getTaskDetails(
      int taskId) async {
    Task currentTask = mockTaskDataLayer.getTaskById(1)!;
    List<Task> subTasks = mockTaskDataLayer
        .getAllTasks()
        .where((task) => task.parentId == currentTask.taskId)
        .toList();
    List<Task> pathEnumeration = [
      mockTaskDataLayer.getTaskById(currentTask.parentId!)!
    ];
    // Return mock task details
    var mockTaskDetails = TaskDetailsResponse(
        currentTask: currentTask,
        subTasks: subTasks,
        pathEnumeration: pathEnumeration);

    TaskServiceResult<TaskDetailsResponse?> result = TaskServiceResult(
      data: mockTaskDetails,
      success: true,
    );

    if (onGetTaskDetails != null) {
      result = onGetTaskDetails!(result, taskId);
    }

    return result;
  }

  @override
  Future<TaskServiceResult<Task?>> getRootTask() async {
    // Return a mock root task

    Task rootTask = mockTaskDataLayer.getTaskById(
        0)!; //root task should have id 0 in the mock task data layer setup.
    rootTask.parentId =
        null; //still, we ensure that it has the defining trait of a root task.

    TaskServiceResult<Task?> result = TaskServiceResult(
      data:
          rootTask, //root task should have id 0 in the mock task data layer setup.
      success: true,
    );

    if (onGetRootTask != null) {
      result = onGetRootTask!(result);
    }

    return result;
  }

  @override
  Future<TaskServiceResult<Task?>> createTask(Task task) async {
    // Simulate task creation by returning the same task with a mock ID
    TaskServiceResult<Task?> result = TaskServiceResult(
      data: task,
      success: true,
    );

    if (onCreateTask != null) {
      result = onCreateTask!(result, task);
    }

    return result;
  }

  @override
  Future<TaskServiceResult<NoContent?>> updateTask(Task updatedTask) async {
    // Simulate a successful update
    TaskServiceResult<NoContent?> result = TaskServiceResult(
      data: NoContent(),
      success: true,
    );

    //HERE
    if (onUpdateTask != null) {
      result = onUpdateTask!(result, updatedTask);
    }

    return result;
  }

  @override
  Future<TaskServiceResult<NoContent?>> deleteTask(int taskId) async {
    // Simulate a successful delete
    TaskServiceResult<NoContent?> result = TaskServiceResult(
      data: NoContent(),
      success: true,
    );

    //HERE
    if (onDeleteTask != null) {
      result = onDeleteTask!(result, taskId);
    }

    return result;
  }
}
