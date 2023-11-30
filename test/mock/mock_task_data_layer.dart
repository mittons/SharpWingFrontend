import 'package:sharp_wing_frontend/models/task.dart';

class MockTaskDataLayer {
  List<Task> tasks = [];
  int nextTaskId = 0;

  MockTaskDataLayer() {
    _createMockTasks();
    nextTaskId = tasks.last.taskId + 1;
  }

  List<Task> getAllTasks() {
    return tasks;
  }

  Task? getTaskById(int taskId) {
    return tasks.where((task) => task.taskId == taskId).firstOrNull;
  }

  Task addTask(Task task) {
    Task taskToAdd = Task(
        taskId: nextTaskId++,
        parentId: task.parentId,
        taskName: task.taskName,
        description: task.description,
        createdDate: task.createdDate,
        status: task.status,
        taskLifecycleType: task.taskLifecycleType);
    tasks.add(taskToAdd);

    return taskToAdd;
  }

  void updateTask(Task updatedTask) {
    Task? existingTask = getTaskById(updatedTask.taskId);
    if (existingTask != null) {
      existingTask.taskName = updatedTask.taskName;
      existingTask.description = updatedTask.description;
      existingTask.status = updatedTask.status;
      existingTask.taskLifecycleType = updatedTask.taskLifecycleType;

      // parentId does not get updated (no functionality implemented that allows for changes in task hierarchy).
    }
  }

  void deleteTask(int taskId) {
    Task? taskToRemove = getTaskById(taskId);
    if (taskToRemove != null) {
      tasks.remove(taskToRemove);
    }
  }

