import 'package:flutter/material.dart';

// funkce pro vytvoření spodního navigačního baru pro rychlé pohybování v aplikaci
class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    // klíč pro widget
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        // ikony pro navigaci
        BottomNavigationBarItem(
          icon: Icon(Icons.table_chart),
          // tabulka
          label: 'Table',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_hockey),
          // zápasy
          label: 'Matches',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          // soupiska
          label: 'Lineup',
        ),
      ],
      currentIndex: selectedIndex,
      // vybrana barva ikon a textu
      selectedItemColor: const Color.fromARGB(255,0,88,159).withOpacity(0.3),
      unselectedItemColor: Theme.of(context).colorScheme.inversePrimary,
      onTap: onItemTapped,
    );
  }
}
