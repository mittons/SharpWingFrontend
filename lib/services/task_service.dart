import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/models/task_details_response.dart';
import 'package:sharp_wing_frontend/services/task_service_result.dart';
import 'package:sharp_wing_frontend/utils/service_locator.dart';

class TaskService {
  final String baseApiUrl; // Replace with your API base URL

  TaskService({required this.baseApiUrl});

  http.Client _getHttpClient() {
    return serviceLocator<http.Client>();
  }

  //TODO: Clean commented code
  //TODO: Log http status code
  //TODO: Log exceptions
  Future<TaskServiceResult<List<Task>>> getAllTasks() async {
    try {
      final response =
          await _getHttpClient().get(Uri.parse('$baseApiUrl/api/tasks'));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final List<dynamic> jsonResponse = json.decode(response.body);
        final List<Task> tasks = jsonResponse
            .map((taskJson) => Task.fromJson(taskJson as Map<String, dynamic>))
            .toList();

        return TaskServiceResult(data: tasks, success: true);
      } else {
        //response code handling (response.statusCode)
        return TaskServiceResult(data: null, success: false);
      }
    } catch (e) {
      //log exceptions
      return TaskServiceResult(data: null, success: false);
    }
  }

  //TODO: Clean commented code
  //TODO: Log http status code
  //TODO: Log exceptions
  Future<TaskServiceResult<Task>> getTaskById(int taskId) async {
    try {
      final response = await _getHttpClient()
          .get(Uri.parse('$baseApiUrl/api/tasks/$taskId'));

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        final Task task = Task.fromJson(jsonResponse as Map<String, dynamic>);

        return TaskServiceResult(data: task, success: true);
      } else {
        //response code handling (response.statusCode)
        return TaskServiceResult(data: null, success: false);
      }
    } catch (e) {
      //log exceptions
      return TaskServiceResult(data: null, success: false);
    }
  }

  //TODO: Clean commented code
  //TODO: Log http status code
  //TODO: Log exceptions
  Future<TaskServiceResult<TaskDetailsResponse>> getTaskDetails(
      int taskId) async {
    try {
      final response = await _getHttpClient()
          .get(Uri.parse('$baseApiUrl/api/tasks/$taskId/details'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        return TaskServiceResult(
            data: TaskDetailsResponse.fromJson(jsonResponse), success: true);
      } else {
        //response code handling (response.statusCode)
        return TaskServiceResult(data: null, success: false);
      }
    } catch (e) {
      //log exception
      return TaskServiceResult(data: null, success: false);
    }
  }

  //TODO: Clean commented code
  //TODO: Log http status code
  //TODO: Log exceptions
  Future<TaskServiceResult<Task>> getRootTask() async {
    try {
      final response =
          await _getHttpClient().get(Uri.parse('$baseApiUrl/api/tasks/root'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return TaskServiceResult(
            data: Task.fromJson(jsonResponse), success: true);
      } else {
        //response code handling (response.statusCode)
        return TaskServiceResult(data: null, success: false);
      }
    } catch (e) {
      //log exceptions
      return TaskServiceResult(data: null, success: false);
    }
  }

  //TODO: Clean commented code
  //TODO: Log http status code
  //TODO: Log exceptions
  Future<TaskServiceResult<Task>> createTask(Task task) async {
    try {
      final response = await _getHttpClient().post(
        Uri.parse('$baseApiUrl/api/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode == 201) {
        final dynamic jsonResponse = json.decode(response.body);
        final Task createdTask =
            Task.fromJson(jsonResponse as Map<String, dynamic>);

        return TaskServiceResult(data: createdTask, success: true);
      } else {
        //response code handling (response.statusCode)
        return TaskServiceResult(data: null, success: false);
      }
    } catch (e) {
      //log exceptions
      return TaskServiceResult(data: null, success: false);
    }
  }

  //TODO: Clean commented code
  //TODO: Log http status code
  //TODO: Log exceptions
  Future<TaskServiceResult<NoContent>> updateTask(Task updatedTask) async {
    try {
      final response = await _getHttpClient().put(
        Uri.parse('$baseApiUrl/api/tasks/${updatedTask.taskId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedTask.toJson()),
      );

      if (response.statusCode != 204) {
        //print('Failed to update task: ${response.statusCode}');
        //throw Exception('Failed to update task');
        return TaskServiceResult(data: null, success: false);
      }

      return TaskServiceResult(data: null, success: true);
    } catch (e) {
      //log exceptions
      return TaskServiceResult(data: null, success: false);
    }
  }

  //TODO: Clean commented code
  //TODO: Log http status code
  //TODO: Log exceptions
  Future<TaskServiceResult<NoContent>> deleteTask(int taskId) async {
    try {
      final response = await _getHttpClient()
          .delete(Uri.parse('$baseApiUrl/api/tasks/$taskId'));

      if (response.statusCode != 204) {
        //print('Failed to delete task: ${response.statusCode}');
        return TaskServiceResult(data: null, success: false);
      }

      return TaskServiceResult(data: null, success: true);
    } catch (e) {
      //log exceptions
      return TaskServiceResult(data: null, success: false);
    }
  }
}
