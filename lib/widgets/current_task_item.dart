import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/widgets/base_task_item.dart';

class CurrentTaskItem extends BaseTaskItem {
  final Function() onBackPressed;

  const CurrentTaskItem({
    Key? key,
    required Task task,
    required Function(Task) onEdit,
    required Function(Task) onDelete,
    required Function(Task, bool?) onCheckboxToggle,
    required this.onBackPressed,
  }) : super(
          key: key,
          task: task,
          onEdit: onEdit,
          onDelete: onDelete,
          onCheckboxToggle: onCheckboxToggle,
          cardColor: const Color.fromRGBO(238, 238, 238, 1.0),
        );

  @override
  List<Widget> buildAdditionalTrailingElements() {
    if (task.parentId == null) {
      return [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.turn_left,
            color: Colors.white,
          ),
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.turn_left),
          onPressed: () {
            onBackPressed();
          },
        ),
      ];
    }
  }
}
