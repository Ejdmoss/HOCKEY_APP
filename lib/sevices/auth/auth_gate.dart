import 'package:hockey_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hockey_app/sevices/auth/login_or_register.dart';

// Třída AuthGate slouží k rozhodnutí, zda uživatel je přihlášen, nebo se má zobrazit přihlášení/registrace.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        // Sledujeme změny stavu přihlášení uživatele pomocí Firebase.
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Pokud je uživatel přihlášen (data jsou dostupná), zobrazí se domovská stránka.
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            // Pokud uživatel není přihlášen, zobrazí se stránka pro přihlášení nebo registraci.
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
