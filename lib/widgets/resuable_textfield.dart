import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class ReusableTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final HeroIcons? suffixIcon;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChange;
  final bool readyonly;
  final AutovalidateMode autovalidateMode;
  const ReusableTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLength,
    this.validator,
    this.onChange,
    required this.readyonly,
    required this.autovalidateMode,
  });

  @override
  State<ReusableTextField> createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readyonly,
      controller: widget.controller,
      autovalidateMode: widget.autovalidateMode,
      keyboardType: widget.keyboardType,
      obscureText:
          (widget.obscureText != true) ? widget.obscureText : _obscureText,
      validator: widget.validator,
      maxLength: widget.maxLength,
      onChanged: (text) {
        if (widget.onChange != null) {
          widget.onChange!(text);
        }
      },
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black)),
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x0ff2d2e4))),
        suffixIcon: (widget.obscureText != true)
            ? HeroIcon(widget.suffixIcon as HeroIcons)
            : IconButton(
                icon: HeroIcon(
                  _obscureText ? HeroIcons.lockClosed : HeroIcons.lockOpen,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
      ),
    );
  }
}
