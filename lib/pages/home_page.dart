import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hockey_app/addons/my_drawer.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final databaseReference = FirebaseDatabase.instance.ref('games');

String formatDate(String dateString) {
  DateTime parsedDate = DateTime.parse(dateString);
  String formattedDate = DateFormat('dd.MM').format(parsedDate);
  return formattedDate;
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now(); // Start with today's date

  // Fetch games from Firebase for the selected date
  DatabaseReference getGamesForDate(DateTime date) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return databaseReference.child(formattedDate);
  }

  // Move to the next date
  void nextDate() {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: 1));
    });
  }

  // Move to the previous date
  void previousDate() {
    setState(() {
      selectedDate = selectedDate.subtract(Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          // Date section with Previous and Next buttons
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: previousDate,
                ),
                Text(
                  'Matches on ${formatDate(selectedDate.toString())}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: nextDate,
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            height: 1,
            color: Theme.of(context).colorScheme.secondary,
          ),
          // Fetch and display games for the selected date
          Expanded(
            child: FirebaseAnimatedList(
              query: getGamesForDate(selectedDate),
              itemBuilder: (context, snapshot, animation, index) {
                return Column(
                  children: [
                    ListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 20, right: 20),
                      title: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              snapshot.child("time").value.toString(),
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                Image.network(
                                  snapshot.child("team1logo").value.toString(),
                                  width: 30,
                                  height: 30,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error, size: 20);
                                  },
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    snapshot.child("team1").value.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    snapshot
                                        .child("team1score")
                                        .value
                                        .toString(),
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
                              child: Text(':'),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              snapshot.child("team2score").value.toString(),
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
                                  snapshot.child("team2logo").value.toString(),
                                  width: 30,
                                  height: 30,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error, size: 20);
                                  },
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    snapshot.child("team2").value.toString(),
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
                      thickness: 1,
                      height: 1,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
