import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String buttonText;
  final void Function()? onPressed;
  const Button({super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
