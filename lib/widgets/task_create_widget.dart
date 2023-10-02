import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/models/task.dart';

class TaskCreateWidget extends StatefulWidget {
  final Function(Task createdTask) onCreateTask;

  TaskCreateWidget({required this.onCreateTask});

  @override
  _TaskCreateWidgetState createState() => _TaskCreateWidgetState();
}

class _TaskCreateWidgetState extends State<TaskCreateWidget> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Create a New Task',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: taskNameController,
            decoration: InputDecoration(labelText: 'Task Name'),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _createTask();
            },
            child: const Text('Create Task'),
          ),
        ],
      ),
    );
  }

  void _createTask() {
    // Get the task data from the form
    final String taskName = taskNameController.text;
    final String description = descriptionController.text;

    // Validate input (you can add more validation as needed)

    // Create a new Task object
    final Task newTask = Task(
      taskId: -1, // Assign a unique ID (you can generate one as needed)
      taskName: taskName,
      description: description,
      createdDate: DateTime.now(),
      dueDate: DateTime.now(), // You can set the due date as needed
      status: 'not completed',
      priority: 'medium', // Set priority as needed
    );

    // Call the onSave callback to handle the new task
    widget.onCreateTask(newTask);

    // Clear the input fields
    taskNameController.clear();
    descriptionController.clear();
  }
}
