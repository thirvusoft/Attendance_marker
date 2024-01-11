import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResuableDateFormField extends StatelessWidget {
  final String label;
  final String errorMessage;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(DateTime)? onDateSelected;

  ResuableDateFormField({
    required this.label,
    required this.errorMessage,
    required this.controller,
    this.validator,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.always,
      decoration: _buildInputDecorationWithIcon(label),
      validator: validator,
      readOnly: true,
      onTap: () async {
        DateTime? selectedDate = DateTime.now();
        FocusScope.of(context).requestFocus(FocusNode());

        selectedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (selectedDate != null) {
          controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
          onDateSelected?.call(selectedDate); // Callback function
        }
      },
    );
  }

  InputDecoration _buildInputDecorationWithIcon(String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      border: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 119, 133, 56)),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      suffixIcon: const Icon(Icons.calendar_today),
    );
  }
}
