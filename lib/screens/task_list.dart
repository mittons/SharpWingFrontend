// lib/screens/task_list.dart

import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/screens/task_edit_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
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
/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.taskName),
            subtitle: Text(task.description),
            trailing: Text(task.dueDate.toString()), // You can format this as needed
            leading: Checkbox(
              value: task.status == 'completed',
              onChanged: (newValue) {
                setState(() {
                  task.status = newValue! ? 'completed' : 'not completed';
                });
              },
            ),
          );
        },
      ),
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.taskName),
            subtitle: Text(task.description),
            //trailing: Text(task.dueDate.toString()), // You can format this as needed
            leading: Checkbox(
              value: task.status == 'completed',
              onChanged: (newValue) {
                setState(() {
                  task.status = newValue! ? 'completed' : 'not completed';
                });
              },
            ),
            // Add update and delete buttons
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(task.dueDate.toString()), // You can format this as needed
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Handle the update action
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TaskEditScreen(
                          task: task,
                          onSave: (updatedTask) {
                            // Update the task in the original list of tasks
                            setState(() {
                              int index = tasks.indexWhere((task) => task.taskId == updatedTask.taskId);
                              if (index != -1) {
                                tasks[index] = updatedTask;
                              }
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Handle the delete action
                    setState(() {
                      tasks.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse('http://localhost:5000/api/tasks'));

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