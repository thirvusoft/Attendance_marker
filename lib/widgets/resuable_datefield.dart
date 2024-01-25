import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResuableDateFormField extends StatelessWidget {
  final String label;
  final String errorMessage;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(DateTime)? onDateTimeSelected;

  ResuableDateFormField({
    required this.label,
    required this.errorMessage,
    required this.controller,
    this.validator,
    this.onDateTimeSelected,
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
        DateTime? selectedDateTime = DateTime.now();
        FocusScope.of(context).requestFocus(FocusNode());

        selectedDateTime = await showDatePicker(
          context: context,
          initialDate: selectedDateTime,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (selectedDateTime != null) {
          TimeOfDay? selectedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(selectedDateTime),
          );

          if (selectedTime != null) {
            selectedDateTime = DateTime(
              selectedDateTime.year,
              selectedDateTime.month,
              selectedDateTime.day,
              selectedTime.hour,
              selectedTime.minute,
            );

            controller.text =
                DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
            onDateTimeSelected?.call(selectedDateTime); // Callback function
          }
        }
      },
    );
  }

  InputDecoration _buildInputDecorationWithIcon(String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      counterText: "",
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
