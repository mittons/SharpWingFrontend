import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/widgets/task_list_item.dart';

class TaskListSection extends StatefulWidget {
  final TaskLifecycleType lifecycleType;
  final List<Task> tasks;
  final Function(Task editTask) onEdit;
  final Function(Task taskToDelete) onDelete;
  final Function(Task taskToUpdate, bool? newValue) onCheckboxToggle;
  final Function(Task selectedTask) onTap;

  const TaskListSection(
      {super.key,
      required this.lifecycleType,
      required this.tasks,
      required this.onEdit,
      required this.onDelete,
      required this.onCheckboxToggle,
      required this.onTap});

  @override
  State<TaskListSection> createState() => _TaskListSectionState();
}

class _TaskListSectionState extends State<TaskListSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
          title: Padding(
            padding: const EdgeInsets.only(
                left: 0.0), // Adjust the left padding for the title
            child: Text(
              "${widget.lifecycleType.toString().split('.').last} Tasks",
              style: const TextStyle(fontWeight: FontWeight.bold), // Bold text
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Icon(_isExpanded ? Icons.remove : Icons.add),
          ),
          onTap: _toggleExpansion,
        ),
        if (_isExpanded)
          ...widget.tasks
              .map((task) => TaskListItem(
                    task: task,
                    onCheckboxToggle: widget.onCheckboxToggle,
                    onEdit: widget.onEdit,
                    onDelete: widget.onDelete,
                    onTap: widget.onTap,
                    cardColor: Colors.white,
                  ))
              .toList(),
      ],
    );
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
