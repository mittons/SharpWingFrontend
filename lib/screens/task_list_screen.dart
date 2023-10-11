// lib/screens/task_list.dart

import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/screens/task_edit_screen.dart';
import 'package:sharp_wing_frontend/widgets/task_create_widget.dart';
import 'package:sharp_wing_frontend/widgets/task_list_section.dart';
import 'package:sharp_wing_frontend/widgets/current_task_display.dart';
import 'package:sharp_wing_frontend/services/task_service.dart';
import 'package:sharp_wing_frontend/models/task_details_response.dart';

class TaskListScreen extends StatefulWidget {
  final TaskService taskService;

  const TaskListScreen({Key? key, required this.taskService}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  late Task
      currentTask; // Initialized later and should never be null afterwards.
  List<Task> pathEnumeration = [];

  @override
  void initState() {
    super.initState();
    _fetchRootAndLoadDetails();
  }

  Future<void> _fetchRootAndLoadDetails() async {
    try {
      var rootTask = await widget.taskService.getRootTask();
      _loadTaskDetails(rootTask);
    } catch (e) {
      // Handle errors accordingly.
    }
  }

  Future<void> _loadTaskDetails(Task taskToLoad) async {
    try {
      final TaskDetailsResponse taskDetails =
          await widget.taskService.getTaskDetails(taskToLoad.taskId);
      setState(() {
        currentTask = taskDetails.currentTask;
        tasks = taskDetails.subTasks;
        pathEnumeration = taskDetails.pathEnumeration;
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
          CurrentTaskDisplay(
            currentTask: currentTask,
            onCheckboxToggle: _toggleTaskStatus,
            onDelete: _deleteTask,
            onEdit: _openTaskEditorScreen,
            onBackPressed: () => _navigateToParent(),
          ),
          Expanded(
            child: ListView(
              children: TaskLifecycleType.values.expand((type) {
                final tasksForType = tasks
                    .where((task) => task.taskLifecycleType == type)
                    .toList();
                return [
                  TaskListSection(
                      lifecycleType: type,
                      tasks: tasksForType,
                      onCheckboxToggle: _toggleTaskStatus,
                      onEdit: _openTaskEditorScreen,
                      onDelete: _deleteTask,
                      onTap: _handleTaskTap),
                  const SizedBox(height: 20.0), // Spacing between sections
                ];
              }).toList(),
            ),
          ),
          TaskCreateWidget(
            onCreateTask: _createTask,
            currentParentTaskId: currentTask.taskId,
          )
        ],
      ),
    );
  }

  void _handleTaskTap(Task selectedTask) {
    _loadTaskDetails(selectedTask);
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
      if (taskToDelete.parentId == null) {
        return;
      }

      await widget.taskService.deleteTask(taskToDelete.taskId);

      if (!context.mounted) return;

      if (taskToDelete.taskId == currentTask.taskId) {
        setState(() {
          _navigateToParent();
        });
      } else {
        setState(() {
          tasks.remove(taskToDelete);
        });
      }
    } catch (exception) {
      //failed to delete task
    }
  }

  void _navigateToParent() {
    var parentTask = pathEnumeration[pathEnumeration.length - 2];
    _loadTaskDetails(parentTask);
  }
}
