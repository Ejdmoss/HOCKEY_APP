import 'package:flutter/material.dart';
import 'package:hockey_app/sevices/auth/auth_gate.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Nastavení obrázku na pozadí
          image: DecorationImage(
            image: AssetImage('lib/images/plocha.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 550),
              const Text(
                // Text uvítání
                'Welcome to Hockey App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(0, 101, 172, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: () {
                  // Navigace na AuthGate stránku
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthGate()),
                  );
                },
                // Text tlačítka
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
