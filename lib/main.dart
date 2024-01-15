import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/services/local%20Notifications/local_notifications.dart';
import 'package:to_do_app/services/local%20Notifications/local_notifications_initialiser.dart';
import 'package:to_do_app/theme/color_scheme.dart';
import 'package:to_do_app/providers/settings_provider.dart';
import 'package:to_do_app/screens/home.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationsService().initialiseTimeZones();
  LocalNotificationsInitializer().initialisePlugin();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const ProviderScope(child: ToDoApp()));
  FlutterNativeSplash.remove();
}

class ToDoApp extends ConsumerWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(settingsProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.isLightMode == true ? lightTheme : darkTheme,
      home: const HomeScreen(),
    );
  }
}
