import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  void addStringToSF(
      Map<String, dynamic> mapOfSettingsValues, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(mapOfSettingsValues);
    prefs.setString(key, jsonString);
  }

  Future<String?> getStringValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(key);
    if (stringValue != null) {
      return json.decode(stringValue);
    }
    return '';
  }

  void removeValuesFromSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
