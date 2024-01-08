class SingletonNotificationService {
  static final SingletonNotificationService _SingletonNotificationService =
      SingletonNotificationService._internal();

  factory SingletonNotificationService() {
    return _SingletonNotificationService;
  }

  SingletonNotificationService._internal();
}
