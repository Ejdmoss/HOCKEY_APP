import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hockey_app/addons/my_drawer.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Konstruktor pro HomePage.

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime selectedDate = DateTime.now(); // Dnešní datum
  int selectedMonthIndex =
      DateTime.now().month - 1; // Index aktuálního měsíce pro dropdown.

  // Seznam názvů měsíců pro dropdown.
  final List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  // Načteme zápasy z Firestore pro vybrané datum.
  Stream<QuerySnapshot> getGamesForDate(DateTime date) {
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(date); // Formátování data
    return firestore
        .collection('matches')
        .where('date', isEqualTo: formattedDate) // Filtrujeme zápasy podle dat
        .snapshots();
  }

  // Upravíme měsíc podle vybraného indexu.
  void updateMonth(int index) {
    setState(() {
      selectedMonthIndex = index; // Aktualizujeme index měsíce.
      // Nastavíme selectedDate na první den nového měsíce.
      selectedDate = DateTime(selectedDate.year, index + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu), // Tlačítko pro otevření bočního menu.
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Otevřeme boční menu.
            },
          ),
        ),
        backgroundColor: Colors.transparent, // Průhledné pozadí.
        elevation: 0, // Žádný stín.
      ),
      drawer: const MyDrawer(), // Přidání bočního menu.
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Zarovnání vlevo.
        children: [
          // Zobrazení měsíce a roku s dropdown menu.
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Zobrazíme dropdown menu při klepnutí.
                    showMenu(
                      context: context,
                      position: const RelativeRect.fromLTRB(
                          100.0, 100.0, 0.0, 0.0), // Pozice dropdownu.
                      items: List.generate(monthNames.length, (index) {
                        return PopupMenuItem<int>(
                          value: index, // Nastavíme hodnotu indexu měsíce.
                          child: Text(
                              monthNames[index]), // Zobrazíme název měsíce.
                        );
                      }),
                    ).then((value) {
                      if (value != null) {
                        updateMonth(value); // Aktualizujeme vybraný měsíc.
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        DateFormat('MMMM yyyy')
                            .format(selectedDate), // Zobrazíme měsíc a rok.
                        style: TextStyle(
                          fontSize: 24, // Velikost písma.
                          fontWeight: FontWeight.bold, // Tučné písmo.
                          color: Theme.of(context)
                              .colorScheme
                              .primary, // Hlavní barva textu.
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down, // Ikona pro dropdown.
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Fixní horizontální výběr dat.
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              // Uprostřed zarovnáme výběr dat.
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  DateTime date = selectedDate.add(
                      Duration(days: index - 2)); // Uprostřed vybrané datum.
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate =
                            date; // Nastavíme vybrané datum na klepnutí.
                      });
                    },
                    child: Container(
                      width: 70,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: date.isAtSameMomentAs(selectedDate)
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(10), // Zaoblené rohy.
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEE').format(date), // Den v týdnu.
                            style: TextStyle(
                              color: date.isAtSameMomentAs(selectedDate)
                                  ? Theme.of(context).colorScheme.inversePrimary
                                  : Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                            ),
                          ),
                          Text(
                            DateFormat('dd').format(date), // Den v měsíci.
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: date.isAtSameMomentAs(selectedDate)
                                  ? Theme.of(context).colorScheme.inversePrimary
                                  : Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          // Načteme a zobrazíme zápasy pro vybrané datum.
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  getGamesForDate(selectedDate), // Posloucháme stream zápasů.
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Zobrazíme načítací indikátor.
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text(
                          'No games available for this date.')); // Žádné zápasy.
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.only(
                              left: 20, right: 20), // Vnitřní okraje.
                          title: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Row(
                                  children: [
                                    Image.network(
                                      doc["team1logo"] ??
                                          "", // Načteme logo týmu 1.
                                      width: 30,
                                      height: 30,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.error,
                                            size:
                                                20); // Ikona chyby, pokud se logo nepodaří načíst.
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        doc["team1name"] ??
                                            "Team 1", // Načteme název týmu 1.
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        doc["team1score"]
                                            .toString(), // Načteme skóre týmu 1.
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(':'), // Oddělovač.
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  doc["team2score"]
                                      .toString(), // Načteme skóre týmu 2.
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Row(
                                  children: [
                                    Image.network(
                                      doc["team2logo"] ??
                                          "", // Načteme logo týmu 2.
                                      width: 30,
                                      height: 30,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.error,
                                            size:
                                                20); // Ikona chyby pro logo týmu 2.
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        doc["team2name"] ??
                                            "Team 2", // Načteme název týmu 2.
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1, // Tloušťka oddělovače.
                          height: 1, // Výška oddělovače.
                          color: Theme.of(context)
                              .colorScheme
                              .secondary, // Barva oddělovače.
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
