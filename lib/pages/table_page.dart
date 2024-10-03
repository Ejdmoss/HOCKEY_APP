import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

final databaseReference = FirebaseDatabase.instance.ref('teams');

class _TablePageState extends State<TablePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController placementController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 95),
          child: Text("Table"),
        ),
      ),
      body: Column(
        children: [
          
          // reading realtime database
          Expanded(
            child: FirebaseAnimatedList(
              query: databaseReference,
              itemBuilder: (context, snapshot, animation, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    leading: CircleAvatar(
                      child: Text(
                        (index + 1).toString(),
                      ),
                    ),
                    title: Text(snapshot.child("name").value.toString(),
                    ),
                  ),
                );
              },
            ),
          ),
         
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          placementController.clear();
          nameController.clear();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return myDialogBo(
                  context: context,
                  name: "Create",
                  placement: "add",
                  onPressed: () {
                    final id = DateTime.now().millisecondsSinceEpoch.toString();
                    databaseReference.child(id).set({
                      'name': nameController.text.toString(),
                      "address": placementController.text.toString(),
                      'id': id
                    });
                    Navigator.pop(context);
                  },
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // dialog box
  Dialog myDialogBo({
    required BuildContext context,
    required String name,
    required String placement,
    required VoidCallback onPressed,
  }) {
    return Dialog(
      backgroundColor: Colors.yellow,
      child: Container(
        decoration: const BoxDecoration(color: Colors.red),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.green),
                ),
                CircleAvatar(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Enter the name"),
            ),
            TextField(
              controller: placementController,
              decoration:
                  const InputDecoration(labelText: "Enter the placement"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(placement),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
