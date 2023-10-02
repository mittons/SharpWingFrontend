// lib/screens/task_list.dart

import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/screens/task_edit_screen.dart';
import 'package:sharp_wing_frontend/widgets/task_list_item.dart';
import 'package:sharp_wing_frontend/services/task_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskListScreen extends StatefulWidget {
  final TaskService taskService;

  const TaskListScreen({Key? key, required this.taskService}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final List<Task> loadedTasks = await fetchTasks();
      setState(() {
        tasks = loadedTasks;
      });
    } catch (e) {
      // Handle the error, e.g., show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskListItem(
            task: task,
            onCheckboxToggle: (taskToUpdate, newValue) {
              setState(() {
                taskToUpdate.status = newValue! ? 'completed' : 'not completed';
              });
            },
            onEdit: (editTask) {
              // Handle the update action
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TaskEditScreen(
                    task: task,
                    onSave: (updatedTask) {
                      // Update the task in the original list of tasks
                      setState(() {
                        int index = tasks.indexWhere(
                            (task) => task.taskId == updatedTask.taskId);
                        if (index != -1) {
                          tasks[index] = updatedTask;
                        }
                      });
                    },
                  ),
                ),
              );
            },
            onDelete: (deleteTask) {
              setState(() {
                tasks.removeAt(index);
              });
            },
          ); // Use the TaskListItem widget
        },
      ),
    );
  }

  Future<List<Task>> fetchTasks() async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/api/tasks'));

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
}
