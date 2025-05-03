class Task {
  String title;
  bool done;

  Task({required this.title, this.done = false});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(title: json['title'], done: json['done']);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'done': done};
  }
}
