class Settings {
  final bool isNotifications;
  final bool isLightMode;
  final String chosenLanguage;
  final String timeFormat;

  const Settings({
    required this.isNotifications,
    required this.isLightMode,
    required this.chosenLanguage,
    required this.timeFormat,
  });

  // Named constructor with default values

  Settings copyWith({
    bool? isNotifications,
    bool? isLightMode,
    String? chosenLanguage,
    String? timeFormat,
  }) {
    return Settings(
      isNotifications: isNotifications ?? this.isNotifications,
      isLightMode: isLightMode ?? this.isLightMode,
      chosenLanguage: chosenLanguage ?? this.chosenLanguage,
      timeFormat: timeFormat ?? this.timeFormat,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isNotifications': isNotifications,
      'isLightMode': isLightMode,
      'chosenLanguage': chosenLanguage,
      'timeFormat': timeFormat,
    };
  }

  void get() {}
}
