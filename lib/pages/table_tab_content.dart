import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

// vykreslení tabulky
class TableTabContent extends StatelessWidget {
  final String teamName;
  // konstruktor obsahu záložky tabulky
  const TableTabContent({super.key, required this.teamName});
  // vykreslení tabulky
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Název tabulky
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    "#",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text(
                    "Team",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              // vykreslení počtu zápasů
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 31),
                  child: Text(
                    "M",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              // vykreslení skóre
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text(
                    "SCORE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              // vykreslení bodů
              Expanded(
                flex: 1,
                child: Text(
                  "PTS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Oddělovač
        Divider(
          thickness: 1,
          height: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
        // Seznam týmů
        Expanded(
          child: FirebaseAnimatedList(
            query: FirebaseDatabase.instance.ref('table').orderByChild('placement'),
            itemBuilder: (context, snapshot, animation, index) {
              int placement = snapshot.child("placement").value as int;
              String teamName = snapshot.child("name").value.toString();
              bool isCurrentTeam = teamName == this.teamName;
              // Vykreslení řádku tabulky
              return Column(
                children: [
                  Container(
                    // Zvýraznění řádku, pokud je tým zvolený
                    decoration: BoxDecoration(
                      color: isCurrentTeam
                          ? const Color.fromRGBO(13, 101, 172, 1).withOpacity(0.8)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.only(left: 20, right: 5),
                          title: Row(
                            children: [
                              // Pořadí
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '$placement.',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              // Název týmu a logo
                              Expanded(
                                flex: 5,
                                child: Row(
                                  children: [
                                    Image.network(
                                      snapshot.child("logo").value.toString(),
                                      width: 20,
                                      height: 20,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.error, size: 20);
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        teamName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Počet zápasů, výher, proher a bodů
                              Expanded(
                                flex: 1,
                                child: Text(
                                    snapshot.child("matches").value.toString()),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                    snapshot.child("score").value.toString()),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  snapshot.child("points").value.toString(),
                                  style:
                                      const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.2,
                    height: 1,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
