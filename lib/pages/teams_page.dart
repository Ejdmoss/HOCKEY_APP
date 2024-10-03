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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 42),
          child: Text("Tipsport Extraliga"),
        ),
      ),
      body: Column(
        children: [
          // Data rows
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
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: [
                                Image.network(
                                  snapshot.child("logo").value.toString(),
                                  width: 28,
                                  height: 28,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error, size: 20);
                                  },
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  snapshot.child("name").value.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
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
