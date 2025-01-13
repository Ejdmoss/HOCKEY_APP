import 'package:flutter/material.dart';

// vykreslení světlého režimu
ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: const Color.fromRGBO(222, 225, 230, 1),
    primary: const Color.fromARGB(255, 158, 155, 155),
    secondary: Colors.grey.shade600,
    tertiary: const Color.fromRGBO(242, 243, 245, 1),
    inversePrimary: Colors.black,
    onPrimary: Colors.grey.shade500,
    outline: const Color.fromARGB(255, 204, 202, 202),
    // ignore: deprecated_member_use
    background: Colors.white,
  ),
);
