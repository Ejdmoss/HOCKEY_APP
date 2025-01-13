import 'package:flutter/material.dart';

// vykreslení temného režimu
ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(
    surface: Color.fromARGB(255, 28, 35, 39),
    primary: Color.fromRGBO(13, 101, 172, 1),
    secondary: Color.fromARGB(255, 0, 88, 159),
    tertiary: Color.fromARGB(255, 59, 62, 65),
    inversePrimary: Colors.white,
    onPrimary: Color.fromARGB(255, 112, 109, 109),
    outline: Color.fromRGBO(13, 101, 172, 1),
    // ignore: deprecated_member_use
    background: Color.fromARGB(255, 28, 35, 39),
  ),
);
