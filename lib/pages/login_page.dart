// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hockey_app/addons/my_button.dart';
import 'package:hockey_app/addons/my_textfield.dart';
import 'package:hockey_app/sevices/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  // Funkce, která se zavolá při kliknutí na odkaz pro registraci.
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Řídící objekty pro textová pole pro email a heslo.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // login funkce
  void login() async {
    final authService = AuthService();

    try {
      await authService.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  void forgotPw() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("User Tapped forgot password"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Nastavujeme pozadí stránky podle aktuálního tématu.
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo TipsportExtraligy
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Image.asset(
                'lib/images/ehl2.jpg',
                height: 150,
              ),
            ),
            // Úvodní zpráva, název aplikace.
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                "Hockey app",
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                    ),
                    
              ),
            ),
            const SizedBox(height: 10),
            // Pole pro zadání emailu.
            MyTexfield(
                controller: emailController,
                hintText: "Email",
                obscureText: false),
            const SizedBox(height: 10),
            // Pole pro zadání hesla.
            MyTexfield(
                controller: passwordController,
                hintText: "Password",
                obscureText: true),
            const SizedBox(height: 25),
            // Tlačítko pro přihlášení.
            MyButton(text: "Sign In", onTap: login),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member?",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
                const SizedBox(width: 4),
                // Odkaz pro registraci, který spustí funkci onTap.
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Register now",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
