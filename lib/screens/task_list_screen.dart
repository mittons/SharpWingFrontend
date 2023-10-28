// lib/screens/task_list.dart

import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/screens/task_edit_screen.dart';
import 'package:sharp_wing_frontend/services/task_service_result.dart';
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
  List<Task> subtasks = [];
  late Task
      currentTask; // Initialized later and should never be null afterwards.
  List<Task> pathEnumeration = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRootAndLoadDetails();
  }

  //TODO: Backlog - Setup handling of unsuccessful TaskService result
  Future<void> _fetchRootAndLoadDetails() async {
    TaskServiceResult result = await widget.taskService.getRootTask();
    if (result.success) {
      Task rootTask = result.data;
      _loadTaskDetails(rootTask);
    } else {
      //handle unsuccessful fetch of root task
    }
  }

  //TODO: Backlog - Setup handling of unsuccessful TaskService result
  Future<void> _loadTaskDetails(Task taskToLoad) async {
    TaskServiceResult result =
        await widget.taskService.getTaskDetails(taskToLoad.taskId);

    if (result.success) {
      final TaskDetailsResponse taskDetails = result.data;

      setState(() {
        currentTask = taskDetails.currentTask;
        subtasks = taskDetails.subTasks;
        pathEnumeration = taskDetails.pathEnumeration;
        isLoading = false;
      });
    } else {
      //handle unsuccessful fetch of task details response
    }
  }

  //TODO: fix so that edit task function also allows for edits on the current task
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Task List'),
          ),
          body: const Center(
              child: CircularProgressIndicator()) // Show a loading indicator
          );
    }
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
                final tasksForType = subtasks
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
              if (currentTask.taskId == updatedTask.taskId) {
                currentTask = updatedTask;
              } else {
                int index = subtasks
                    .indexWhere((task) => task.taskId == updatedTask.taskId);
                //Ensure the task being updated is either the current task or in the list of subtasks
                assert(index != -1);
                if (index != -1) {
                  subtasks[index] = updatedTask;
                }
              }
            });
          },
        ),
      ),
    );
  }

  //TODO: Clean code thats commented out
  //TODO: Backlog - Setup handling of unsuccessful TaskService result
  Future<void> _toggleTaskStatus(Task taskToUpdate, newValue) async {
    var oldStatusValue = taskToUpdate.status;

    taskToUpdate.status = newValue! ? 'completed' : 'not completed';

    TaskServiceResult result =
        await widget.taskService.updateTask(taskToUpdate.taskId, taskToUpdate);

    if (!context.mounted) return;

    if (result.success) {
      //Ensure the list of tasks this screen displays contains the task item (with the updated info)
      //  and if not then it should be the current task displayed in this screen.
      //Could be triggered if the caller of this function sent us a new instance of a task object.
      //If that happens we can extend this code to look for task by id and make edits to that task
      //  (and assert that there exists a task with equal id).
      assert(subtasks.contains(taskToUpdate) || currentTask == taskToUpdate);

      setState(() {});
    } else {
      taskToUpdate.status = oldStatusValue;
      //handle unsuccessful update
    }

    // _showSnackbar();
    // _showDialog();
  }

  //TODO: Backlog - Setup handling of unsuccessful TaskService result
  Future<void> _createTask(Task createdTask) async {
    TaskServiceResult result = await widget.taskService.createTask(createdTask);

    if (!context.mounted) return;

    if (result.success) {
      Task createdTaskFromApi = result.data;

      setState(() {
        subtasks.add(createdTaskFromApi);
      });
    } else {
      //handle unsuccessful task creation
    }
  }

  //TODO: Backlog - Setup handling of unsuccessful TaskService result
  Future<void> _deleteTask(Task taskToDelete) async {
    if (taskToDelete.parentId == null) {
      return;
    }

    //Ensure the list of tasks this screen displays contains the task item to be deleted
    //  and if not then it should be the current task displayed on this screen.
    //Could be triggered in the future if the caller of this function sent us a new instance of a task object
    assert(subtasks.contains(taskToDelete) || currentTask == taskToDelete);

    TaskServiceResult result =
        await widget.taskService.deleteTask(taskToDelete.taskId);

    if (!context.mounted) return;

    if (result.success) {
      if (taskToDelete.taskId == currentTask.taskId) {
        setState(() {
          _navigateToParent();
        });
      } else {
        setState(() {
          subtasks.remove(taskToDelete);
        });
      }
    } else {
      //handle unsuccessful delete
    }
  }

  void _navigateToParent() {
    var parentTask = pathEnumeration[pathEnumeration.length - 2];
    _loadTaskDetails(parentTask);
  }

  //TODO: Remove or rework
  void _showSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This is an error message'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  //TODO: Remove or rework
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Critical error message'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
