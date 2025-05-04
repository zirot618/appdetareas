import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  TaskTile({
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onMoveUp,
    required this.onMoveDown,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: task.done ? Colors.green.withOpacity(0.2) : Colors.white.withOpacity(0.2),
        ),
        child: IconButton(
          icon: Icon(
            task.done ? Icons.check_circle : Icons.circle_outlined,
            color: task.done ? Colors.green : Colors.white,
          ),
          onPressed: onToggle,
        ),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          fontSize: 16,
          decoration: task.done ? TextDecoration.lineThrough : null,
          color: task.done ? Colors.grey[300] : Colors.white,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!task.done) ...[
            IconButton(
              icon: Icon(Icons.arrow_upward, color: Colors.white70),
              onPressed: onMoveUp,
            ),
            IconButton(
              icon: Icon(Icons.arrow_downward, color: Colors.white70),
              onPressed: onMoveDown,
            ),
          ],
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.white70),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

