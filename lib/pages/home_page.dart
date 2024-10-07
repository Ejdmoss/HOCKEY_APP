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
  // Parse the date string to a DateTime object
  DateTime parsedDate = DateTime.parse(dateString);

  // Use DateFormat from intl to format the date as 'day.month'
  String formattedDate = DateFormat('dd.MM').format(parsedDate);

  return formattedDate;
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar with leading button for the sidebar
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
          // User profile at the start of the page with a row containing user's profile picture, name, and favorite team
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
          // League section with an option to click and view team standings
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
          // Date section
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
          Divider(
            thickness: 1,
            height: 1,
            color: Theme.of(context).colorScheme.secondary,
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: databaseReference,
              itemBuilder: (context, snapshot, animation, index) {
                return Column(
                  children: [
                    ListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 20, right: 20),
                      title: Row(
                        children: [
                          // Date and time section
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${formatDate(snapshot.child("date").value.toString())} ${snapshot.child("time").value.toString()}', // Format date and append time
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          // First team logo, name, and score
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                Image.network(
                                  snapshot
                                      .child("team1logo")
                                      .value
                                      .toString(), // Replace with the field for team 1 logo
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
                                    snapshot.child("team1").value.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                // Team 1 score
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    snapshot
                                        .child("team1score")
                                        .value
                                        .toString(), // Replace with the field for team 1 score
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
                          // Separator (optional)
                          const Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(':'),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              snapshot
                                  .child("team2score")
                                  .value
                                  .toString(), // Replace with the field for team 2 score
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          // Second team logo, name, and score
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                Image.network(
                                  snapshot
                                      .child("team2logo")
                                      .value
                                      .toString(), // Replace with the field for team 2 logo
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
                                // Team 2 score
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
