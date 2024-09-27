import 'package:flutter/material.dart';

class TeamsPage extends StatelessWidget {
  const TeamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 95),
          child: Text("Teams"),
        ),
    ),
    );
  }
}