// test/mock/mock_data.dart

import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/models/task_details_response.dart';

// A mock root task
final mockRootTask = Task(
  taskId: 0,
  parentId: null,
  taskName: "Home",
  description: "",
  createdDate: DateTime.now(),
  status: "not completed",
  taskLifecycleType: TaskLifecycleType.Recurring,
);

// A list of mock sub-tasks
final List<Task> mockSubTasks = [
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
];

// A mock TaskDetailsResponse for the root task
final mockTaskDetailsResponse = TaskDetailsResponse(
  currentTask: mockRootTask,
  subTasks: mockSubTasks,
  // Here I'm assuming pathEnumeration is a list of Tasks
  // leading to the current task. Adjust as necessary.
  pathEnumeration: [mockRootTask],
);

// Additional mock data can be added here as needed.
