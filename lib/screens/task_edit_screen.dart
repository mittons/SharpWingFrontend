import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/services/task_service.dart';

class TaskEditScreen extends StatefulWidget {
  final Task task;
  final Function(Task updatedTask) onSave;
  final TaskService taskService;

  const TaskEditScreen(
      {super.key,
      required this.task,
      required this.onSave,
      required this.taskService});

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
        padding: const EdgeInsets.all(16.0),
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
                  createdDate:
                      widget.task.createdDate, // Use the original task's values
                  dueDate: widget.task.dueDate,
                  status: widget.task.status,
                  priority: widget.task.priority,
                );
                try {
                  await widget.taskService
                      .updateTask(widget.task.taskId, updatedTask);

                  // Task updated successfully, call the onSave callback
                  widget.onSave(updatedTask);

                  if (!context.mounted) return;

                  Navigator.pop(context);
                } catch (exception) {
                  //Failed to edit task task
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
