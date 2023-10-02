import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/models/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final Function(Task editTask) onEdit;
  final Function(Task deleteTask) onDelete;
  final Function(Task taskToUpdate, bool? newValue) onCheckboxToggle;

  const TaskListItem({super.key, required this.task, required this.onEdit, required this.onDelete, required this.onCheckboxToggle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.taskName),
      subtitle: Text(task.description),
      leading: Checkbox(
        value: task.status == 'completed',
        onChanged: (newValue) {
          // Handle checkbox state change
          onCheckboxToggle(task, newValue);
        },
      ),
      // Add update and delete buttons
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(task.dueDate.toString()), // You can format this as needed
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Handle the update action
              onEdit(task);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              onDelete(task);
              // Handle the delete action
            },
          ),
        ],
      ),
    );
  }
}