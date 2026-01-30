import 'package:flutter/material.dart';
import 'package:focuspocus/models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) => onToggle(),
          activeColor: const Color(0xFFE91E63),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18,
            decoration:
                task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
            color: task.isCompleted
                ? Colors.grey
                : const Color(0xFF880E4F),
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getCategoryColor(task.category),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                task.category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${task.createdAt.day}/${task.createdAt.month}/${task.createdAt.year}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete),
              color: const Color(0xFFE91E63),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Work':
        return const Color(0xFFE91E63);
      case 'Study':
        return const Color(0xFF9C27B0);
      case 'Personal':
        return const Color(0xFF3F51B5);
      case 'Other':
        return const Color(0xFF009688);
      default:
        return const Color(0xFFE91E63);
    }
  }
}