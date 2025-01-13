import 'package:flutter/material.dart';

// funkce pro vytvoření titulku v bočním menu
class MyDrawerTitle extends StatelessWidget {
  final String text; // text, který se zobrazí v titulku
  final IconData? icon; // ikona, která se zobrazí vedle textu
  final void Function()? onTap; // funkce, která se zavolá při kliknutí na titulek
  // konstruktor titulku
  const MyDrawerTitle(
      {super.key, required this.text, required this.icon, required this.onTap});

  @override
  // vytvoření titulku
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25), // vnitřní odsazení titulku
      child: ListTile(
        title: Text(
          text, // text titulku
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary), // barva textu
        ),
        leading:
            Icon(icon, color: Theme.of(context).colorScheme.inversePrimary), // ikona vedle textu
        onTap: onTap, // funkce při kliknutí na titulek
      ),
    );
  }
}
