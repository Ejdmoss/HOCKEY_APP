import 'package:flutter/material.dart';
import 'package:hockey_app/themes/dark_mode.dart';
import 'package:hockey_app/themes/light_mode.dart';

// Třída ThemeProvider slouží k správě a poskytování aktuálního tématu aplikace.
class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = darkMode;
  ThemeData get themeData => _themeData;

  // Kontroluje, zda je aktuální téma tmavé.
  bool get isdarkMode => _themeData == darkMode;

  // Setter pro nastavení nového tématu.
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    // Notifikace, že došlo k změně tématu.
    notifyListeners();
  }

  // Metoda pro přepnutí mezi světelným a tmavým tématem.
  void toggleTheme() {
    // Pokud je aktuální téma světelné, přepni na tmavé.
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      // Jinak přepni zpět na světelné téma.
      themeData = lightMode;
    }
  }
}
