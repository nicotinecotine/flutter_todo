import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:flutter_todo/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskProvider extends ChangeNotifier {
  List _tasksNotCompleted = [
    Task(
      'workingtitle256',
      'no',
      DateTime.now(),
      true,
      false,
    ),
  ];
  List _completedTasks = [];
  bool _isCompletedVisible = false;
  int _completedTasksCount = 0;

  List get tasksNotCompleted => _tasksNotCompleted;
  List get completedTasks => _completedTasks;
  bool get isCompletedVisible => _isCompletedVisible;
  int get completedTaskCount => _completedTasksCount;

  TaskProvider() {
    loadStateFromSharedPreferences();
  }

  void saveStateToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'tasksNotCompleted',
      _tasksNotCompleted.map((task) => json.encode(task.toJson())).toList(),
    );
    await prefs.setStringList(
      'completedTasks',
      _completedTasks.map((task) => json.encode(task.toJson())).toList(),
    );
    await prefs.setInt('completedTasksCount', _completedTasksCount);
  }

  void loadStateFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksNotCompletedJson = prefs.getStringList('tasksNotCompleted');
    final completedTasksJson = prefs.getStringList('completedTasks');
    final completedTasksCount = prefs.getInt('completedTasksCount');

    if (tasksNotCompletedJson != null) {
      _tasksNotCompleted = tasksNotCompletedJson
          .map((json) => Task.fromJson(jsonDecode(json)))
          .toList();
    }

    if (completedTasksJson != null) {
      _completedTasks = completedTasksJson
          .map((json) => Task.fromJson(jsonDecode(json)))
          .toList();
    }

    if (completedTasksCount != null) {
      _completedTasksCount = completedTasksCount;
    }
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasksNotCompleted.remove(task);
    notifyListeners();
    saveStateToSharedPreferences();
  }

  void changeVisibility() {
    _isCompletedVisible = !_isCompletedVisible;
    notifyListeners();
    saveStateToSharedPreferences();
  }

  void updateCount() {
    _completedTasksCount = _completedTasks.length;
    notifyListeners();
    saveStateToSharedPreferences();
  }

  void updateList() {
    notifyListeners();
    saveStateToSharedPreferences();
  }

  void addTask(
    String title,
    String importance,
    DateTime? taskDate,
    bool isDone,
    bool isSwitched,
  ) {
    final task = Task(
      title,
      importance,
      taskDate,
      isDone,
      isSwitched,
    );
    final button = Task('workingtitle256', importance, taskDate, isDone, false);
    _tasksNotCompleted.removeLast();
    _tasksNotCompleted.add(task);
    _tasksNotCompleted.add(button);
    notifyListeners();
    saveStateToSharedPreferences();
  }
}
