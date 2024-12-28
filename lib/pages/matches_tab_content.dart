import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// vykreslení obsahu záložky zápasů
class MatchesTabContent extends StatelessWidget {
  final String teamName;
// konstruktor obsahu záložky zápasů
  const MatchesTabContent({super.key, required this.teamName});
// vytvoření streamu pro získání dat z databáze
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // získání dat z kolekce matches, kde je tým1 nebo tým2 roven zadanému týmu
      stream: FirebaseFirestore.instance
          .collection('matches')
          // porovnání týmu1 nebo týmu2 s názvem zadaného týmu
          .where(
            Filter.or(
              Filter('team1name', isEqualTo: teamName),
              Filter('team2name', isEqualTo: teamName),
            ),
          )
          .snapshots(),
      // vykreslení dat
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No matches available.'));
        }
        // Seřazení dokumentů podle data
        List<QueryDocumentSnapshot> sortedDocs = snapshot.data!.docs;
        sortedDocs.sort((a, b) {
          DateTime dateA = DateTime.parse(a['date']);
          DateTime dateB = DateTime.parse(b['date']);
          return dateB.compareTo(dateA); // sestupně
        });
        // vykreslení seznamu zápasů
        return ListView(
          children: sortedDocs.map((doc) {
            String date = doc['date'];
            String formattedDate =
                DateFormat('dd.MM.yyyy').format(DateTime.parse(date));
            String team1Logo = doc['team1logo'];
            int team1Score = int.parse(doc['team1score'].toString());
            String team2Logo = doc['team2logo'];
            int team2Score = int.parse(doc['team2score'].toString());
            // vykreslení jednoho zápasu
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
                      // logo týmů a skóre
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
