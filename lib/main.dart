import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/theme/color_scheme.dart';
import 'package:to_do_app/providers/settings_provider.dart';
import 'package:to_do_app/screens/home.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const ProviderScope(child: MyApp()));
  FlutterNativeSplash.remove();
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

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
