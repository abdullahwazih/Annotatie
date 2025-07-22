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
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10.0),
          ),
          fillColor: Colors.white,
          filled: false,
          labelText: hintText,
          labelStyle: const TextStyle(
            color: Colors.white,
          ), // Set hint text color to white
        ),
      ),
    );
  }
}
