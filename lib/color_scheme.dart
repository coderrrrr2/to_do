import 'package:flutter/material.dart';

final lightcolorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 81, 26, 136),
    onBackground: Colors.white);

final lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: lightcolorScheme,
    scaffoldBackgroundColor: lightcolorScheme.onBackground,
    appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 128, 91, 216),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.white)));

final darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 128, 91, 216),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.white)));
