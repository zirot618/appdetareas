import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  final TextEditingController _controller = TextEditingController();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loaded = await _taskService.loadTasks();
    setState(() {
      _tasks = loaded;
    });
  }

  Future<void> _saveTasks() async {
    await _taskService.saveTasks(_tasks);
  }

  void _addTask(String title) {
    if (title.trim().isEmpty) return;
    setState(() {
      _tasks.add(Task(title: title));
      _sortTasks();
      _controller.clear();
    });
    _saveTasks();
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].done = !_tasks[index].done;
      _sortTasks();
    });
    _saveTasks();
  }

  void _deleteTask(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('¿Eliminar tarea?'),
            content: Text('¿Estás seguro de que deseas eliminar esta tarea?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _tasks.removeAt(index);
                  });
                  _saveTasks();
                  Navigator.of(context).pop();
                },
                child: Text('Eliminar', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      if (a.done == b.done) return 0;
      return a.done ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Tareas')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Nueva tarea',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addTask(_controller.text),
                  child: Text('Agregar'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_tasks.where((t) => t.done).length} de ${_tasks.length} tareas completadas',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child:
                _tasks.isEmpty
                    ? Center(child: Text('No hay tareas aún.'))
                    : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder:
                          (context, index) => TaskTile(
                            task: _tasks[index],
                            onToggle: () => _toggleTask(index),
                            onDelete: () => _deleteTask(index),
                          ),
                    ),
          ),
        ],
      ),
    );
  }
}
