import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hockey_app/addons/my_textfield.dart';

class FillDataPage extends StatefulWidget {
  const FillDataPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FillDataPageState createState() => _FillDataPageState();
}

class _FillDataPageState extends State<FillDataPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _team1NameController = TextEditingController();
  final TextEditingController _team1ScoreController = TextEditingController();
  final TextEditingController _team2NameController = TextEditingController();
  final TextEditingController _team2ScoreController = TextEditingController();

  void _saveData() async {
    try {
      // Fetch team1 logo
      var team1Snapshot = await FirebaseFirestore.instance
          .collection('teams')
          .where('name', isEqualTo: _team1NameController.text)
          .get();
      var team1Logo = team1Snapshot.docs.isNotEmpty
          ? team1Snapshot.docs.first['logo']
          : '';

      // Fetch team2 logo
      var team2Snapshot = await FirebaseFirestore.instance
          .collection('teams')
          .where('name', isEqualTo: _team2NameController.text)
          .get();
      var team2Logo = team2Snapshot.docs.isNotEmpty
          ? team2Snapshot.docs.first['logo']
          : '';

      // Save match data
      await FirebaseFirestore.instance.collection('matches').add({
        'date': _dateController.text,
        'team1name': _team1NameController.text,
        'team1score': _team1ScoreController.text,
        'team1logo': team1Logo,
        'team2name': _team2NameController.text,
        'team2score': _team2ScoreController.text,
        'team2logo': team2Logo,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully')),
      );
      _dateController.clear();
      _team1NameController.clear();
      _team1ScoreController.clear();
      _team2NameController.clear();
      _team2ScoreController.clear();
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fill Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MyTexfield(
              controller: _dateController,
              hintText: 'Date (yyyy-mm-dd)',
              obscureText: false,
            ),
            const SizedBox(height: 16),
            MyTexfield(
              controller: _team1NameController,
              hintText: 'Team 1 Name',
              obscureText: false,
            ),
            const SizedBox(height: 16),
            MyTexfield(
              controller: _team1ScoreController,
              hintText: 'Team 1 Score',
              obscureText: false,
            ),
            const SizedBox(height: 16),
            MyTexfield(
              controller: _team2NameController,
              hintText: 'Team 2 Name',
              obscureText: false,
            ),
            const SizedBox(height: 16),
            MyTexfield(
              controller: _team2ScoreController,
              hintText: 'Team 2 Score',
              obscureText: false,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveData,
              child: const Text('Save Data'),
            ),
          ],
        ),
      ),
    );
  }
}