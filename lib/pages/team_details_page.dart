import 'package:flutter/material.dart';
import 'package:hockey_app/pages/matches_tab_content.dart';
import 'package:hockey_app/pages/table_tab_content.dart';
import 'package:hockey_app/addons/bottom_navigation_bar.dart';
import 'package:hockey_app/pages/lineup_tab_content_page.dart';

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

  @override
  State<TeamDetailsPage> createState() => _TeamDetailsPageState();
}

class _TeamDetailsPageState extends State<TeamDetailsPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Pozadí stránky s obrázkem
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          // Obsah stránky
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar s průhledným pozadím
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Informace o týmu
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo týmu
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
                      // Název týmu a stadion
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.teamName,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Arena: ${widget.teamStadium}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Oddělovač
                Divider(
                  thickness: 1,
                  height: 1,
                  color: Colors.white.withOpacity(0.3),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: _selectedIndex == 1
                        ? MatchesTabContent(teamName: widget.teamName)
                        : _selectedIndex == 0
                            ? TableTabContent(teamName: widget.teamName)
                            : LineupTabContentPage(
                                teamName: widget.teamName),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Dolní navigační lišta
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
