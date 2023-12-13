import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/models/settings.dart';

bool isNotifications = false;
bool isLightMode = true;
String chosenLanguage = 'English';
String timeFormat = '12-hour';

class SettingsProvider extends StateNotifier<Settings> {
  SettingsProvider()
      : super(
          Settings(
              chosenLanguage: chosenLanguage,
              isLightMode: isLightMode,
              isNotifications: isNotifications,
              timeFormat: timeFormat),
        );

  void changeLanguage(String language) {
    chosenLanguage = language;
    state = Settings(
        isNotifications: isNotifications,
        isLightMode: isLightMode,
        chosenLanguage: language,
        timeFormat: timeFormat);
  }

  void changeLightMode(bool item) {
    isLightMode = item;
    state = Settings(
        isNotifications: isNotifications,
        isLightMode: item,
        chosenLanguage: chosenLanguage,
        timeFormat: timeFormat);
  }

  void changeNotifications(bool item) {
    isNotifications = item;
    state = Settings(
        isNotifications: item,
        isLightMode: isLightMode,
        chosenLanguage: chosenLanguage,
        timeFormat: timeFormat);
  }

  void changeTimeFormat(String item) {
    timeFormat = item;
    state = Settings(
        isNotifications: isNotifications,
        isLightMode: isLightMode,
        chosenLanguage: chosenLanguage,
        timeFormat: item);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsProvider, Settings>((ref) {
  return SettingsProvider();
});