  void _createMockTasks() {
    tasks = [
      Task(
        taskId: 0,
        parentId: null,
        taskName: "Home",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Recurring,
      ),
      Task(
        taskId: 1,
        parentId: 0,
        taskName: "Daily - Weekday",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Recurring,
      ),
      Task(
        taskId: 2,
        parentId: 0,
        taskName: "Daily - Weekend",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Recurring,
      ),
      Task(
        taskId: 3,
        parentId: 0,
        taskName: "Piano practice",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.AdHoc,
      ),
      Task(
        taskId: 4,
        parentId: 0,
        taskName: "Cooking skill",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.AdHoc,
      ),
      Task(
        taskId: 5,
        parentId: 0,
        taskName: "Cross stitch projects",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.AdHoc,
      ),
      Task(
        taskId: 6,
        parentId: 1,
        taskName: "Breakfast",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Setup,
      ),
      Task(
        taskId: 7,
        parentId: 1,
        taskName: "Brush teeth",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Setup,
      ),
      Task(
        taskId: 8,
        parentId: 1,
        taskName: "Make bed",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Setup,
      ),
      Task(
        taskId: 9,
        parentId: 1,
        taskName: "Gather work bag, gym bag, and essentials",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Setup,
      ),
      Task(
        taskId: 10,
        parentId: 1,
        taskName: "Gym",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Recurring,
      ),
      Task(
        taskId: 11,
        parentId: 1,
        taskName: "Work",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Recurring,
      ),
      Task(
        taskId: 12,
        parentId: 1,
        taskName: "Put gym stuff in laundry and prepare next day's gym bag",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Closure,
      ),
      Task(
        taskId: 13,
        parentId: 1,
        taskName: "Put away work bag",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Closure,
      ),
      Task(
        taskId: 14,
        parentId: 1,
        taskName: "Plan activities post work",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Closure,
      ),
      Task(
        taskId: 15,
        parentId: 2,
        taskName: "Breakfast",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Setup,
      ),
      Task(
        taskId: 16,
        parentId: 2,
        taskName: "Brush teeth",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Setup,
      ),
      Task(
        taskId: 17,
        parentId: 2,
        taskName: "Make bed",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Setup,
      ),
      Task(
        taskId: 18,
        parentId: 2,
        taskName: "Work on a skillbuilding hobby",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Recurring,
      ),
      Task(
        taskId: 19,
        parentId: 2,
        taskName: "Plan leisure activities for the rest of the day",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Closure,
      ),
      Task(
        taskId: 20,
        parentId: 3,
        taskName: "Determine song to practice and fetch sheets",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Setup,
      ),
      Task(
        taskId: 21,
        parentId: 3,
        taskName: "Turn piano on",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Setup,
      ),
      Task(
        taskId: 22,
        parentId: 3,
        taskName: "Practice song",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Recurring,
      ),
      Task(
        taskId: 23,
        parentId: 3,
        taskName: "Remember counting",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Recurring,
      ),
      Task(
        taskId: 24,
        parentId: 3,
        taskName:
            "Remember putting equal strength into dominant and non-dominant hand",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Recurring,
      ),
      Task(
        taskId: 25,
        parentId: 3,
        taskName: "Remember practicing each hand separately first",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Recurring,
      ),
      Task(
        taskId: 26,
        parentId: 3,
        taskName: "Remember sight-reading every note",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Recurring,
      ),
      Task(
        taskId: 27,
        parentId: 3,
        taskName: "Remember going as slow as I need",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Recurring,
      ),
      Task(
        taskId: 28,
        parentId: 3,
        taskName: "Turn piano off",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Closure,
      ),
      Task(
        taskId: 29,
        parentId: 3,
        taskName: "Return sheet music to the sheet music folder",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Closure,
      ),
      Task(
        taskId: 30,
        parentId: 4,
        taskName: "Select recipe to learn",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Setup,
      ),
      Task(
        taskId: 31,
        parentId: 4,
        taskName: "Determine which materials are not in stock",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Setup,
      ),
      Task(
        taskId: 32,
        parentId: 4,
        taskName: "Go grocery shopping",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Setup,
      ),
      Task(
        taskId: 33,
        parentId: 4,
        taskName: "Clear work area and gather tools/materials for recipe",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Setup,
      ),
      Task(
        taskId: 34,
        parentId: 4,
        taskName: "Read recipe through and stage work area",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Setup,
      ),
      Task(
        taskId: 35,
        parentId: 4,
        taskName: "Follow recipe",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Recurring,
      ),
      Task(
        taskId: 36,
        parentId: 4,
        taskName: "Plate food",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Recurring,
      ),
      Task(
        taskId: 37,
        parentId: 4,
        taskName: "Put away leftover materials",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Closure,
      ),
      Task(
        taskId: 38,
        parentId: 4,
        taskName: "Clean work area",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Closure,
      ),
      Task(
        taskId: 39,
        parentId: 4,
        taskName: "Clean tools and return to storage",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Closure,
      ),
      Task(
        taskId: 40,
        parentId: 4,
        taskName: "Learn to cook dumplings",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.AdHoc,
      ),
      Task(
        taskId: 41,
        parentId: 4,
        taskName: "Learn to cook teriyaki chicken",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.AdHoc,
      ),
      Task(
        taskId: 42,
        parentId: 4,
        taskName: "Search for more vegetarian recipes",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.AdHoc,
      ),
      Task(
        taskId: 43,
        parentId: 4,
        taskName:
            "Research vegetarian substitutes for non-vegetarian ingredients",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.AdHoc,
      ),
      Task(
        taskId: 44,
        parentId: 5,
        taskName: "Clear workspace",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Setup,
      ),
      Task(
        taskId: 45,
        parentId: 5,
        taskName: "Fetch workbag and withdraw tools/materials/pattern",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Setup,
      ),
      Task(
        taskId: 46,
        parentId: 5,
        taskName: "Work on pattern",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Recurring,
      ),
      Task(
        taskId: 47,
        parentId: 5,
        taskName: "Return tools/materials/pattern to workbag and store the bag",
        description: "",
        createdDate: DateTime.now(),
        status: "not completed",
        taskLifecycleType: TaskLifecycleType.Closure,
      ),
    ];
  }
}
