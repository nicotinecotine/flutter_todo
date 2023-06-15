import 'package:flutter/widgets.dart';
import 'package:flutter_todo/models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  List _tasksNotCompleted = [
    Task(
      'workingtitle256',
      'no',
      DateTime.now(),
      true,
    )
  ];
  List _allTasks = [
    Task(
      'workingtitle256',
      'no',
      DateTime.now(),
      true,
    )
  ];
  bool _isCompletedVisible = false;

  List get tasksNotCompleted => _tasksNotCompleted;
  List get allTasks => _allTasks;
  bool get isCompletedVisible => _isCompletedVisible;

  void addTask(
    String title,
    String importance,
    DateTime? taskDate,
    bool isDone,
  ) {
    final task = Task(title, importance, taskDate, isDone);
    final button = Task('workingtitle256', importance, taskDate, isDone);
    _tasksNotCompleted.removeLast();
    _tasksNotCompleted.add(task);
    _tasksNotCompleted.add(button);
    _allTasks.removeLast();
    _allTasks.add(task);
    _allTasks.add(button);
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasksNotCompleted.remove(task);
    notifyListeners();
  }

  void changeVisibility() {
    _isCompletedVisible = !_isCompletedVisible;
    notifyListeners();
  }
}
