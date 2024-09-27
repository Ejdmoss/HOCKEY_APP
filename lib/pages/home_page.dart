import 'package:flutter/material.dart';
import 'package:hockey_app/addons/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar s leading buttonem na rozkliknutí sidebaru
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            // funkce on pressed tlačítka
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // profil na začátku stránky kde je v row vypsaná profilovka zvolená uživatelem a jméno a přijmení + oblíbený tým uživatele
          Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset('lib/images/trinec.png',
                      width: 75, height: 75),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Adam Stuchlík',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text('HC Oceláři Třinec',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          // extraliga hokeje kde je možnost rozkliknout soutěž a prokliknete se na tabulku týmu a jejich pořadí
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset('lib/images/tipac.png',
                      width: 50, height: 30),
                ),
                Text('Extraliga',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          // datum
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              'Today 22.09.',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
