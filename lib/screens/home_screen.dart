import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Instancia del servicio de persistencia
  final TaskService _taskService = TaskService();
  final TextEditingController _controller = TextEditingController();
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Carga las tareas al iniciar la pantalla
    _loadTasks();
  }

  // Método para cargar las tareas desde el almacenamiento
  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    // Obtiene las tareas guardadas
    final loaded = await _taskService.loadTasks();
    setState(() {
      _tasks = loaded;
      // Asegura que todas las tareas tengan un orden válido
      for (var i = 0; i < _tasks.length; i++) {
        _tasks[i].order = i;
      }
      _sortTasks();
      _isLoading = false;
    });
  }

  // Método para guardar las tareas en el almacenamiento
  Future<void> _saveTasks() async {
    await _taskService.saveTasks(_tasks);
  }

  // Método para agregar una nueva tarea
  void _addTask(String title) {
    if (title.trim().isEmpty) return;
    setState(() {
      _tasks.add(Task(
        title: title,
        order: _tasks.length, // Asigna el siguiente orden disponible
      ));
      _sortTasks();
      _controller.clear();
    });
    // Guarda las tareas después de agregar una nueva
    _saveTasks();
  }

  // Método para cambiar el estado de una tarea
  void _toggleTask(int index) {
    setState(() {
      _tasks[index].done = !_tasks[index].done;
      _sortTasks();
    });
    // Guarda las tareas después de cambiar el estado
    _saveTasks();
  }

  // Método para mover una tarea hacia arriba
  void _moveTaskUp(int index) {
    if (index > 0 && !_tasks[index].done) {
      setState(() {
        // Intercambia las tareas directamente
        final task = _tasks[index];
        _tasks[index] = _tasks[index - 1];
        _tasks[index - 1] = task;
        
        // Actualiza los órdenes
        for (var i = 0; i < _tasks.length; i++) {
          _tasks[i].order = i;
        }
      });
      _saveTasks();
    }
  }

  // Método para mover una tarea hacia abajo
  void _moveTaskDown(int index) {
    if (index < _tasks.length - 1 && !_tasks[index].done) {
      setState(() {
        // Intercambia las tareas directamente
        final task = _tasks[index];
        _tasks[index] = _tasks[index + 1];
        _tasks[index + 1] = task;
        
        // Actualiza los órdenes
        for (var i = 0; i < _tasks.length; i++) {
          _tasks[i].order = i;
        }
      });
      _saveTasks();
    }
  }

  // Método para eliminar una tarea
  void _deleteTask(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Eliminar tarea?'),
        content: Text('¿Estás seguro de que deseas eliminar esta tarea?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _tasks.removeAt(index);
                // Reasigna los órdenes después de eliminar
                for (var i = 0; i < _tasks.length; i++) {
                  _tasks[i].order = i;
                }
              });
              // Guarda las tareas después de eliminar una
              _saveTasks();
              Navigator.of(context).pop();
            },
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Método para ordenar las tareas (por estado y orden)
  void _sortTasks() {
    _tasks.sort((a, b) {
      // Primero ordena por estado (completadas al final)
      if (a.done != b.done) {
        return a.done ? 1 : -1;
      }
      // Luego ordena por el orden asignado
      return a.order.compareTo(b.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Tareas'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadTasks,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Agregar nueva tarea...',
                          prefixIcon: Icon(Icons.add_task),
                        ),
                        onSubmitted: _addTask,
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _addTask(_controller.text),
                      icon: Icon(Icons.add),
                      label: Text('Agregar'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_tasks.where((t) => t.done).length} de ${_tasks.length} tareas completadas',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _tasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_alt,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No hay tareas pendientes',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) => Card(
                          elevation: 2,
                          margin: EdgeInsets.only(bottom: 8),
                          color: _tasks[index].done 
                              ? Colors.indigo[350]  // Morado más claro para tareas completadas
                              : Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TaskTile(
                            task: _tasks[index],
                            onToggle: () => _toggleTask(index),
                            onDelete: () => _deleteTask(index),
                            onMoveUp: () => _moveTaskUp(index),
                            onMoveDown: () => _moveTaskDown(index),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
