import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/services/backend/shared_preferences_service.dart';
import 'package:to_do_app/models/settings.dart';

class SettingsProvider extends StateNotifier<Settings> {
  SettingsProvider()
      : super(
          Settings(
            chosenLanguage: initialLanguage,
            isLightMode: initialLightMode,
            isNotifications: initialNotifications,
            timeFormat: initialTimeFormat,
          ),
        );
  // initial variables
  static const bool initialNotifications = false;

  static bool initialLightMode =
      WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.light;
  static const String initialLanguage = 'Select Language';
  static const String initialTimeFormat = '12-hour';
  //single instance of sharedPreferencesService
  final SharedPreferencesService sfService = SharedPreferencesService();

  void set() async {
    final setting = sfService.load();
    state = await setting;
  }

  void changeLanguage(String language) {
    final newSettings = state.copyWith(chosenLanguage: language);
    state = newSettings;
    sfService.updateSettingsInSF(newSettings);
  }

  void changeLightMode(bool item) {
    final newSettings = state.copyWith(isLightMode: item);
    state = newSettings;
    sfService.updateSettingsInSF(newSettings);
  }

  void changeNotifications(bool item) {
    final newSettings = state.copyWith(isNotifications: item);
    state = newSettings;
    sfService.updateSettingsInSF(newSettings);
  }

  void changeTimeFormat(String item) {
    final newSettings = state.copyWith(timeFormat: item);
    state = newSettings;
    sfService.updateSettingsInSF(newSettings);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsProvider, Settings>((ref) {
  return SettingsProvider();
});
