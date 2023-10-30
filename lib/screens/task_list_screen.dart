// lib/screens/task_list.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/screens/task_edit_screen.dart';
import 'package:sharp_wing_frontend/services/task_service_result.dart';
import 'package:sharp_wing_frontend/widgets/task_create_widget.dart';
import 'package:sharp_wing_frontend/widgets/task_list_section.dart';
import 'package:sharp_wing_frontend/widgets/current_task_display.dart';
import 'package:sharp_wing_frontend/services/task_service.dart';
import 'package:sharp_wing_frontend/models/task_details_response.dart';
import 'package:sharp_wing_frontend/helpers/ui_helper.dart';

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

    if (!context.mounted) return;

    if (!result.success) {
      while (true) {
        bool shouldRetry = await UiHelper.showRetryOrCancelDialog(
          context: context,
          title: "Error",
          message: "Failed to load home task. Service error.",
        );

        if (!context.mounted) return;

        if (!shouldRetry) {
          Navigator.pop(context);
          return;
        }

        if (shouldRetry) {
          result = await widget.taskService.getRootTask();

          if (!context.mounted) return;

          if (result.success) {
            break;
          }
        }
      }
    }

    assert(result.success);

    Task rootTask = result.data;

    //load tasklist
    bool subTaskLoadSuccess = await _loadTaskDetails(rootTask);

    if (!subTaskLoadSuccess) {
      while (true) {
        bool shouldRetry = await UiHelper.showRetryOrCancelDialog(
          context: context,
          title: "Error",
          message: "Failed to load task list. Service error.",
        );

        if (!context.mounted) return;

        if (!shouldRetry) {
          Navigator.pop(context);
          return;
        }

        if (shouldRetry) {
          subTaskLoadSuccess = await _loadTaskDetails(rootTask);

          if (!context.mounted) return;

          if (result.success) {
            break;
          }
        }
      }
    }
  }

  //TODO: Backlog - Setup handling of unsuccessful TaskService result
  Future<bool> _loadTaskDetails(Task taskToLoad) async {
    TaskServiceResult result =
        await widget.taskService.getTaskDetails(taskToLoad.taskId);

    if (!context.mounted) return false;

    if (result.success) {
      final TaskDetailsResponse taskDetails = result.data;

      setState(() {
        currentTask = taskDetails.currentTask;
        subtasks = taskDetails.subTasks;
        pathEnumeration = taskDetails.pathEnumeration;
        isLoading = false;
      });
      bool success = true;
      return success;
    } else {
      UiHelper.displaySnackbar(
          context, "Failed to expand task. Service error.");
      bool success = false;
      return success;
    }
  }

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
          _buildCurrentTaskDisplay(),
          Expanded(child: _buildSubTasksListView()),
          TaskCreateWidget(
            onCreateTask: _createTask,
            currentParentTaskId: currentTask.taskId,
          )
        ],
      ),
    );
  }

  Widget _buildCurrentTaskDisplay() {
    return CurrentTaskDisplay(
      currentTask: currentTask,
      onCheckboxToggle: _toggleTaskStatus,
      onDelete: _deleteTask,
      onEdit: _openTaskEditorScreen,
      onBackPressed: () => _navigateToParent(),
    );
  }

  Widget _buildSubTasksListView() {
    return ListView(
      children: TaskLifecycleType.values.expand((type) {
        final tasksForType =
            subtasks.where((task) => task.taskLifecycleType == type).toList();
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

  //TODO: Backlog - Review error message
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
      UiHelper.displaySnackbar(
          context, "Failed to change task status. Service error.");
    }
  }

  //TODO: Backlog - Review error message
  Future<void> _createTask(Task createdTask) async {
    TaskServiceResult result = await widget.taskService.createTask(createdTask);

    if (!context.mounted) return;

    if (result.success) {
      Task createdTaskFromApi = result.data;

      setState(() {
        subtasks.add(createdTaskFromApi);
      });
    } else {
      UiHelper.displaySnackbar(
          context, "Failed to create task. Service error.");
    }
  }

  //TODO: Backlog - Review error message
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
      UiHelper.displaySnackbar(
          context, "Failed to delete task. Service error.");
    }
  }

  void _navigateToParent() {
    var parentTask = pathEnumeration[pathEnumeration.length - 2];
    _loadTaskDetails(parentTask);
  }
}
