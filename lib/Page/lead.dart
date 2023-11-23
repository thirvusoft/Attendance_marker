import 'package:attendancemarker/Controller/api.dart';
import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchfield/searchfield.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class LeadPage extends StatefulWidget {
  @override
  State<LeadPage> createState() => _LeadPageState();
}

class _LeadPageState extends State<LeadPage> {
  final _formKey = GlobalKey<FormState>();
  final Search searching = Search();

  final ApiService apiService = ApiService();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobilenoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _sourceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFEA5455),
          title: ListTile(
            title: Text(
              "Lead",
              style: GoogleFonts.sansita(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: _nameController,
                    label: 'Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _mobilenoController,
                    label: 'Mobile No',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile no';
                      }
                      // You can add more sophisticated email validation logic here
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // You can add more sophisticated email validation logic here
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSearchField('Source', 'Please enter Source name',
                      _sourceController, 'Lead Source'),
                  SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Form is valid, handle lead creation logic here
                          print(
                              'Lead created: ${_nameController.text}, ${_emailController.text}');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: Text('Create Lead'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildSearchField(String label, String errorMessage,
      TextEditingController controller, String doctype) {
    return Obx(
      () => SearchField(
        controller: controller,
        searchInputDecoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0x0ff2d2e4))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return errorMessage;
          }

          return null;
        },
        suggestions: searching.searchlist_
            .map((String) => SearchFieldListItem(String))
            .toList(),
        suggestionStyle: TextStyle(fontSize: 16),
        suggestionState: Suggestion.expand,
        suggestionsDecoration: SuggestionDecoration(
            padding: const EdgeInsets.only(top: 10.0, left: 5, bottom: 20),
            color: const Color(0xFFEDEFFE),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        textInputAction: TextInputAction.next,
        marginColor: const Color(0xFFEDEFFE),
        searchStyle: TextStyle(
          fontSize: 17,
          color: Colors.black.withOpacity(0.8),
        ),
        onSearchTextChanged: (p0) {
          searching.searchname(controller.text, doctype);
          return null;
        },
      ),
    );
  }
}
