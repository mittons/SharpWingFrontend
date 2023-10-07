// lib/screens/task_list.dart

import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/screens/task_edit_screen.dart';
import 'package:sharp_wing_frontend/widgets/task_create_widget.dart';
import 'package:sharp_wing_frontend/widgets/task_list_item.dart';
import 'package:sharp_wing_frontend/services/task_service.dart';

class TaskListScreen extends StatefulWidget {
  final TaskService taskService;

  const TaskListScreen({Key? key, required this.taskService}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final List<Task> loadedTasks = await widget.taskService.getAllTasks();
      setState(() {
        tasks = loadedTasks;
      });
    } catch (e) {
      // Handle the error, e.g., show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Task List'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskListItem(
                    task: task,
                    onCheckboxToggle: _toggleTaskStatus,
                    onEdit: _openTaskEditorScreen,
                    onDelete: _deleteTask,
                  );
                },
              ),
            ),
            TaskCreateWidget(onCreateTask: _createTask)
          ],
        ));
  }

  void _openTaskEditorScreen(Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskEditScreen(
          task: task,
          taskService: widget.taskService,
          onSave: (updatedTask) {
            // Update the task in the original list of tasks
            setState(() {
              int index =
                  tasks.indexWhere((task) => task.taskId == updatedTask.taskId);
              if (index != -1) {
                tasks[index] = updatedTask;
              }
            });
          },
        ),
      ),
    );
  }

  Future<void> _toggleTaskStatus(Task taskToUpdate, newValue) async {
    taskToUpdate.status = newValue! ? 'completed' : 'not completed';
    widget.taskService.updateTask(taskToUpdate.taskId, taskToUpdate);

    if (!context.mounted) return;

    setState(() {});
  }

  Future<void> _createTask(Task createdTask) async {
    Task createdTaskFromApi = await widget.taskService.createTask(createdTask);

    if (!context.mounted) return;

    setState(() {
      tasks.add(createdTaskFromApi);
    });
  }

  Future<void> _deleteTask(Task taskToDelete) async {
    try {
      await widget.taskService.deleteTask(taskToDelete.taskId);

      if (!context.mounted) return;

      setState(() {
        tasks.remove(taskToDelete);
      });
    } catch (exception) {
      //failed to delete task
    }
  }
}
