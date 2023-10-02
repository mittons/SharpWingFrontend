import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TaskEditScreen extends StatefulWidget {
  final Task task;
  final Function(Task updatedTask) onSave;

  TaskEditScreen({required this.task, required this.onSave});

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the task data
    taskNameController.text = widget.task.taskName;
    descriptionController.text = widget.task.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: taskNameController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Update task data
                final updatedTask = Task(
                  taskId: widget.task.taskId, // Use the original task's taskId
                  taskName: taskNameController.text,
                  description: descriptionController.text,
                  createdDate: widget.task.createdDate, // Use the original task's values
                  dueDate: widget.task.dueDate,
                  status: widget.task.status,
                  priority: widget.task.priority,
                );

                // Make a PUT request to update the task
                final response = await http.put(
                  Uri.parse('http://localhost:5000/api/tasks/${widget.task.taskId}'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode(updatedTask.toJson()),
                );

                if (response.statusCode == 204) {
                  // Task updated successfully, call the onSave callback
                  widget.onSave(updatedTask);

                  if (!context.mounted) return;

                  // Task updated successfully, you can handle the response as needed
                  Navigator.pop(context); // Close the edit screen
                } else {
                  // Handle error, e.g., show an error message
                  print('Failed to update task: ${response.statusCode}');
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}