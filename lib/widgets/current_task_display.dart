import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/widgets/current_task_item.dart';

class CurrentTaskDisplay extends StatelessWidget {
  final Task currentTask;
  final Function(Task taskToUpdate, bool? newValue) onCheckboxToggle;
  final Function(Task taskToDelete) onDelete;
  final Function(Task editTask) onEdit;
  final Function() onBackPressed;

  const CurrentTaskDisplay({
    Key? key,
    required this.currentTask,
    required this.onCheckboxToggle,
    required this.onDelete,
    required this.onEdit,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0.0),
          title: Padding(
            padding: EdgeInsets.only(
                left: 0.0), // Adjust the left padding for the title
            child: Text(
              "Current Task",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          leading: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Visibility(
                visible: false,
                child: Icon(Icons.add),
              )),
        ),
        CurrentTaskItem(
          task: currentTask,
          onCheckboxToggle: onCheckboxToggle,
          onDelete: onDelete,
          onEdit: onEdit,
          onBackPressed: onBackPressed,
        ),
      ],
    );
  }
}
