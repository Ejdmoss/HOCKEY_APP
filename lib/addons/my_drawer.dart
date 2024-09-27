import 'package:flutter/material.dart';
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
          // logo mojí aplikace
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Icon(Icons.sports_hockey,
                size: 80, color: Theme.of(context).colorScheme.inversePrimary),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Divider(color: Theme.of(context).colorScheme.secondary),
          ),
          // home list title
          MyDrawerTitle(
              text: "Home",
              icon: Icons.home,
              onTap: () => Navigator.pop(context)),
          // Teams list title
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
              }),
          // Table list title
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
              }),
          // Mezera mezi tlačítka tak aby byl Log Out dole
          const Spacer(),
          // Settings list title
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
              }),
          // LogOut list title
          MyDrawerTitle(text: "Log Out", icon: Icons.logout, onTap: logout),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
