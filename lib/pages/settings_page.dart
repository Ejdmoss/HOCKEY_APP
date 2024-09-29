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
              Image.asset(
                'lib/images/litvinov.png',
                height: 50,
              ),
              const SizedBox(width: 10),
              Image.asset(
                'lib/images/pardubice.png',
                height: 50,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/images/mladabol.png',
                height: 50,
              ),
              const SizedBox(width: 10),
              Image.asset(
                'lib/images/sparta.png',
                height: 50,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/images/vitkovice.png',
                height: 50,
              ),
              const SizedBox(width: 10),
              Image.asset(
                'lib/images/kladno.png',
                height: 50,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/images/ceskebudej.png',
                height: 50,
              ),
              const SizedBox(width: 10),
              Image.asset(
                'lib/images/trinecek.png',
                height: 50,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/images/liberec.png',
                height: 50,
              ),
              const SizedBox(width: 10),
              Image.asset(
                'lib/images/karlovyvary.png',
                height: 50,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/images/olomouc.png',
                height: 50,
              ),
              const SizedBox(width: 10),
              Image.asset(
                'lib/images/brno.png',
                height: 50,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/images/plzen.png',
                height: 50,
              ),
              const SizedBox(width: 10),
              Image.asset(
                'lib/images/hradec.png',
                height: 50,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
