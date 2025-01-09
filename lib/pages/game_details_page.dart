import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GameDetailsPage extends StatelessWidget {
  final String matchId;

  const GameDetailsPage({super.key, required this.matchId});

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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('matches')
            .doc(matchId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No match details available.'));
          }

          final matchData = snapshot.data!.data() as Map<String, dynamic>;
          final team1Name = matchData['team1name'];
          final team2Name = matchData['team2name'];
          final team1Logo = matchData['team1logo'];
          final team2Logo = matchData['team2logo'];
          final team1Score = int.parse(matchData['team1score'].toString());
          final team2Score = int.parse(matchData['team2score'].toString());

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 120,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                    image: DecorationImage(
                      image: AssetImage(
                        Theme.of(context).brightness == Brightness.light
                            ? 'lib/images/orange.jpg'
                            : 'lib/images/gradient.jpeg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            team1Logo,
                            width: 60,
                            height: 60,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, size: 50);
                            },
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '$team1Score - $team2Score',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Image.network(
                            team2Logo,
                            width: 60,
                            height: 60,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, size: 50);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Full Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'lib/images/rink.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      children: [
                        _buildTeamLineup(context, team1Name),
                        _buildTeamLineup(context, team2Name, mirrored: true),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamLineup(BuildContext context, String teamName, {bool mirrored = false}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('teams')
          .where('name', isEqualTo: teamName)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No lineup available.'));
        }

        final teamDoc = snapshot.data!.docs.first;
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

            final goalkeepers = lineupSnapshot.data!.docs
                .where((doc) => doc['position'] == 'goalkeeper')
                .toList();
            final defenders = lineupSnapshot.data!.docs
                .where((doc) => doc['position'] == 'defender')
                .toList();
            final attackers = lineupSnapshot.data!.docs
                .where((doc) => doc['position'] == 'attacker')
                .toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (!mirrored) ...[
                    _buildPlayerRow(context, goalkeepers, mirrored),
                    const SizedBox(height: 10),
                    _buildPlayerRow(context, defenders, mirrored, count: 2),
                    const SizedBox(height: 12),
                    _buildPlayerRow(context, attackers, mirrored, count: 3),
                  ] else ...[
                    _buildPlayerRow(context, attackers, mirrored, count: 3),
                    const SizedBox(height: 10),
                    _buildPlayerRow(context, defenders, mirrored, count: 2),
                    const SizedBox(height: 5),
                    _buildPlayerRow(context, goalkeepers, mirrored),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPlayerRow(BuildContext context, List<QueryDocumentSnapshot> players, bool mirrored, {int count = 1}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(count, (index) {
        if (index < players.length) {
          final player = players[index];
          return Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(player['pic']),
                  onBackgroundImageError: (error, stackTrace) {
                  },
                ),
                const SizedBox(height: 5),
                Text(
                  '${player['name']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                ),
                SizedBox(height: 5),
                Text(''),
              ],
            ),
          );
        }
      }).reversed.toList(),
    );
  }
}
