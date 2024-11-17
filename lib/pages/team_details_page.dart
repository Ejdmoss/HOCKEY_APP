import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

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

class _TeamDetailsPageState extends State<TeamDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final databaseReference = FirebaseDatabase.instance.ref('table');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Arena: ${widget.teamStadium}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            TabBar(
              controller: _tabController,
              indicatorColor: const Color.fromARGB(255, 20, 91, 168),
              labelColor: Theme.of(context).colorScheme.inversePrimary,
              unselectedLabelColor: Theme.of(context).colorScheme.inversePrimary,
              labelStyle: const TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(text: 'Matches'),
                Tab(text: 'Table'),
                Tab(text: 'Lineup'),
              ],
            ),
            const SizedBox(height: 20),
            // TabBarView
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Matches Tab Content
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'This is the Matches section.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                   // Table Tab Content
                  Column(
                    children: [
                      // Header Row
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "#",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                "Team",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 22),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "M",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "W",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "L",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "P",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        height: 1,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      // FirebaseAnimatedList for table data
                      Expanded(
                        child: FirebaseAnimatedList(
                          query: databaseReference,
                          itemBuilder: (context, snapshot, animation, index) {
                            int placement = snapshot.child("placement").value as int;
                            String teamName = snapshot.child("name").value.toString();
                            bool isCurrentTeam = teamName == widget.teamName;

                            return Container(
                              decoration: BoxDecoration(
                                color: isCurrentTeam ? Colors.yellow.withOpacity(0.3) : Colors.transparent, // Highlight current team
                                borderRadius: BorderRadius.circular(10), // Make the box rounded
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                    title: Row(
                                      children: [
                                        // Placement
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            '$placement.',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        // Team name and logo
                                        Expanded(
                                          flex: 5,
                                          child: Row(
                                            children: [
                                              Image.network(
                                                snapshot.child("logo").value.toString(),
                                                width: 20,
                                                height: 20,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return const Icon(Icons.error, size: 20);
                                                },
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                teamName,
                                                style: const TextStyle(fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        // Matches, Wins, Loses, Points
                                        Expanded(
                                          flex: 1,
                                          child: Text(snapshot.child("matches").value.toString()),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(snapshot.child("wins").value.toString()),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(snapshot.child("loses").value.toString()),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            snapshot.child("points").value.toString(),
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    height: 1,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // Lineup Tab Content
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'This is the Lineup section.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
