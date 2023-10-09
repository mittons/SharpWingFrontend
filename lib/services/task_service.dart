import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/models/task_details_response.dart';

class TaskService {
  final String baseApiUrl; // Replace with your API base URL

  TaskService({required this.baseApiUrl});

  Future<List<Task>> getAllTasks() async {
    final response = await http.get(Uri.parse('$baseApiUrl/api/tasks'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final List<dynamic> jsonResponse = json.decode(response.body);
      final List<Task> tasks = jsonResponse
          .map((taskJson) => Task.fromJson(taskJson as Map<String, dynamic>))
          .toList();
      return tasks;
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception or handle the error as needed.
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> getTaskById(int taskId) async {
    final response = await http.get(Uri.parse('$baseApiUrl/api/tasks/$taskId'));

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);
      final Task task = Task.fromJson(jsonResponse as Map<String, dynamic>);
      return task;
    } else {
      throw Exception('Failed to load task');
    }
  }

  Future<TaskDetailsResponse> getTaskDetails(int taskId) async {
    final response =
        await http.get(Uri.parse('$baseApiUrl/api/tasks/$taskId/details'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return TaskDetailsResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load task details');
    }
  }

  Future<Task> getRootTask() async {
    final response = await http.get(Uri.parse('$baseApiUrl/api/tasks/root'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return Task.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load root task');
    }
  }

  Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse('$baseApiUrl/api/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 201) {
      final dynamic jsonResponse = json.decode(response.body);
      final Task createdTask =
          Task.fromJson(jsonResponse as Map<String, dynamic>);
      return createdTask;
    } else {
      throw Exception('Failed to create task');
    }
  }

  Future<void> updateTask(int taskId, Task updatedTask) async {
    final response = await http.put(
      Uri.parse('$baseApiUrl/api/tasks/$taskId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedTask.toJson()),
    );

    if (response.statusCode != 204) {
      print('Failed to update task: ${response.statusCode}');
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(int taskId) async {
    final response =
        await http.delete(Uri.parse('$baseApiUrl/api/tasks/$taskId'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete task');
    }
  }
}
