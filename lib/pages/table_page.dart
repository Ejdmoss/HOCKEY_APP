import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

// vykreslení stránky s tabulkou
class TablePage extends StatefulWidget {
  const TablePage({super.key});
// vytvoření stavového objektu pro stránku s tabulkou
  @override
  State<TablePage> createState() => _TablePageState();
}

// stavový objekt pro stránku s tabulkou
final databaseReference = FirebaseDatabase.instance.ref('table');

// metoda pro získání barvy řádku podle umístění
class _TablePageState extends State<TablePage> {
  Color getRowColor(int placement) {
    if (placement <= 4) {
      return const Color.fromRGBO(24, 123, 205, 1);
    } else if (placement >= 5 && placement <= 12) {
      return const Color.fromARGB(255, 88, 163, 221);
    } else if (placement == 13) {
      return const Color.fromRGBO(208, 233, 255, 1);
    } else if (placement == 14) {
      return const Color.fromRGBO(220, 20, 60, 1);
    }
    return const Color.fromARGB(255, 25, 24, 40);
  }

// vykreslení stránky s tabulkou
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Image.asset(
          'lib/images/ehl4.png',
          height: 55,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header obrázek
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: const DecorationImage(
                  image: AssetImage('lib/images/ehl2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              // vrstva s průhledností
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Header tabulka
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
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
                    padding: const EdgeInsets.only(left: 12),
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
          // oddělení
          Divider(
            thickness: 1,
            height: 1,
            color: Theme.of(context).colorScheme.outline,
          ),

          // Tabulka
          Expanded(
            child: FirebaseAnimatedList(
              query: databaseReference.orderByChild('placement'),
              itemBuilder: (context, snapshot, animation, index) {
                int placement = snapshot.child("placement").value as int;
                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.only(left: 20, right: 5),
                      title: Row(
                        children: [
                          // barva řádku pořadí týmu
                          Container(
                            width: 7,
                            height: 40,
                            decoration: BoxDecoration(
                              color: getRowColor(placement),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          const SizedBox(width: 5),
                          // pořadí týmu
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
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: [
                                // logo týmu
                                Image.network(
                                  snapshot.child("logo").value.toString(),
                                  width: 20,
                                  height: 20,
                                  errorBuilder: (context, error, stackTrace) {
                                    // pokud se logo nenačte, zobrazí se ikona chyby
                                    return const Icon(Icons.error, size: 20);
                                  },
                                ),
                                const SizedBox(width: 5),
                                // název týmu
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    snapshot.child("name").value.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // počet zápasů, výher, proher a bodů
                          Expanded(
                            flex: 1,
                            child: Text(
                              snapshot.child("matches").value.toString(),
                            ),
                          ),
                          // počet bodů
                          Expanded(
                            flex: 2,
                            child: Text(
                              snapshot.child("score").value.toString(),
                            ),
                          ),
                          // počet bodů
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
                );
              },
            ),
          ),

          // Legenda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // První box
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: getRowColor(1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text("Quarterfinals"),
                  ],
                ),
                // Druhý box
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: getRowColor(6),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text("Eight-finals"),
                  ],
                ),
                // Třetí box
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: getRowColor(14),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    // baráž
                    const SizedBox(width: 5),
                    const Text("Barrage"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
