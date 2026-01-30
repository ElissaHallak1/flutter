import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focuspocus/main.dart'; 
import 'package:focuspocus/widgets/task_tile.dart';
import 'package:focuspocus/models/task.dart';

void main() {
  testWidgets('TaskTile displays task information', (WidgetTester tester) async {
    final task = Task(
      title: 'Test Task',
      category: 'Work',
      isCompleted: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskTile(
            task: task,
            onToggle: () {},
            onDelete: () {},
          ),
        ),
      ),
    );

    expect(find.text('Test Task'), findsOneWidget);
    expect(find.text('Work'), findsOneWidget);
  });

  testWidgets('App starts', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('FocusPocus'), findsOneWidget);
  });
}