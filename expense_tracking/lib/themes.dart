import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDartMode = false;
  void updateTheme({required bool mode}) {
    _isDartMode = mode;
    notifyListeners();
  }

  bool get mode => _isDartMode;
}
