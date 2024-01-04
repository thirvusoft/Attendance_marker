import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ReusableButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
