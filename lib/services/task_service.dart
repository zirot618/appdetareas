import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/task.dart';

class TaskService {
  static const _key = 'tasks';

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Task.fromJson(json)).toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }
}
