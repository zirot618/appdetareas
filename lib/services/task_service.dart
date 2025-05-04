import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/task.dart';

// Servicio encargado de manejar la persistencia de datos
class TaskService {
  // Clave única para almacenar las tareas en SharedPreferences
  static const _key = 'tasks';

  // Método para cargar las tareas desde el almacenamiento
  Future<List<Task>> loadTasks() async {
    // Obtiene la instancia de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    
    // Intenta obtener las tareas guardadas como string JSON
    final jsonString = prefs.getString(_key);
    
    // Si no hay tareas guardadas, devuelve una lista vacía
    if (jsonString == null) return [];
    
    // Convierte el string JSON a una lista de objetos
    final List<dynamic> jsonList = json.decode(jsonString);
    
    // Convierte cada objeto JSON en una tarea
    return jsonList.map((json) => Task.fromJson(json)).toList();
  }

  // Método para guardar las tareas en el almacenamiento
  Future<void> saveTasks(List<Task> tasks) async {
    // Obtiene la instancia de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    
    // Convierte la lista de tareas a formato JSON
    final jsonString = json.encode(tasks.map((t) => t.toJson()).toList());
    
    // Guarda el JSON en SharedPreferences
    await prefs.setString(_key, jsonString);
  }
}
