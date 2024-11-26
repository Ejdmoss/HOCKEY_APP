import 'package:flutter/material.dart';

class MyTexfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTexfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true, // Added filled property
          fillColor: Theme.of(context).colorScheme.secondary.withOpacity(0.8), // Added background color
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary, width: 2.0)),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.8), width: 2.0),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.7)),
        ),
      ),
    );
  }
}
