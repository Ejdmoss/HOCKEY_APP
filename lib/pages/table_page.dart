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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController placementController = TextEditingController();
  // Add more controllers if needed for input fields

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
          // Reading from the Realtime Database
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("#", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 18, fontWeight: FontWeight.bold),),
                  Text("Team", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 16, fontWeight: FontWeight.bold),),
                  Text("M", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 16, fontWeight: FontWeight.bold),),
                  Text("W", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 16, fontWeight: FontWeight.bold),),
                  Text("L", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 16, fontWeight: FontWeight.bold),),
                  Text("P", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 16, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),

          Expanded(
            child: FirebaseAnimatedList(
              query: databaseReference,
              itemBuilder: (context, snapshot, animation, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            snapshot.child("placement").value.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            snapshot.child("name").value.toString(),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            snapshot.child("matches").value.toString(),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            snapshot.child("wins").value.toString(),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            snapshot.child("loses").value.toString(),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            snapshot.child("points").value.toString(),
                          ),
                        ),
                      ],
                    ),
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
