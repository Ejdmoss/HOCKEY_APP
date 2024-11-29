import 'package:flutter/material.dart';
// vykreslení temného režimu
ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(
    surface: Color.fromARGB(255, 28, 35, 39),
    primary: Color.fromARGB(255, 1, 48, 100),
    secondary: Color.fromARGB(255, 0, 88, 159),
    tertiary: Color.fromARGB(255, 47, 47, 47),
    inversePrimary: Colors.white,
    onPrimary: Color.fromARGB(255, 112, 109, 109),
  ),
);
