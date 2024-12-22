import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hockey_app/addons/my_drawer_title.dart';
import 'package:hockey_app/pages/archive_page.dart';
import 'package:hockey_app/pages/settings_page.dart';
import 'package:hockey_app/pages/table_page.dart';
import 'package:hockey_app/pages/teams_page.dart';
import 'package:hockey_app/sevices/auth/auth_service.dart';
import 'package:hockey_app/pages/fill_data_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

// vykreslení bočního menu
class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});
  final String userId = FirebaseAuth.instance.currentUser!.uid;
// funkce pro odhlášení uživatele
  void logout() {
    final authService = AuthService();
    authService.signOut();
  }

// vytvoření bočního menu
  @override
  Widget build(BuildContext context) {
    // vytvoření bočního menu
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // zobrazení loga týmu a přezdívky uživatele
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('chosenTeam')
                .doc('team')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Container(
                  padding: const EdgeInsets.only(top: 70, left: 15),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.asset(
                          'lib/images/ehl4.png',
                          width: 75,
                          height: 75,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No Team',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Please select a team',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              // získání dat o uživateli
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('data')
                    .doc('nickname')
                    .get(),
                builder: (context, userSnapshot) {
                  // pokud se načítají data
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  // pokud uživatel nemá přezdívku
                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return Container(
                      padding: const EdgeInsets.only(top: 70, left: 15),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.asset(
                              'lib/images/ehl2.png',
                              width: 75,
                              height: 75,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No Nickname',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Please select a team',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  // získání dat o uživateli
                  var userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  String nickname = userData['nickname'] ?? 'No Nickname';
                  // získání dat o týmu
                  var teamData = snapshot.data!.data() as Map<String, dynamic>;
                  String teamLogo = teamData['logo'];
                  String teamName = teamData['name'];
                  // vytvoření loga týmu a přezdívky uživatele
                  return Container(
                    padding: const EdgeInsets.only(top: 70, left: 15),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.network(
                            teamLogo,
                            width: 75,
                            height: 75,
                            // pokud se logo nenačte
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'lib/images/ehl2.png',
                                width: 75,
                                height: 75,
                              );
                            },
                          ),
                        ),
                        Column(
                          // zobrazení přezdívky a jména týmu
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nickname,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              teamName,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          // oddělení
          Padding(
            padding: const EdgeInsets.all(25),
            child: Divider(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
          ),
          // titulky v bočním menu
          MyDrawerTitle(
            text: "Home",
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),
          MyDrawerTitle(
            text: "Teams",
            icon: Icons.groups,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeamsPage(),
                ),
              );
            },
          ),
          MyDrawerTitle(
            text: "Table",
            icon: Icons.table_rows,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TablePage(),
                ),
              );
            },
          ),
          MyDrawerTitle(
            text: "Archive",
            icon: Icons.archive,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ArchivePage(),
                ),
              );
            },
          ),
          const Spacer(),
          MyDrawerTitle(
            text: "Settings",
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
          MyDrawerTitle(
            text: "Fill Data",
            icon: Icons.edit,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FillDataPage(),
                ),
              );
            },
          ),
          // vyvolaní funkce pro odhlášení uživatele
          MyDrawerTitle(
            text: "Log Out",
            icon: Icons.logout,
            onTap: logout,
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
