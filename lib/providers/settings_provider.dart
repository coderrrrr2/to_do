import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/services/sharedPreferences/shared_preferences_service.dart';
import 'package:to_do_app/models/settings.dart';

final SharedPreferencesService _sfService = SharedPreferencesService();

class SettingsProvider extends StateNotifier<Settings> {
  SettingsProvider(Settings initialSettings) : super(initialSettings);

  void set() async {
    final setting = _sfService.load();
    state = await setting;
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
  Settings initialSettings = Settings(
      isNotifications: true,
      isLightMode: true,
      chosenLanguage: '',
      timeFormat: 'timeFormat');
  print("sss");
  ref.watch(settingsValueProvider).whenData((value) {
    initialSettings = value;
    print("eeee");
  });
  print("pppp");

  return SettingsProvider(initialSettings);
});

final settingsValueProvider = FutureProvider<Settings>((ref) async {
  final initialSettings = await _sfService.load();
  return initialSettings;
});
