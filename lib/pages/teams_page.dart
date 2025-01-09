import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'team_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

// vykreslení stránky s týmy
class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});
// vytvoření stavového objektu pro stránku s týmy
  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

// stavový objekt pro stránku s týmy
class _TeamsPageState extends State<TeamsPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  // metoda pro přidání/odebrání týmu z oblíbených
  Future<void> _toggleFavorite(String teamName, bool isFavorite) async {
    if (user != null) {
      DocumentReference userDoc = firestore.collection('users').doc(user!.uid);
      if (isFavorite) {
        await userDoc.set({
          'favouriteTeams': FieldValue.arrayRemove([teamName])
        }, SetOptions(merge: true));
      } else {
        await userDoc.set({
          'favouriteTeams': FieldValue.arrayUnion([teamName])
        }, SetOptions(merge: true));
      }
    }
  }
  // metoda pro zjištění, zda je tým v oblíbených
  Future<bool> _isFavorite(String teamName) async {
    if (user != null) {
      DocumentSnapshot userDoc = await firestore.collection('users').doc(user!.uid).get();
      List<dynamic> favoriteTeams = userDoc.get('favouriteTeams') ?? [];
      return favoriteTeams.contains(teamName);
    }
    return false;
  }

// vykreslení stránky s týmy
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
      // zobrazení seznamu týmů
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('teams').snapshots(),
        builder: (context, snapshot) {
          // Zobrazení načítání, pokud je stream ve stavu čekání
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Zobrazení textu, pokud nejsou k dispozici žádné týmy
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No teams available.'));
          }
          // zobrazení seznamu týmů
          return Scrollbar(
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                String teamName = doc['name'];
                String teamLogo = doc['logo'];
                String teamStadium = doc['stadion'];
                // zobrazení jednotlivých týmů
                return FutureBuilder<bool>(
                  future: _isFavorite(teamName),
                  builder: (context, favSnapshot) {
                    if (!favSnapshot.hasData) {
                      return const SizedBox.shrink();
                    }
                    bool isFavorite = favSnapshot.data!;
                    return Column(
                      children: [
                        // zobrazení jednoho týmu
                        Card(
                          elevation: 8,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            leading: Image.network(
                              teamLogo,
                              width: 40,
                              height: 40,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, size: 30);
                              },
                            ),
                            title: Text(
                              teamName,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                color: isFavorite ? Colors.yellow : null,
                              ),
                              onPressed: () {
                                _toggleFavorite(teamName, isFavorite);
                                setState(() {});
                              },
                            ),
                            onTap: () {
                              // Navigace na stránku s detaily týmu
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamDetailsPage(
                                    teamName: teamName,
                                    teamLogo: teamLogo,
                                    teamStadium: teamStadium,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
