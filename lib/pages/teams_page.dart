import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getTeams() {
    return firestore.collection('teams').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          "Tipsport Extraliga",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getTeams(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No teams available.'));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.only(left: 20, right: 20),
                          title: Row(
                            children: [
                              Image.network(
                                doc['logo'] ?? "",
                                width: 28,
                                height: 28,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error, size: 20);
                                },
                              ),
                              const SizedBox(width: 20),
                              Text(
                                doc['name'] ?? "Team Name",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
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
