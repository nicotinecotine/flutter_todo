import 'package:flutter/widgets.dart';

class EditProvider extends ChangeNotifier {
  String _toDo = '';
  String _importancy = 'Нет';
  bool _isSwitched = false;
  bool _isCompleted = false;
  bool _isEdit = false;
  int _index = 0;
  DateTime _date = DateTime.now();

  String get toDo => _toDo;
  String get importancy => _importancy;
  bool get isSwitched => _isSwitched;
  bool get isCompleted => _isCompleted;
  bool get isEdit => _isEdit;
  int get index => _index;
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

  void changeIsCompleted(bool isCompleted) {
    _isCompleted = isCompleted;
    notifyListeners();
  }

  void changeIsEdit(bool isEdit) {
    _isEdit = isEdit;
    notifyListeners();
  }

  void edit(
    String title,
    String importancy,
    DateTime date,
    bool switchValue,
    bool isEdit,
    bool isCompleted,
    int index,
  ) {
    _toDo = title;
    _importancy = importancy;
    _date = date;
    _isSwitched = switchValue;
    _isEdit = isEdit;
    _isCompleted = isCompleted;
    _index = index;
    notifyListeners();
  }
}
