
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_hockey),
          label: 'Matches',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.table_chart),
          label: 'Table',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Lineup',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
      unselectedItemColor: Theme.of(context).colorScheme.inversePrimary,
      onTap: onItemTapped,
    );
  }
}