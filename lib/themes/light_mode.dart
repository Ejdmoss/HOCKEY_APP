import 'package:flutter/material.dart';
// vykreslení světlého režimu
ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade100,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade600,
    tertiary: Colors.white,
    inversePrimary: Colors.black,
    onPrimary: Colors.grey.shade500,
  ),
);