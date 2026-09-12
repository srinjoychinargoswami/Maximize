import 'package:flutter/material.dart';
import 'package:kinetic/models/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;

  void addTask(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(TaskModel task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void updateTask(TaskModel task) {
    final index = _tasks.indexWhere((element) => element.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }
}