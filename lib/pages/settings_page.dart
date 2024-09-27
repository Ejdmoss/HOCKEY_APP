import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hockey_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // app bar s leading buttonem na rozkliknutí sidebaru
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 95),
          child: Text("Settings"),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(left: 25, top: 10, right: 25),
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // dark mode
                Text(
                  "Dark Mode",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),

                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isdarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 25),
            child: Text(
              "Select your favourite team:",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255, 255, 204, 0),
                    Color.fromARGB(255, 0, 0, 0),
                  ]),
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text(
                  "Litvínov",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )),
              ),
              const SizedBox(width: 10),
              Container(
                width: 150,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255, 238,27,42),
                    Color.fromARGB(255, 255, 255, 255),
                  ]),
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text("Pardubice",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15))),
              ),
              const SizedBox(height: 60),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255, 21, 119, 64),
                    Color.fromARGB(255, 0, 0, 0),
                  ]),
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text(
                  "Mladá Boleslav",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )),
              ),
              const SizedBox(width: 10),
              Container(
                width: 150,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255,117,1,38),
                    Color.fromARGB(255, 255, 255, 255),
                  ]),
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text("Sparta Praha",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15))),
              ),
              const SizedBox(height: 60)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255,49,70,117),
                    Color.fromARGB(255,255,255,255),
                  ]),
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text(
                  "Vítkovice",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )),
              ),
              const SizedBox(width: 10),
              Container(
                width: 150,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255, 0, 0, 0),
                    Color.fromARGB(255, 255, 255, 255),
                  ]),
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text("Kladno",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15))),
              ),
              const SizedBox(height: 60)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255,117,1,38),
                    Color.fromARGB(255, 255, 255, 255),
                  ]),
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text(
                  "České Budějovice",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )),
              ),
              const SizedBox(width: 10),
              Container(
                width: 150,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255,164,35,39),
                    Color.fromARGB(255,218,205,198),
                  ]),
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text("Třinec",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15))),
              ),
              const SizedBox(height: 60)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255,33,48,71),
                    Color.fromARGB(255,255,255,255),
                  ]),
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text(
                  "Liberec",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )),
              ),
              const SizedBox(width: 10),
              Container(
                width: 150,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255, 56, 54, 61),
                    Color.fromARGB(255,255,255,255),
                  ]),
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text("Karlovy Vary",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15))),
              ),
              const SizedBox(height: 60)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text(
                  "Olomouc",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )),
              ),
              const SizedBox(width: 10),
              Container(
                width: 150,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text("Kometa Brno",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15))),
              ),
              const SizedBox(height: 60)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text(
                  "Plzeň",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )),
              ),
              const SizedBox(width: 10),
              Container(
                width: 150,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text("Mountfield HK",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15))),
              ),
              const SizedBox(height: 60)
            ],
          ),
        ],
      ),
    );
  }
}
