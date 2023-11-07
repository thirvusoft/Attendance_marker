import 'package:flutter/material.dart';

class CustomFormButton extends StatelessWidget {
  final String innerText;
  final Color backgroundColor;
  final void Function()? onPressed;
  const CustomFormButton({
    Key? key,
    required this.innerText,
    required this.onPressed,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      height: size.height / 14,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          innerText,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
