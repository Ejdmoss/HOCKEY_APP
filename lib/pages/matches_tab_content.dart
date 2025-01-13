import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hockey_app/pages/game_details_page.dart';

class MatchesTabContent extends StatelessWidget {
  final String teamName;

  const MatchesTabContent({super.key, required this.teamName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('matches')
          .where(
            Filter.or(
              Filter('team1name', isEqualTo: teamName),
              Filter('team2name', isEqualTo: teamName),
            ),
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No matches available.'));
        }

        // Seřazení dokumentů podle data sestupně
        List<QueryDocumentSnapshot> sortedDocs = snapshot.data!.docs;
        sortedDocs.sort((a, b) {
          DateTime dateA = DateTime.parse(a['date']);
          DateTime dateB = DateTime.parse(b['date']);
          return dateB.compareTo(dateA);
        });

        return ListView(
          children: sortedDocs.map((doc) {
            String date = doc['date'];
            String formattedDate =
                DateFormat('dd.MM.yyyy').format(DateTime.parse(date));
            String team1Logo = doc['team1logo'];
            String team1Name = doc['team1name'];
            int team1Score = int.parse(doc['team1score'].toString());
            String team2Logo = doc['team2logo'];
            String team2Name = doc['team2name'];
            int team2Score = int.parse(doc['team2score'].toString());
            int round = int.parse(doc['r'].toString());

            return GestureDetector(
              onTap: () {
                // Přechod na stránku s detaily zápasu
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        GameDetailsPage(matchId: doc.id),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;
                      // Animace posunu stránky
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
              // Zobrazení karty s informacemi o zápase
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                // ignore: deprecated_member_use
                color: Theme.of(context).colorScheme.background,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Zobrazení kola a data zápasu
                      Text(
                        '$round. round - $formattedDate',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Zobrazení loga a názvu prvního týmu
                              Row(
                                children: [
                                  Image.network(
                                    team1Logo,
                                    width: 36,
                                    height: 36,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error, size: 36);
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    team1Name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Zobrazení loga a názvu druhého týmu
                              Row(
                                children: [
                                  Image.network(
                                    team2Logo,
                                    width: 36,
                                    height: 36,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error, size: 36);
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    team2Name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Zobrazení skóre zápasu
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 20, bottom: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: Text(
                                '$team1Score : $team2Score',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
