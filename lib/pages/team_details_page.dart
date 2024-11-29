import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hockey_app/pages/matches_tab_content.dart';
import 'package:hockey_app/pages/table_tab_content.dart';
import 'package:hockey_app/addons/bottom_navigation_bar.dart';

class TeamDetailsPage extends StatefulWidget {
  final String teamName;
  final String teamLogo;
  final String teamStadium;

  const TeamDetailsPage({
    super.key,
    required this.teamName,
    required this.teamLogo,
    required this.teamStadium,
  });

  @override
  State<TeamDetailsPage> createState() => _TeamDetailsPageState();
}

class _TeamDetailsPageState extends State<TeamDetailsPage> {
  int _selectedIndex = 0;
  final databaseReference = FirebaseDatabase.instance.ref('table');

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo with border radius and shadow
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.teamLogo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, size: 50);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Team name and stadium information
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.teamName,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Arena: ${widget.teamStadium}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(
              thickness: 1,
              height: 1,
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
            ),
            Expanded(
              child: _selectedIndex == 0
                  ? MatchesTabContent(teamName: widget.teamName)
                  : _selectedIndex == 1
                      ? TableTabContent(teamName: widget.teamName)
                      : const LineupTabContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class LineupTabContent extends StatelessWidget {
  const LineupTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'This is the Lineup section.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
