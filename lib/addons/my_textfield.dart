import 'package:flutter/material.dart';

// vytvoření vlastního textového pole
class MyTexfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  // konstruktor textového pole
  const MyTexfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  // vytvoření textového pole
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          // barva pozadí
          fillColor: Theme.of(context).colorScheme.surface,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.surface, width: 2.0)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.surface, width: 2.0),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .inversePrimary
                  .withOpacity(0.7)),
        ),
      ),
    );
  }
}
