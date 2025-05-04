// Modelo que representa una tarea individual
class Task {
  String title;  // Título de la tarea
  bool done;     // Estado de la tarea (completada o no)

  Task({required this.title, this.done = false});

  // Método para convertir un objeto JSON a una tarea
  // Se usa cuando se cargan las tareas desde el almacenamiento
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],  // Extrae el título del JSON
      done: json['done'],    // Extrae el estado del JSON
    );
  }

  // Método para convertir una tarea a formato JSON
  // Se usa cuando se guardan las tareas en el almacenamiento
  Map<String, dynamic> toJson() {
    return {
      'title': title,  // Guarda el título en el JSON
      'done': done,    // Guarda el estado en el JSON
    };
  }
}
