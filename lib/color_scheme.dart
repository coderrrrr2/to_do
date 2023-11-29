import 'package:flutter/material.dart';

final lightcolorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 81, 26, 136),
    onBackground: Colors.white);

final darkcolorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 81, 26, 136),
    onBackground: const Color.fromARGB(107, 158, 158, 158),
    primary: const Color.fromARGB(255, 81, 26, 136));

final lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: lightcolorScheme,
    scaffoldBackgroundColor: lightcolorScheme.onBackground,
    appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 81, 26, 136),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.white)));

final darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: darkcolorScheme.onBackground,
  colorScheme: darkcolorScheme,
  primaryTextTheme:
      const TextTheme(titleMedium: TextStyle(color: Colors.white)),
  appBarTheme: const AppBarTheme(
      color: Color.fromARGB(255, 146, 63, 229),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: Colors.white)),
  textTheme: const TextTheme(titleMedium: TextStyle(color: Colors.white)),
);
