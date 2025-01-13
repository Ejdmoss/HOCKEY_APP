// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:hockey_app/addons/my_button.dart';
import 'package:hockey_app/addons/my_textfield.dart';
import 'package:hockey_app/sevices/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hockey_app/themes/dark_mode.dart';

class RegisterPage extends StatefulWidget {
  // Funkce spuštěná při kliknutí na odkaz pro přihlášení.
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Ovladače pro textová pole e-mailu a hesla.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void register() async {
    final authService = AuthService();
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Kontrola formátu e-mailu
    if (!email.contains('@') || !email.contains('.')) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Invalid Email Format"),
          content: Text("Email must have be in format xxx@xxx.xx"),
        ),
      );
      return;
    }

    // Kontrola délky hesla a velkého písmena
    if (password.length < 8 || !password.contains(RegExp(r'[A-Z]'))) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Wrong password format!"),
          content: Text(
              "Password must be at least 8 characters long and contain at least one uppercase letter."),
        ),
      );
      return;
    }
    // Kontrola shody hesel
    if (password == confirmPassword) {
      try {
        final userCredential = await authService.signUpWithEmailAndPassword(
          email,
          password,
        );

        // Nastavení role uživatele na "user"
        final uid = userCredential.user?.uid;
        if (uid != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('data')
              .doc('roles')
              .set({'role': 'user'});
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Registration Error"),
            content: Text(e.toString()),
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
  // Vykreslení stránky
  Widget build(BuildContext context) {
    return Theme(
      data: darkMode,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            // Pozadí obrázku
            Opacity(
              opacity: 1,
              child: Image.asset(
                'lib/images/pozadi.jpg',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 75.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Vstupní pole pro e-mail
                    MyTexfield(
                      controller: emailController,
                      hintText: "Email",
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    // Vstupní pole pro heslo
                    MyTexfield(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    // Vstupní pole pro potvrzení hesla
                    MyTexfield(
                      controller: confirmPasswordController,
                      hintText: "Confirm password",
                      obscureText: true,
                    ),
                    const SizedBox(height: 25),
                    // Tlačítko pro registraci
                    MyButton(
                      text: "Sign Up",
                      onTap: register,
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Odkaz na přihlašovací stránku
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Login now",
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
