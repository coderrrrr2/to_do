class Settings {
  const Settings({
    required this.isNotifications,
    required this.isLightMode,
    required this.chosenLanguage,
    required this.timeFormat,
  });
  final bool isNotifications;
  final bool isLightMode;
  final String chosenLanguage;
  final String timeFormat;
}