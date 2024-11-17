import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hockey_app/addons/my_drawer_title.dart';
import 'package:hockey_app/pages/settings_page.dart';
import 'package:hockey_app/pages/table_page.dart';
import 'package:hockey_app/pages/teams_page.dart';
import 'package:hockey_app/sevices/auth/auth_service.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    final authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('currentUser')
                .doc('chosenTeam')
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
                          'lib/images/ehl2.png',
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
                              color: Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Please select a team',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
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

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('currentUser')
                    .doc('data')
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
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
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Please select a team',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
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

                  var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  String nickname = userData['nickname'] ?? 'No Nickname';

                  var teamData = snapshot.data!.data() as Map<String, dynamic>;
                  String teamLogo = teamData['logo'];
                  String teamName = teamData['name'];

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
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'lib/images/ehl2.png',
                                width: 75,
                                height: 75,
                              ); // Fallback image
                            },
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nickname,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              teamName,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
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
          Padding(
            padding: const EdgeInsets.all(25),
            child: Divider(color: Theme.of(context).colorScheme.secondary),
          ),
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
          MyDrawerTitle(text: "Log Out", icon: Icons.logout, onTap: logout),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
