import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharp_wing_frontend/widgets/current_task_display.dart';
import 'package:sharp_wing_frontend/widgets/current_task_item.dart';

import '../../mock/mock_task_data_layer.dart';
import 'package:sharp_wing_frontend/models/task.dart';

void main() {
  group('CurrentTaskDisplay Widget Tests', () {
    MockTaskDataLayer mockTaskDataLayer = MockTaskDataLayer();
    Task currentTask = mockTaskDataLayer.getTaskById(1)!;

    testWidgets('CurrentTaskDisplay contains all elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrentTaskDisplay(
              currentTask: currentTask,
              onCheckboxToggle: (taskToUpdate, newValue) {},
              onDelete: (taskToDelete) {},
              onEdit: (editTask) {},
              onBackPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text("Current Task"), findsOneWidget);
      expect(find.byType(CurrentTaskItem), findsOneWidget);
    });
  });
}
