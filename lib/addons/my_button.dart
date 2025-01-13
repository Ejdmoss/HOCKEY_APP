import 'package:flutter/material.dart';

// funkce pro vytvoření tlačítka
class MyButton extends StatelessWidget {
  final Function()? onTap; // funkce, která se zavolá při stisknutí tlačítka
  final String text; // text, který se zobrazí na tlačítku
  // konstruktor tlačítka
  const MyButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap je funkce, která se zavolá při stisknutí tlačítka
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25), // vnitřní odsazení tlačítka
        margin: const EdgeInsets.symmetric(horizontal: 25), // vnější odsazení tlačítka
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface, // barva pozadí tlačítka
          borderRadius: BorderRadius.circular(8), // zaoblení rohů tlačítka
        ),
        child: Center(
          child: Text(
            text, // text tlačítka
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary, // barva textu tlačítka
              fontWeight: FontWeight.bold, // tučné písmo
              fontSize: 16, // velikost písma
            ),
          ),
        ),
      ),
    );
  }
}
