import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

final databaseReference = FirebaseDatabase.instance.ref('teams');

class _TablePageState extends State<TablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 95),
          child: Text("Table"),
        ),
      ),
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
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex:
                        4, 
                    child: Text(
                      "Team",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
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
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "W",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "L",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "P",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
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
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 20, right: 5),
                  title: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${snapshot.child("placement").value.toString()}.', // Adding a dot after the placement
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        flex:
                            5, // Increased flex to add more space between name and matches
                        child: Row(
                          children: [
                            Image.asset('lib/images/vitkovice.png',
                                width: 20, height: 20),
                            const SizedBox(width: 5),
                            Text(
                              snapshot.child("name").value.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
