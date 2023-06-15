import 'package:flutter/widgets.dart';

class EditProvider extends ChangeNotifier {
  String _toDo = '';
  String _importancy = 'Нет';
  bool _isSwitched = false;
  bool _isCompleted = false;
  DateTime _date = DateTime.now();

  String get toDo => _toDo;
  String get importancy => _importancy;
  bool get isSwitched => _isSwitched;
  bool get isCompleted => _isCompleted;
  DateTime get date => _date;

  void toSwitch() {
    _isSwitched = !_isSwitched;
    notifyListeners();
  }

  void changeToDo(String value) {
    _toDo = value;
    notifyListeners();
  }

  void changeImportancy(String value) {
    _importancy = value;
    notifyListeners();
  }

  void changeDate(DateTime value) {
    _date = value;
    notifyListeners();
  }

  void changeSwitch(bool isSwitch) {
    _isSwitched = isSwitch;
    notifyListeners();
  }
}
