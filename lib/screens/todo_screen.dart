import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:focuspocus/providers/task_provider.dart';
import 'package:focuspocus/models/task.dart';
import 'package:focuspocus/widgets/task_tile.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _taskController = TextEditingController();
  String _selectedCategory = 'Work';

  void _addTask() {
    if (_taskController.text.isEmpty) return;

    final task = Task(
      title: _taskController.text,
      category: _selectedCategory,
    );

    Provider.of<TaskProvider>(context, listen: false).addTask(task);
    _taskController.clear();
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: const [
                  DropdownMenuItem(
                    value: 'Work',
                    child: Text('Work'),
                  ),
                  DropdownMenuItem(
                    value: 'Study',
                    child: Text('Study'),
                  ),
                  DropdownMenuItem(
                    value: 'Personal',
                    child: Text('Personal'),
                  ),
                  DropdownMenuItem(
                    value: 'Other',
                    child: Text('Other'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addTask();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFFCE4EC),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Tasks',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF880E4F),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _showAddTaskDialog,
                      icon: const Icon(Icons.add),
                      color: const Color(0xFFE91E63),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: provider.tasks.isEmpty
                    ? const Center(
                        child: Text(
                          'No tasks yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFAD1457),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: provider.tasks.length,
                        itemBuilder: (context, index) {
                          final task = provider.tasks[index];
                          return TaskTile(
                            task: task,
                            onToggle: () {
                              provider.toggleTaskCompletion(task.id!);
                            },
                            onDelete: () {
                              provider.deleteTask(task.id!);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddTaskDialog,
            backgroundColor: const Color(0xFFE91E63),
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}