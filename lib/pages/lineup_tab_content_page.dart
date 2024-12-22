import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// Importování balíčku pro práci s Firebase.
class LineupTabContentPage extends StatelessWidget {
  final String teamName;
// Třída pro zobrazení sestavy týmu.
  const LineupTabContentPage({super.key, required this.teamName});
// Metoda pro vytvoření widgetu.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('teams')
          .where('name', isEqualTo: teamName) // získejte dokument týmu
          .snapshots(),
      builder: (context, snapshot) {
        // Zobrazení načítání, pokud je stream ve stavu čekání.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Zobrazení, pokud nejsou k dispozici žádné data.
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No lineup available.'));
        }
        // Získání dokumentu týmu.
        final teamDoc = snapshot.data!.docs.first; // získejte dokument týmu
        final lineupCollection = teamDoc.reference.collection('lineup');
        return StreamBuilder<QuerySnapshot>(
          stream: lineupCollection.snapshots(),
          builder: (context, lineupSnapshot) {
            // Zobrazení načítání, pokud je stream ve stavu čekání.
            if (lineupSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // Zobrazení, pokud nejsou k dispozici žádné data.
            if (!lineupSnapshot.hasData || lineupSnapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No lineup available.'));
            }

            // Rozdělení hráčů podle pozice
            final goalkeepers = lineupSnapshot.data!.docs
                .where((doc) => doc['position'] == 'goalkeeper')
                .toList();
            final defenders = lineupSnapshot.data!.docs
                .where((doc) => doc['position'] == 'defender')
                .toList();
            final attackers = lineupSnapshot.data!.docs
                .where((doc) => doc['position'] == 'attacker')
                .toList();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Goalkeepers', const Color.fromARGB(255, 0, 88, 159)),
                    const SizedBox(height: 10),
                    _buildPlayerCards(goalkeepers),
                    const SizedBox(height: 20),

                    _buildSectionHeader('Defenders', const Color.fromARGB(255, 0, 128, 1)),
                    const SizedBox(height: 10),
                    _buildPlayerCards(defenders),
                    const SizedBox(height: 20),

                    _buildSectionHeader('Attackers', const Color.fromARGB(255, 149, 6, 6)),
                    const SizedBox(height: 10),
                    _buildPlayerCards(attackers),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPlayerCards(List<QueryDocumentSnapshot> players) {
    return Column(
      children: players.map((player) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                player['number'].toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              player['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text('Age: ${player['age']} | Games: ${player['games']}'),
          ),
        );
      }).toList(),
    );
  }
}
