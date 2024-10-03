import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

final databaseReference = FirebaseDatabase.instance.ref('teams');

class _TeamsPageState extends State<TeamsPage> {
  Color getRowColor(int placement) {
    if (placement <= 4) {
      return const Color.fromARGB(255, 0, 70, 130);
    } else if (placement >= 5 && placement <= 12) {
      return const Color.fromARGB(255, 30, 168, 236);
    } else if (placement == 13) {
      return Theme.of(context).colorScheme.tertiary;
    } else if (placement == 14) {
      return const Color.fromARGB(255, 230, 0, 5);
    }
    return const Color.fromARGB(255, 42, 46, 55); // Default color
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(),
      body: Column(
        children: [
          // Header row
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
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
                  const SizedBox(width: 40),
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
          ),

          // Data rows
          Expanded(
            child: FirebaseAnimatedList(
              query: databaseReference,
              itemBuilder: (context, snapshot, animation, index) {
                int placement = snapshot.child("placement").value as int;
                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.only(left: 20, right: 5),
                      title: Row(
                        children: [
                          // Colored strap with rounded corners before the placement
                          Container(
                            width: 7, // Width of the strap
                            height: 40, // Height of the strap
                            decoration: BoxDecoration(
                              color: getRowColor(placement),
                              borderRadius: BorderRadius.circular(5), // Rounded corners
                            ),
                          ),
                          const SizedBox(width: 5),
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
                                // Use Image.network to load the logo from the URL provided in the database
                                Image.network(
                                  snapshot.child("logo").value.toString(), // Assuming this gives the URL of the logo
                                  width: 20,
                                  height: 20,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Placeholder in case of an error loading the image
                                    return const Icon(Icons.error, size: 20); // Replace with any error widget you prefer
                                  },
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  snapshot.child("name").value.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: Text(
                              snapshot.child("matches").value.toString(),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              snapshot.child("wins").value.toString(),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              snapshot.child("loses").value.toString(),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              snapshot.child("points").value.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
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

          // Color Legend
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // First box
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: getRowColor(1), // Color for top teams
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text("Quarterfinals"),
                  ],
                ),
                // Second box
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: getRowColor(6), // Color for mid-tier teams
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text("Eight-finals"),
                  ],
                ),
                // Third box
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: getRowColor(14), // Color for bottom teams
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
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
