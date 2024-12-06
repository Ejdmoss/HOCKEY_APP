import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LineupTabContentPage extends StatelessWidget {
  final String teamName;

  const LineupTabContentPage({super.key, required this.teamName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('teams')
          .where('name', isEqualTo: teamName) // Query by team name
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No lineup available.'));
        }
        final teamDoc = snapshot.data!.docs.first; // Get the team document
        final lineupCollection = teamDoc.reference.collection('lineup');
        return StreamBuilder<QuerySnapshot>(
          stream: lineupCollection.snapshots(),
          builder: (context, lineupSnapshot) {
            if (lineupSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!lineupSnapshot.hasData || lineupSnapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No lineup available.'));
            }

            // Separate players by position
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
                    // Goalkeepers Section
                    const Text(
                      'Goalkeepers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPlayerTable(goalkeepers),
                    const SizedBox(height: 20),

                    // Defenders Section
                    const Text(
                      'Defenders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPlayerTable(defenders),

                    // Attackers Section
                    const Text(
                      'Attackers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPlayerTable(attackers),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPlayerTable(List<QueryDocumentSnapshot> players) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('#')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Age')),
        DataColumn(label: Text('M')),
      ],
      rows: players.map((player) {
        return DataRow(cells: [
          DataCell(Text(
            player['number'].toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          DataCell(Text(
            player['name'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )),
          DataCell(Text(player['age'].toString())),
          DataCell(Text(player['games'].toString())),
        ]);
      }).toList(),
    );
  }
}