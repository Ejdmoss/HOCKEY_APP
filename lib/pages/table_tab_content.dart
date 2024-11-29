
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class TableTabContent extends StatelessWidget {
  final String teamName;

  const TableTabContent({super.key, required this.teamName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Row
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "#",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  "Team",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 22),
              Expanded(
                flex: 1,
                child: Text(
                  "M",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "W",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "L",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "P",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
        // FirebaseAnimatedList for table data
        Expanded(
          child: FirebaseAnimatedList(
            query: FirebaseDatabase.instance.ref('table'),
            itemBuilder: (context, snapshot, animation, index) {
              int placement = snapshot.child("placement").value as int;
              String teamName = snapshot.child("name").value.toString();
              bool isCurrentTeam = teamName == this.teamName;

              return Container(
                decoration: BoxDecoration(
                  color: isCurrentTeam
                      ? Colors.yellow.withOpacity(0.3)
                      : Colors.transparent, // Highlight current team
                  borderRadius:
                      BorderRadius.circular(10), // Make the box rounded
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      title: Row(
                        children: [
                          // Placement
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
                          // Team name and logo
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
                                Text(
                                  teamName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Matches, Wins, Loses, Points
                          Expanded(
                            flex: 1,
                            child: Text(
                                snapshot.child("matches").value.toString()),
                          ),
                          Expanded(
                            flex: 1,
                            child:
                                Text(snapshot.child("wins").value.toString()),
                          ),
                          Expanded(
                            flex: 1,
                            child:
                                Text(snapshot.child("loses").value.toString()),
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
                    Divider(
                      thickness: 1,
                      height: 1,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}