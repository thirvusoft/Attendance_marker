import 'package:flutter/material.dart';

class ReusableTextFieldNew extends StatelessWidget {
  final bool? isPasswordVisible;
  final VoidCallback? onTogglePasswordVisibility;
  final String label;
  final Icon? iconValue;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLength;
  final ValueSetter<String>? onChanged; // Added onChanged callback

  const ReusableTextFieldNew({
    this.isPasswordVisible,
    this.onTogglePasswordVisibility,
    required this.label,
    this.iconValue,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.maxLength,
    this.onChanged, // Added onChanged callback
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPasswordVisible ?? false,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLength: maxLength,
      onChanged: onChanged, // Added onChanged callback
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: iconValue,
        suffixIcon: onTogglePasswordVisibility != null
            ? InkWell(
                onTap: onTogglePasswordVisibility,
                child: Icon(
                  isPasswordVisible ?? false
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: validator != null
                ? Colors.grey
                : Theme.of(context).primaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).errorColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
