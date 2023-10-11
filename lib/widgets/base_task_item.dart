import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/models/task.dart';

abstract class BaseTaskItem extends StatelessWidget {
  final Task task;
  final Function(Task editTask) onEdit;
  final Function(Task taskToDelete) onDelete;
  final Function(Task taskToUpdate, bool? newValue) onCheckboxToggle;
  final Color cardColor;

  const BaseTaskItem({
    required this.task,
    Key? key,
    required this.onEdit,
    required this.onDelete,
    required this.onCheckboxToggle,
    this.cardColor = Colors.white,
  }) : super(key: key);

  // Always display the task's name and optionally its description.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapHandler(),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 3,
        child: Container(
          alignment: Alignment.center,
          color: cardColor,
          constraints: const BoxConstraints(minHeight: 64.0),
          child: ListTile(
            mouseCursor: MouseCursor.defer,
            title: Text(task.taskName),
            subtitle: task.description.isEmpty ? null : Text(task.description),
            leading: buildLeading(),
            trailing: buildTrailing(),
          ),
        ),
      ),
    );
  }

  void onTapHandler() {}

  Widget buildLeading() {
    return Visibility(
      visible: task.parentId != null,
      child: Checkbox(
        value: task.status == 'completed',
        onChanged: (newValue) {
          onCheckboxToggle(task, newValue);
        },
      ),
    );
  }

  Widget buildTrailing() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...buildAdditionalTrailingElements(),
        IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => {
                  onEdit(task),
                }),
        if (task.parentId == null) ...[
          const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.delete, color: Colors.white))
        ] else ...[
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => {onDelete(task)}),
        ],
      ],
    );
  }

  // To be overridden by extending classes for additional trailing widgets.
  List<Widget> buildAdditionalTrailingElements() => [];
}
