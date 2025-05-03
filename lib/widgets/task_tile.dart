import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  TaskTile({
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(value: task.done, onChanged: (_) => onToggle()),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.done ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
    );
  }
}
