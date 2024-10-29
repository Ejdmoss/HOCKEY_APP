// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:hockey_app/addons/my_button.dart';
import 'package:hockey_app/addons/my_textfield.dart';
import 'package:hockey_app/sevices/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  // Funkce, která se zavolá při kliknutí na odkaz pro registraci.
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Řídící objekty pro textová pole pro email a heslo.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void register() async {
    final authService = AuthService();

    if (passwordController.text == confirmPasswordController.text) {
      try {
        await authService.signUpWithEmailAndPassword(
            emailController.text, passwordController.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match!"),
        ),
      );
    }
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
                "Let's create an account",
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
            const SizedBox(height: 10),
            // Pole pro zadání kontrolního hesla.
            MyTexfield(
                controller: confirmPasswordController,
                hintText: "Confirm password",
                obscureText: true),
            const SizedBox(height: 25),
            // Tlačítko pro zaregistrování.
            MyButton(text: "Sign Up", onTap: register),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "already have an account?",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
                const SizedBox(width: 4),
                // Odkaz pro přihlášení, který spustí funkci onTap.
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Login now",
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
