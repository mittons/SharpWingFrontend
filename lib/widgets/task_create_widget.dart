import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/models/task.dart';

class TaskCreateWidget extends StatefulWidget {
  final Function(Task createdTask) onCreateTask;

  const TaskCreateWidget({super.key, required this.onCreateTask});

  @override
  State<TaskCreateWidget> createState() => _TaskCreateWidgetState();
}

class _TaskCreateWidgetState extends State<TaskCreateWidget> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  TaskLifecycleType? selectedLifecycleType;

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
            title: const Padding(
              padding: EdgeInsets.only(
                  left: 0.0), // Adjust the left padding for the title
              child: Text(
                "Create a New Task",
                style: TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold), // Bold text
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Icon(_isExpanded ? Icons.remove : Icons.add),
            ),
            onTap: _toggleExpansion,
          ),
          if (_isExpanded) ...[
            const SizedBox(height: 16.0),
            TextField(
              controller: taskNameController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<TaskLifecycleType>(
              value: selectedLifecycleType,
              items: TaskLifecycleType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Lifecycle Type'),
              onChanged: (value) {
                setState(() {
                  selectedLifecycleType = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _createTask();
              },
              child: const Text('Create Task'),
            ),
          ]
        ],
      ),
    );
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
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
      status: 'not completed',
      taskLifecycleType: selectedLifecycleType!,
    );

    // Call the onSave callback to handle the new task
    widget.onCreateTask(newTask);

    // Clear the input fields
    taskNameController.clear();
    descriptionController.clear();
    setState(() {
      selectedLifecycleType = null;
    });
  }
}
