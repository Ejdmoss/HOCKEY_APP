import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'team_details_page.dart';

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
// vykreslení stránky s týmy
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teams"),
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
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}
