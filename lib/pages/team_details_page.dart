import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hockey_app/pages/matches_tab_content.dart';
import 'package:hockey_app/pages/table_tab_content.dart';
import 'package:hockey_app/addons/bottom_navigation_bar.dart';

// vykreslení stránky s detaily týmu
class TeamDetailsPage extends StatefulWidget {
  final String teamName;
  final String teamLogo;
  final String teamStadium;
  // konstruktor stránky s detaily týmu
  const TeamDetailsPage({
    super.key,
    required this.teamName,
    required this.teamLogo,
    required this.teamStadium,
  });
// vytvoření stavového objektu pro stránku s detaily týmu
  @override
  State<TeamDetailsPage> createState() => _TeamDetailsPageState();
}

// stavový objekt pro stránku s detaily týmu
class _TeamDetailsPageState extends State<TeamDetailsPage> {
  int _selectedIndex = 0;
  final databaseReference = FirebaseDatabase.instance.ref('table');
// inicializace stavového objektu
  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

// vykreslení stránky s detaily týmu
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
                // Logo týmu a informace o stadionu
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
                  // Načtení obrázku z URL
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
                // Název týmu a stadion
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
                    // Text s informacemi o stadionu
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
            // Oddělovač
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
      // Dolní navigační lišta
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// třída pro zobrazení obsahu záložky s soupiskou
class LineupTabContent extends StatelessWidget {
  const LineupTabContent({super.key});
// vykreslení obsahu záložky s soupiskou
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
