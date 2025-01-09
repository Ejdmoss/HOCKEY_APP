import 'package:flutter/material.dart';

// vykreslení světlého režimu
ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: const Color.fromRGBO(204, 204, 204, 1),
    primary: const Color.fromRGBO(240, 113, 44, 1),
    secondary: Colors.grey.shade600,
    tertiary: Colors.white,
    inversePrimary: Colors.black,
    onPrimary: Colors.grey.shade500,
    outline: const Color.fromARGB(255, 133, 64, 27),
  ),
);
