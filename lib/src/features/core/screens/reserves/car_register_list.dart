// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class CarRegistions {
  static late SharedPreferences _preferences;
  static const _keyCar = "CarRegister";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future SetCarRegister(List<String> CarRegister) async =>
      await _preferences.setStringList(_keyCar, CarRegister);

  static List<String>? getToken([int? index]) =>
      _preferences.getStringList(_keyCar);

  static Future<bool> delete([int? index]) => _preferences.remove(_keyCar);
}
