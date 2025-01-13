import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GameDetailsPage extends StatelessWidget {
  final String matchId;

  const GameDetailsPage({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Nastavení barvy pozadí
      // ignore: deprecated_member_use
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        // Nastavení barvy pozadí AppBaru
        // ignore: deprecated_member_use
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Image.asset(
          'lib/images/ehl4.png',
          height: 55,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        // Stream pro načítání dat zápasu z Firestore
        stream: FirebaseFirestore.instance
            .collection('matches')
            .doc(matchId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Zobrazení indikátoru načítání
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            // Zobrazení zprávy, pokud nejsou dostupné žádné detaily zápasu
            return const Center(child: Text('No match details available.'));
          }

          final matchData = snapshot.data!.data() as Map<String, dynamic>;
          // Načtení dat o týmech a skóre
          final team1Name = matchData['team1name'];
          final team2Name = matchData['team2name'];
          final team1Logo = matchData['team1logo'];
          final team2Logo = matchData['team2logo'];
          final team1Score = int.parse(matchData['team1score'].toString());
          final team2Score = int.parse(matchData['team2score'].toString());
          final matchDate = matchData['date'] is Timestamp
              ? (matchData['date'] as Timestamp).toDate()
              : DateTime.parse(matchData['date']);
          final formattedDate = DateFormat('dd. MM. yyyy').format(matchDate);

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Column(
              children: [
                Container(
                  // Kontejner pro zobrazení základních informací o zápasu
                  height: 148,
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
                    image: DecorationImage(
                      image: AssetImage(
                        Theme.of(context).brightness == Brightness.light
                            ? 'lib/images/gradient.jpeg'
                            : 'lib/images/gradient.jpeg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Zobrazení data zápasu
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Zobrazení loga týmu 1
                          Image.network(
                            team1Logo,
                            width: 60,
                            height: 60,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, size: 50);
                            },
                          ),
                          const SizedBox(width: 20),
                          // Zobrazení skóre
                          Text(
                            '$team1Score - $team2Score',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Zobrazení loga týmu 2
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
                      const Text(
                        'Full Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                // Zobrazení gólů a trestů podle období
                _buildGoalsByPeriod(context, matchData, team1Name, team2Name),
                Divider(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color:
                        const Color.fromRGBO(0, 101, 172, 1).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Game lineup',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                        // Zobrazení sestavy týmu 1
                        _buildTeamLineup(context, team1Name),
                        // Zobrazení sestavy týmu 2 (zrcadleně)
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

  // Funkce pro zobrazení gólů a trestů podle období
  Widget _buildGoalsByPeriod(BuildContext context,
      Map<String, dynamic> matchData, String team1Name, String team2Name) {
    List<Widget> periods = [];
    int team1CurrentScore = 0;
    int team2CurrentScore = 0;

    for (int period = 1; period <= 3; period++) {
      List<Map<String, dynamic>> events = [];
      for (int i = 1; i <= 10; i++) {
        String goalKey = 'g$i';
        String timeKey = 'g${i}time';
        String teamKey = 'g${i}team';
        if (matchData.containsKey(goalKey) &&
            matchData.containsKey(timeKey) &&
            matchData.containsKey(teamKey)) {
          int goalTime =
              int.parse(matchData[timeKey].toString().split(':')[0]) * 60 +
                  int.parse(matchData[timeKey].toString().split(':')[1]);
          if (goalTime >= (period - 1) * 20 * 60 &&
              goalTime < period * 20 * 60) {
            events.add({
              'type': 'goal',
              'time': goalTime,
              'team': matchData[teamKey],
              'displayTime': goalTime - (period - 1) * 20 * 60,
              'score': matchData[goalKey],
            });
          }
        }

        String penaltyTimeKey = 'c${i}time';
        String penaltyPlayerKey = 'c$i';
        String penaltyInfoKey = 'c${i}info';
        String penaltyDurationKey = 'c${i}penalty';
        String penaltyTeamKey = 'c${i}team';
        if (matchData.containsKey(penaltyTimeKey) &&
            matchData.containsKey(penaltyPlayerKey) &&
            matchData.containsKey(penaltyInfoKey) &&
            matchData.containsKey(penaltyDurationKey) &&
            matchData.containsKey(penaltyTeamKey)) {
          int penaltyTime =
              int.parse(matchData[penaltyTimeKey].toString().split(':')[0]) *
                      60 +
                  int.parse(matchData[penaltyTimeKey].toString().split(':')[1]);
          if (penaltyTime >= (period - 1) * 20 * 60 &&
              penaltyTime < period * 20 * 60) {
            events.add({
              'type': 'penalty',
              'time': penaltyTime,
              'team': matchData[penaltyTeamKey],
              'displayTime': penaltyTime - (period - 1) * 20 * 60,
              'duration': matchData[penaltyDurationKey],
              'player': matchData[penaltyPlayerKey],
              'info': matchData[penaltyInfoKey],
            });
          }
        }
      }

      events.sort((a, b) => a['time'].compareTo(b['time']));

      List<Widget> goalsAndPenalties = [];
      for (var event in events) {
        if (event['type'] == 'goal') {
          if (event['team'] == team1Name) {
            team1CurrentScore++;
          } else {
            team2CurrentScore++;
          }

          String currentScore = '$team1CurrentScore - $team2CurrentScore';
          String displayTimeFormatted =
              '${(event['displayTime'] ~/ 60).toString().padLeft(2, '0')}:${(event['displayTime'] % 60).toString().padLeft(2, '0')}';

          goalsAndPenalties.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: event['team'] == team1Name
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  if (event['team'] == team1Name) ...[
                    // Zobrazení času gólu
                    Text(
                      displayTimeFormatted,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Zobrazení aktuálního skóre
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 5),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(242, 243, 245, 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        currentScore,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Zobrazení skórujícího týmu
                    Text(
                      event['score'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ] else ...[
                    // Zobrazení skórujícího týmu
                    Text(
                      event['score'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Zobrazení aktuálního skóre
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 5),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(242, 243, 245, 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        currentScore,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Zobrazení času gólu
                    Text(
                      displayTimeFormatted,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        } else if (event['type'] == 'penalty') {
          String displayTimeFormatted =
              '${(event['displayTime'] ~/ 60).toString().padLeft(2, '0')}:${(event['displayTime'] % 60).toString().padLeft(2, '0')}';
          bool isRedPenalty = event['duration'].contains('10');
          Color penaltyColor = isRedPenalty
              ? const Color.fromRGBO(219, 7, 7, 1)
              : const Color.fromRGBO(255, 205, 0, 1);
          Color textColor = isRedPenalty ? Colors.white : Colors.black;

          goalsAndPenalties.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: event['team'] == team1Name
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  if (event['team'] == team1Name) ...[
                    // Zobrazení času trestu
                    Text(
                      displayTimeFormatted,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Zobrazení délky trestu
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 5),
                      decoration: BoxDecoration(
                        color: penaltyColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        event['duration'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Zobrazení hráče, který dostal trest
                    Text(
                      event['player'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Zobrazení důvodu trestu
                    Text(
                      event['info'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ] else ...[
                    // Zobrazení důvodu trestu
                    Text(
                      event['info'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Zobrazení hráče, který dostal trest
                    Text(
                      event['player'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Zobrazení délky trestu
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 5),
                      decoration: BoxDecoration(
                        color: penaltyColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        event['duration'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Zobrazení času trestu
                    Text(
                      displayTimeFormatted,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }
      }

      periods.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(13, 101, 172, 1).withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Period $period',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 5),
            ...goalsAndPenalties,
            if (goalsAndPenalties.isEmpty)
              const Text(
                'No goals or penalties in this period.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            const SizedBox(height: 10),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: periods,
      ),
    );
  }

  // Funkce pro zobrazení sestavy týmu
  Widget _buildTeamLineup(BuildContext context, String teamName,
      {bool mirrored = false}) {
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

  // Funkce pro zobrazení řady hráčů
  Widget _buildPlayerRow(
      BuildContext context, List<QueryDocumentSnapshot> players, bool mirrored,
      {int count = 1}) {
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
                  backgroundColor: mirrored
                      ? Colors.white
                      : const Color.fromRGBO(13, 101, 172, 1),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: mirrored
                        ? Colors.white
                        : const Color.fromRGBO(13, 101, 172, 1),
                    backgroundImage: NetworkImage(player['pic']),
                    onBackgroundImageError: (error, stackTrace) {},
                  ),
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
