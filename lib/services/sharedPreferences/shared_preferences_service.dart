import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/models/settings.dart';

class SharedPreferencesService {
  String key = 'settings_key';

  Future<Settings> load() async {
    return await getSettingsFromSF();
  }

  void addSettingsToSF(Settings settings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> settingsMap = settings.toMap();
    String jsonString = json.encode(settingsMap);
    prefs.setString(key, jsonString);
  }

  Future<Settings> getSettingsFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);

    Map<String, dynamic> settingsMap = json.decode(jsonString!);
    return Settings(
      isNotifications: settingsMap['isNotifications'],
      isLightMode: settingsMap['isLightMode'],
      chosenLanguage: settingsMap['chosenLanguage'],
      timeFormat: settingsMap['timeFormat'],
    );
  }

  void updateSettingsInSF(Settings newSettings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> settingsMap = newSettings.toMap();
    String jsonString = json.encode(settingsMap);
    prefs.setString(key, jsonString);
  }
}
