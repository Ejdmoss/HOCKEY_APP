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
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color:  const Color.fromARGB(255,0,88,159).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        'Goalkeepers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPlayerTable(goalkeepers),
                    const SizedBox(height: 20),

                    // Defenders Section
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255,0,128,1).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        'Defenders',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPlayerTable(defenders),

                    // Attackers Section
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255,149,6,6).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        'Attackers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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

  List<DataColumn> _buildColumns() {
    return const [
      DataColumn(label: Text('#')),
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('Age')),
      DataColumn(label: Text('M')),
    ];
  }

  List<DataRow> _buildRows(List<QueryDocumentSnapshot> players) {
    return players.map((player) {
      return DataRow(cells: [
        DataCell(Text(
          player['number'].toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          player['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(Text(player['age'].toString())),
        DataCell(Text(player['games'].toString())),
      ]);
    }).toList();
  }

  Widget _buildPlayerTable(List<QueryDocumentSnapshot> players) {
    return DataTable(
      columns: _buildColumns(),
      rows: _buildRows(players),
    );
  }
}
