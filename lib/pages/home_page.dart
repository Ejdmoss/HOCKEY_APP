import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hockey_app/addons/my_drawer.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime selectedDate = DateTime.now(); // Start with today's date
  int selectedMonthIndex = DateTime.now().month - 1; // Month index for dropdown

  // List of month names
  final List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  // Fetch games from Firestore for the selected date
  Stream<QuerySnapshot> getGamesForDate(DateTime date) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return firestore.collection('matches')
      .where('date', isEqualTo: formattedDate)
      .snapshots();
  }

  // Change date by offsetting days
  void changeDate(int offset) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: offset));
    });
  }

  // Update month based on the selected month index
  void updateMonth(int index) {
    setState(() {
      selectedMonthIndex = index;
      // Update selectedDate to the first day of the new month
      selectedDate = DateTime(selectedDate.year, index + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the month and year with dropdown
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Show the dropdown menu when the text is tapped
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(100.0, 100.0, 0.0, 0.0), // Position of the dropdown
                      items: List.generate(monthNames.length, (index) {
                        return PopupMenuItem<int>(
                          value: index,
                          child: Text(monthNames[index]),
                        );
                      }),
                    ).then((value) {
                      if (value != null) {
                        updateMonth(value); // Update the selected month
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(selectedDate), // Month and Year
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8), // Space between text and icon
                      Icon(
                        Icons.arrow_drop_down, // Dropdown icon
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Horizontal Date Picker
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7, // Display a week of dates
              itemBuilder: (context, index) {
                DateTime date = selectedDate.add(Duration(days: index - 3)); // Center the selected date
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date; // Set the selected date on tap
                    });
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: date.isAtSameMomentAs(selectedDate) ? Colors.blueAccent : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE').format(date), // Day of the week
                          style: TextStyle(
                            color: date.isAtSameMomentAs(selectedDate) ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          DateFormat('dd').format(date), // Day of the month
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: date.isAtSameMomentAs(selectedDate) ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Fetch and display games for the selected date
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getGamesForDate(selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No games available for this date.'));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.only(left: 20, right: 20),
                          title: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Row(
                                  children: [
                                    Image.network(
                                      doc["team1logo"] ?? "", // Handle missing logo
                                      width: 30,
                                      height: 30,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.error, size: 20);
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        doc["team1name"] ?? "Team 1", // Handle missing team name
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        doc["team1score"].toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(':'), // Separator
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  doc["team2score"].toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Row(
                                  children: [
                                    Image.network(
                                      doc["team2logo"] ?? "", // Handle missing logo
                                      width: 30,
                                      height: 30,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.error, size: 20);
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        doc["team2name"] ?? "Team 2", // Handle missing team name
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
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
