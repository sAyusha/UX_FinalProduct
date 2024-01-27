import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/themes/my_theme_preference.dart';

class ModelTheme extends ChangeNotifier {
  late bool _isDark;
  late MyThemePreferences _preferences;

  ModelTheme() {
    _isDark = false;
    _preferences = MyThemePreferences();
    getPreferences();
  }

  bool get isDark => _isDark;

  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  void getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
}