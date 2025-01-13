import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hockey_app/addons/my_textfield.dart';

// vytvoření třídy FillDataPage
class FillDataPage extends StatefulWidget {
  const FillDataPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FillDataPageState createState() => _FillDataPageState();
}

// vytvoření třídy _FillDataPageState
class _FillDataPageState extends State<FillDataPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _team1ScoreController = TextEditingController();
  final TextEditingController _team2ScoreController = TextEditingController();
  final TextEditingController _rController = TextEditingController();
  String? _selectedTeam1;
  String? _selectedTeam2;
  List<String> _teamNames = [];

  @override
  void initState() {
    super.initState();
    _fetchTeamNames();
  }

  // Metoda pro získání názvů týmů z databáze
  Future<void> _fetchTeamNames() async {
    var snapshot = await FirebaseFirestore.instance.collection('teams').get();
    setState(() {
      _teamNames = snapshot.docs.map((doc) => doc['name'].toString()).toList();
    });
  }

  // Metoda pro uložení dat do databáze
  void _saveData() async {
    try {
      // Získání dat týmu 1
      var team1Snapshot = await FirebaseFirestore.instance
          .collection('teams')
          .where('name', isEqualTo: _selectedTeam1)
          .get();
      var team1Logo =
          team1Snapshot.docs.isNotEmpty ? team1Snapshot.docs.first['logo'] : '';

      // Získání dat týmu 2
      var team2Snapshot = await FirebaseFirestore.instance
          .collection('teams')
          .where('name', isEqualTo: _selectedTeam2)
          .get();
      var team2Logo =
          team2Snapshot.docs.isNotEmpty ? team2Snapshot.docs.first['logo'] : '';

      // Uložení dat do Firestore
      await FirebaseFirestore.instance.collection('matches').add({
        'date': _dateController.text,
        'team1name': _selectedTeam1,
        'team1score': _team1ScoreController.text,
        'team1logo': team1Logo,
        'team2name': _selectedTeam2,
        'team2score': _team2ScoreController.text,
        'team2logo': team2Logo,
        'r': _rController.text,
      });

      // Zobrazení zprávy o úspěšném uložení dat
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully')),
      );
      // Vyčištění polí
      _dateController.clear();
      _team1ScoreController.clear();
      _team2ScoreController.clear();
      _rController.clear();
      setState(() {
        _selectedTeam1 = null;
        _selectedTeam2 = null;
      });
    } catch (error) {
      // Zobrazení zprávy o neúspěšném uložení dat
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data: $error')),
      );
    }
  }

  // vytvoření metody build
  @override
  Widget build(BuildContext context) {
    // Kontrola, zda je klávesnice viditelná
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'lib/images/ehl4.png',
          height: 55,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Vytvoření textových polí pro zadání dat
                  MyTexfield(
                    controller: _dateController,
                    hintText: 'Date (yyyy-mm-dd)',
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  // Vstupní pole pro zadání hodnoty R
                  MyTexfield(
                    controller: _rController,
                    hintText: 'R',
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedTeam1,
                    hint: const Text('Select Team 1'),
                    items: _teamNames.map((String team) {
                      return DropdownMenuItem<String>(
                        value: team,
                        child: Text(team),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      // Nastavení hodnoty pro vybraný tým
                      setState(() {
                        _selectedTeam1 = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Dropdown pro výběr týmu 2
                  DropdownButtonFormField<String>(
                    value: _selectedTeam2,
                    hint: const Text('Select Team 2'),
                    items: _teamNames.map((String team) {
                      return DropdownMenuItem<String>(
                        value: team,
                        child: Text(team),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedTeam2 = newValue;
                      });
                    },
                    // Nastavení vzhledu DropdownButton
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Dropdown pro výběr skóre týmu 1
                  DropdownButtonFormField<int>(
                    value: int.tryParse(_team1ScoreController.text),
                    hint: const Text('Team 1 Score'),
                    items: List.generate(10, (index) => index).map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    // Nastavení akce při změně hodnoty
                    onChanged: (newValue) {
                      setState(() {
                        _team1ScoreController.text = newValue.toString();
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Dropdown pro výběr skóre týmu 2
                  DropdownButtonFormField<int>(
                    value: int.tryParse(_team2ScoreController.text),
                    hint: const Text('Team 2 Score'),
                    items: List.generate(10, (index) => index).map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      // Nastavení hodnoty pro skóre týmu 2
                      setState(() {
                        _team2ScoreController.text = newValue.toString();
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _saveData,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 101, 172, 1),
                      ),
                    ),
                    child: const Text(
                      'Save Data',
                      style: TextStyle(color: Color.fromRGBO(0, 101, 172, 1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Zobrazení obrázku pouze pokud není viditelná klávesnice
          if (!isKeyboardVisible)
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
              child: Container(
                height: 215,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('lib/images/ehl2.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                // vytvoření vrstvy
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
