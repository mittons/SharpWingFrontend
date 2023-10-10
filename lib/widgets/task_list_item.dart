import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/models/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final Function(Task editTask) onEdit;
  final Function(Task taskToDelete) onDelete;
  final Function(Task taskToUpdate, bool? newValue) onCheckboxToggle;
  final Function(Task selectedTask) onTap;
  final Color cardColor;

  const TaskListItem(
      {super.key,
      required this.task,
      required this.onEdit,
      required this.onDelete,
      required this.onCheckboxToggle,
      required this.onTap,
      required this.cardColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(task),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 3,
        color: cardColor,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(minHeight: 64.0),
          child: ListTile(
            title: Text(task.taskName),
            subtitle: task.description.isEmpty ? null : Text(task.description),
            leading: Visibility(
              visible: task.parentId != null,
              child: Checkbox(
                value: task.status == 'completed',
                onChanged: (newValue) {
                  // Handle checkbox state change
                  onCheckboxToggle(task, newValue);
                },
              ),
            ),
            // Add update and delete buttons
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Handle the update action
                    onEdit(task);
                  },
                ),
                if (task.parentId == null) ...[
                  const Icon(Icons.delete, color: Colors.white)
                ] else ...[
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      onDelete(task);
                      // Handle the delete action
                    },
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
