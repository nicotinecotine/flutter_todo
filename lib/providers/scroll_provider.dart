import 'package:flutter/widgets.dart';

class ScrollProvider extends ChangeNotifier {
  ScrollController _scrollController = ScrollController();
  double _titleLeftPadding = 70.0;
  double _titleBottomPadding = 0;
  double _bottomEyeTransparency = 1;
  bool _topEyeVisibility = false;

  ScrollController get scrollController => _scrollController;
  double get titleLeftPadding => _titleLeftPadding;
  double get titleBottomPadding => _titleBottomPadding;
  double get bottomEyeTransparency => _bottomEyeTransparency;
  bool get topEyeVisibility => _topEyeVisibility;

  ScrollProvider() {
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && _scrollController.offset <= 60) {
      double progress = _scrollController.offset / 60;
      _titleLeftPadding = 70 - (44 * progress * 1.25);
      _titleBottomPadding = 0 + (16 * progress);
      _bottomEyeTransparency = 1 - progress;
      _topEyeVisibility = false;
      notifyListeners();
    } else if (_scrollController.offset <= 0) {
      _titleLeftPadding = 70.0;
      _titleBottomPadding = 0;
      _bottomEyeTransparency = 1;
      _topEyeVisibility = false;
      notifyListeners();
    } else {
      _titleLeftPadding = 16.0;
      _titleBottomPadding = 16;
      _bottomEyeTransparency = 0;
      _topEyeVisibility = true;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
