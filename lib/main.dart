// lib/main.dart

import 'package:flutter/material.dart';
import 'package:sharp_wing_frontend/screens/task_list.dart';

void main() {
  runApp(TaskListApp());
}

class TaskListApp extends StatelessWidget {
  const TaskListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(),
    );
  }
}
