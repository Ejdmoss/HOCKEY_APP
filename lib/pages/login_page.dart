import 'package:flutter/material.dart';
import 'package:hockey_app/addons/my_button.dart';
import 'package:hockey_app/addons/my_textfield.dart';
import 'package:hockey_app/sevices/auth/auth_service.dart';
import 'package:hockey_app/themes/dark_mode.dart';

// vytvoření třídy LoginPage, která dědí od StatefulWidget
class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  // konstruktor třídy LoginPage
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// vytvoření třídy _LoginPageState, která dědí od State<LoginPage>
class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // metoda login, která zavolá metodu signInWithEmailAndPassword z třídy AuthService
  void login() async {
    final authService = AuthService();
    // zavolání metody signInWithEmailAndPassword s parametry emailController.text a passwordController.text
    try {
      await authService.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
      // v případě chyby se zobrazí AlertDialog s chybovou hláškou
    } catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  void forgotPassword() async {
    final authService = AuthService();
    try {
      await authService.sendPasswordResetEmail(emailController.text);
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Password reset email sent!"),
        ),
      );
    } catch (e) {
      showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  // metoda build, která vrací Scaffold s AppBar a tělem obsahujícím Stack s obrázkem a sloupcem s textovými poli a tlačítkem
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: darkMode,
      child: Scaffold(
        body: Stack(
          children: [
            // přidání obrázku s průhledností
            Opacity(
              opacity: 1,
              child: Image.asset(
                'lib/images/pozadi.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            // sloupec s textovými poli a tlačítkem
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 75.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // vstup pro email
                    MyTexfield(
                      controller: emailController,
                      hintText: "Email",
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    // vstup pro heslo
                    MyTexfield(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: forgotPassword,
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // přidání tlačítka s textem "Sign In" a funkcí login
                    MyButton(text: "Sign In", onTap: login),
                    const SizedBox(height: 25),
                    // řádek s textem "Not a member?" a GestureDetector s textem "Register now" a funkcí onTap
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Not a member?",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        // přidání GestureDetector s textem "Register now" a funkcí onTap
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Register now",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
