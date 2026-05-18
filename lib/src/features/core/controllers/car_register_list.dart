// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static late SharedPreferences _preferences;
  static const _keyCar = "CarRegister";
  static const _Parkingkey = "_Parkingkey";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future SetParking_id(String Parking_id) async =>
      await _preferences.setString(_Parkingkey, Parking_id);

  static String? getID() => _preferences.getString(_Parkingkey);

  static Future SetCarRegister(List<String> CarRegister) async =>
      await _preferences.setStringList(_keyCar, CarRegister);

  static List<String>? getToken([int? index]) =>
      _preferences.getStringList(_keyCar);

  static Future<bool> delete([int? index]) => _preferences.remove(_keyCar);

  static Future<bool> ParkIDdelete() => _preferences.remove(_Parkingkey);
}
