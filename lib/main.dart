// lib/main.dart

import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/screens/task_list_screen.dart';
import 'package:sharp_wing_frontend/config/config.dart';
import 'package:sharp_wing_frontend/services/task_service.dart';

AppConfig activeConfig = ProductionConfig();

void main() {
  // Load configuration based on environment or configuration profile
  // Example: Set activeConfig to TestConfig for testing
  activeConfig = DevConfig();
  runApp(TaskListApp(config: activeConfig));
}

class TaskListApp extends StatelessWidget {
  final AppConfig config;

  const TaskListApp({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(
        taskService: TaskService(baseApiUrl: config.baseApiUrl),
      ),
    );
  }
}
