
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MatchesTabContent extends StatelessWidget {
  final String teamName;

  const MatchesTabContent({super.key, required this.teamName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('matches')
          .where('team1name', isEqualTo: teamName)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No matches available.'));
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            String date = doc['date'];
            String formattedDate =
                DateFormat('dd.MM.yyyy').format(DateTime.parse(date));
            String team1Logo = doc['team1logo'];
            int team1Score = int.parse(doc['team1score'].toString());
            String team2Logo = doc['team2logo'];
            int team2Score = int.parse(doc['team2score'].toString());

            return Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Logo and score row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            team1Logo,
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, size: 50);
                            },
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '$team1Score - $team2Score',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Image.network(
                            team2Logo,
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, size: 50);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Team names row
                      // Date row
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                ),
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
    );
  }
}