import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hockey_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// vykreslení stránky s nastaveními
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
// vytvoření stavového objektu pro stránku s nastaveními
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

// stavový objekt pro stránku s nastaveními
class _SettingsPageState extends State<SettingsPage> {
  String selectedTeamName = '';
  String nickname = '';
  bool isNicknameSubmitted = false;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // Metoda pro zobrazení pop-up zprávy
  void showPopupMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Notification',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(13, 101, 172, 1),
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // metoda pro uložení přezdívky do databáze
  Future<void> saveNicknameToDatabase(String nickname) async {
    final DocumentReference userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('data')
        .doc('nickname');

    try {
      // Uložení přezdívky do Firestore
      await userDoc.set({
        'nickname': nickname,
      });
      showPopupMessage('Nickname submitted!');
      setState(() {});
      // ignore: empty_catches
    } catch (e) {}
  }

  // Metoda pro uložení vybraného týmu do Firestore
  Future<void> saveSelectedTeamToDatabase(
      String teamName, String teamLogo) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');

    try {
      final DocumentReference nicknameDoc =
          userCollection.doc(userId).collection('data').doc('nickname');
      DocumentSnapshot nicknameSnapshot = await nicknameDoc.get();
      if (!nicknameSnapshot.exists) {
        await nicknameDoc.set({'nickname': 'No nickname set'});
      }

      // Uložení vybraného týmu do Firestore
      await userCollection
          .doc(userId)
          .collection('chosenTeam')
          .doc('team')
          .set({
        'name': teamName,
        'logo': teamLogo,
      });
      showPopupMessage('You chose: $teamName');
      // ignore: empty_catches
    } catch (e) {}
  }

  // vykreslení stránky s nastaveními
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 95),
          child: Text("Settings"),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Pole pro výběr režimu
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Theme.of(context).brightness == Brightness.light
                      ? 'lib/images/gradient.jpeg'
                      : 'lib/images/gradient.jpeg',
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(left: 25, top: 10, right: 25),
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text pro výběr režimu
                const Text(
                  "Dark Mode",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isdarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                ),
              ],
            ),
          ),
          // Pole pro zadání přezdívky
          Padding(
            padding: const EdgeInsets.all(25),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    Theme.of(context).brightness == Brightness.light
                        ? 'lib/images/gradient.jpeg'
                        : 'lib/images/gradient.jpeg',
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(25),
              child: Row(
                children: [
                  // Pole pro zadání přezdívky
                  Flexible(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter your nickname',
                        hintStyle: TextStyle(
                            color:
                                Colors.white),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ), 
                      onChanged: (value) {
                        setState(() {
                          nickname = value;
                          isNicknameSubmitted = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Podmínka pro uložení přezdívky do databáze
                      if (nickname.isNotEmpty && nickname.length <= 20) {
                        saveNicknameToDatabase(nickname);
                        setState(() {
                          isNicknameSubmitted = true;
                        });
                        // podmínka pro zobrazení chybové hlášky
                      } else if (nickname.length > 15) {
                        showPopupMessage(
                            'Nickname cannot be more than 15 characters.');
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Color.fromRGBO(13, 101, 172, 1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Zobrazení potvrzení o odeslání přezdívky
          Padding(
            padding: const EdgeInsets.only(bottom: 25, right: 25, left: 25),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    Theme.of(context).brightness == Brightness.light
                        ? 'lib/images/gradient.jpeg'
                        : 'lib/images/gradient.jpeg',
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(25),
              child: Row(
                children: [
                  // Text pro zapomenuté heslo
                  const Expanded(
                    child: Text(
                      'Forgotten password?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String email = FirebaseAuth.instance.currentUser!.email!;
                      // Odeslání emailu pro resetování hesla
                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email);
                        showPopupMessage(
                            'Password reset email sent to $email!');
                      } catch (e) {
                        showPopupMessage('Error: Unable to send reset email.');
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Color.fromRGBO(13, 101, 172, 1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Text pro výběr oblíbeného týmu
          Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 20),
            child: Text(
              "Select your favourite team:",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
          // Výběr oblíbeného týmu
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('teams').snapshots(),
              builder: (context, snapshot) {
                // Zobrazení načítání
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No teams available.'));
                }
                // Výběr týmu
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: snapshot.data!.docs.map((doc) {
                    String teamName = doc['name'];
                    String teamLogo = doc['logo'];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTeamName = teamName;
                        });
                        // Uložení vybraného týmu do Firestore
                        saveSelectedTeamToDatabase(teamName, teamLogo);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            // Zobrazení loga týmu
                            child: ClipOval(
                              child: Image.network(
                                teamLogo,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error, size: 30);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
