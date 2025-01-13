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

  // funkce pro zobrazení pop-up zprávy
  void showPopupMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Notification',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
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

  // funkce pro kontrolu role uživatele
  Future<void> checkUserRole(BuildContext context) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('data')
        .doc('roles')
        .get();
    String role = userDoc['role'];
    if (role == 'admin') {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => const FillDataPage(),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      showPopupMessage(context, 'Only admins are allowed to access this page');
    }
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
              // získání dat o uživateli
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('data')
                    .doc('nickname')
                    .snapshots(),
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
                              'lib/images/ehl4.png',
                              width: 75,
                              height: 75,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No nickname set',
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
                  String nickname = userData['nickname'] ?? 'No nickname set';
                  // získání dat o týmu
                  var teamData =
                      snapshot.data?.data() as Map<String, dynamic>? ?? {};
                  String teamLogo = teamData['logo'] ?? 'lib/images/ehl4.png';
                  String teamName = teamData['name'] ?? 'Please select a team';
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
                                'lib/images/ehl4.png',
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
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              teamName,
                              style: const TextStyle(
                                color: Color.fromRGBO(13, 101, 172, 1),
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
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const TablePage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
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
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const ArchivePage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
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
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const SettingsPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
          MyDrawerTitle(
            text: "Fill Data",
            icon: Icons.edit,
            onTap: () {
              Navigator.pop(context);
              checkUserRole(context);
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
