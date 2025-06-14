import 'package:flutter/material.dart';

class CustomTexfield extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obsecureText;
  const CustomTexfield({
    super.key,
    required this.hintText,
    required this.controller,
    required this.obsecureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextField(
        obscureText: obsecureText,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          fillColor: Theme.of(context).colorScheme.secondary,

          filled: false,
          hintText: hintText,
        ),
      ),
    );
  }
}
