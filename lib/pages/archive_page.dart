import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'lib/images/ehl4.png',
          height: 55,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header tabulka
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Season",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Winner",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 18,
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
          // Tabulka
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('archive')
                  .orderBy('season', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Scrollbar(
                  child: ListView(
                    children: snapshot.data!.docs.map((document) {
                      return Column(
                        children: [
                          Card(
                            elevation: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              title: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      document['season'],
                                      style: TextStyle(fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 0, 88, 159).withOpacity(0.3)),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Image.network(
                                          document['logo'],
                                          height: 30,
                                          width: 30,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          document['winner'],
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
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