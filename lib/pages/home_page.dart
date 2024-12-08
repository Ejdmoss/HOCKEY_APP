import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hockey_app/addons/my_drawer.dart';
import 'package:intl/intl.dart';

// vytvoření třídy HomePage
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // vygenerování stavu třídy HomePage
  State<HomePage> createState() => _HomePageState();
}

// vytvoření třídy _HomePageState
class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime selectedDate = DateTime.now();
  int selectedMonthIndex = DateTime.now().month - 1;
  // vytvoření seznamu měsíců
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
  // vytvoření metody getGamesForDate
  Stream<QuerySnapshot> getGamesForDate(DateTime date) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return firestore
        .collection('matches')
        .where('date', isEqualTo: formattedDate)
        .snapshots();
  }

  // vytvoření metody updateMonth
  void updateMonth(int index) {
    setState(() {
      selectedMonthIndex = index;
      selectedDate = DateTime(selectedDate.year, index + 1, 1);
    });
  }

  // vytvoření metody build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'lib/images/ehl4.png',
          height: 55,
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // vyvolání metody MyDrawer
      drawer: MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // vytvoření dialogu pro výběr měsíce
                    showMenu(
                      context: context,
                      position:
                          const RelativeRect.fromLTRB(100.0, 100.0, 0.0, 0.0),
                      items: List.generate(monthNames.length, (index) {
                        return PopupMenuItem<int>(
                          value: index,
                          child: Text(monthNames[index]),
                        );
                      }),
                    ).then((value) {
                      if (value != null) {
                        updateMonth(value);
                      }
                    });
                  },
                  child: Row(
                    children: [
                      // zobrazení vybraného měsíce
                      Text(
                        DateFormat('MMMM yyyy').format(selectedDate),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: const Color.fromARGB(255,0,88,159).withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // vytvoření řádku s daty
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  DateTime date = selectedDate.add(Duration(days: index - 2));
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    child: Container(
                      width: 70,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: date.isAtSameMomentAs(selectedDate)
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEE').format(date),
                            style: TextStyle(
                              color: date.isAtSameMomentAs(selectedDate)
                                  ? Theme.of(context).colorScheme.inversePrimary
                                  : Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                            ),
                          ),
                          Text(
                            DateFormat('dd').format(date),
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
          // vytvoření seznamu zápasů
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // získání dat z databáze
              stream: getGamesForDate(selectedDate),
              // zobrazení dat
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // zobrazení zprávy, pokud nejsou k dispozici žádné zápasy
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No games available for this date.'));
                }
                // zobrazení seznamu zápasů
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return Column(
                      children: [
                        Card(
                          elevation: 8,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // zobrazení loga týmu 1
                                      Image.network(
                                        doc["team1logo"] ?? "",
                                        width: 40,
                                        height: 40,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(Icons.error,
                                              size: 30);
                                        },
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        // zobrazení názvu týmu 1
                                        child: Text(
                                          doc["team1name"] ?? "Team 1",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      // zobrazení skóre týmu 1
                                      const SizedBox(width: 5),
                                      Text(
                                        doc["team1score"].toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text('-',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    )),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // zobrazení skóre týmu 2
                                      Text(
                                        doc["team2score"].toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        // zobrazení názvu týmu 2
                                        child: Text(
                                          doc["team2name"] ?? "Team 2",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      // zobrazení loga týmu 2
                                      Image.network(
                                        doc["team2logo"] ?? "",
                                        width: 40,
                                        height: 40,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(Icons.error,
                                              size: 30);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // vytvoření oddělovače
                        Divider(
                          thickness: 1,
                          height: 1,
                          color: Theme.of(context)
                              .colorScheme
                              .inversePrimary
                              .withOpacity(0.1),
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
          // vytvoření obrázku
          Padding(
            padding: const EdgeInsets.only(bottom: 35, left: 15, right: 15),
            child: Container(
              height: 215,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('lib/images/ehl2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              // vytvoření vrstvy
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
        ],
      ),
    );
  }
}
