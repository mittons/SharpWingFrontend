import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/widgets/base_task_item.dart';

class TaskListItem extends BaseTaskItem {
  final Function(Task tappedTask) onTap;

  const TaskListItem({
    Key? key,
    required Task task,
    required Function(Task) onEdit,
    required Function(Task) onDelete,
    required Function(Task, bool?) onCheckboxToggle,
    required this.onTap,
  }) : super(
          key: key,
          task: task,
          onEdit: onEdit,
          onDelete: onDelete,
          onCheckboxToggle: onCheckboxToggle,
        );

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: super.build(context),
    );
  }

  @override
  void onTapHandler() {
    onTap(task);
  }
}
