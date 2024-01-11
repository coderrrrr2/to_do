import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/services/sharedPreferences/shared_preferences_service.dart';
import 'package:to_do_app/models/settings.dart';

const bool initialNotifications = false;
const String initialLanguage = 'Select Language';
const String initialTimeFormat = '12-hour';

class SettingsProvider extends StateNotifier<Settings> {
  final SharedPreferencesService _sfService = SharedPreferencesService();

  SettingsProvider() : super(Settings.defaults());

  Settings getSettingsValue() {
    return state;
  }

  void initializeDeviceTheme() {
    // Set isLightMode based on the device theme
  }

  void set() async {
    final setting = await _sfService.load();
    state = setting;
  }

  void changeLanguage(String language) {
    final newSettings = state.copyWith(chosenLanguage: language);
    state = newSettings;
    _sfService.updateSettingsInSF(newSettings);
  }

  void changeLightMode(bool item) {
    final newSettings = state.copyWith(isLightMode: item);
    state = newSettings;
    _sfService.updateSettingsInSF(newSettings);
  }

  void changeNotifications(bool item) {
    final newSettings = state.copyWith(isNotifications: item);
    state = newSettings;
    _sfService.updateSettingsInSF(newSettings);
  }

  void changeTimeFormat(String item) {
    final newSettings = state.copyWith(timeFormat: item);
    state = newSettings;
    _sfService.updateSettingsInSF(newSettings);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsProvider, Settings>((ref) {
  return SettingsProvider();
});
