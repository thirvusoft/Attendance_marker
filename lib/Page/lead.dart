import 'package:attendancemarker/Controller/api.dart';
import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/widgets/resuable_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchfield/searchfield.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class LeadPage extends StatefulWidget {
  @override
  State<LeadPage> createState() => _LeadPageState();
  final String? initialName;
  final String? initialPhoneNumber;

  const LeadPage(this.initialName, this.initialPhoneNumber);
}

class _LeadPageState extends State<LeadPage> {
  final _formKey = GlobalKey<FormState>();
  final Search searching = Search();
  final LeadCreation lead = Get.put(LeadCreation());
  final ApiService apiService = ApiService();
  TextEditingController nameController = TextEditingController();
  TextEditingController organizationController = TextEditingController();
  TextEditingController mobilenoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController industryController = TextEditingController();
  TextEditingController territoryController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    searching.searchname("a", "Lead Source");
    searching.searchname("a", "Industry Type");
    searching.searchname("a", "Territory");
    nameController.text = widget.initialName ?? '';
    mobilenoController.text = widget.initialPhoneNumber ?? '';
  }

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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.offAllNamed("/homepage");
            },
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
                  ReusableTextField(
                    labelText: 'Name',
                    controller: nameController,
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    readyonly: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  ReusableTextField(
                    labelText: 'Organization Name',
                    controller: organizationController,
                    obscureText: false,
                    readyonly: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  ReusableTextField(
                    labelText: 'Mobile No',
                    controller: mobilenoController,
                    inputFormatters: FilteringTextInputFormatter.digitsOnly,
                    obscureText: false,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    readyonly: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile no';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ReusableTextField(
                    readyonly: false,
                    controller: emailController,
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        final RegExp emailRegExp = RegExp(
                            r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                        if (!emailRegExp.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  _buildSearchField('Source', 'Please enter Source name',
                      sourceController, 'Lead Source', searching.searchlist_),
                  const SizedBox(height: 16),
                  _buildSearchField(
                      'Industry Type',
                      'Please enter industry type',
                      industryController,
                      'Industry Type',
                      searching.searchlistindustry_),
                  const SizedBox(height: 16),
                  _buildSearchField(
                      'Territory',
                      'Please enter territory',
                      territoryController,
                      'Territory',
                      searching.searchlistterritory_),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          bool leadCreated = await lead.leadCreation(
                              "Lead",
                              nameController.text,
                              organizationController.text,
                              mobilenoController.text,
                              emailController.text,
                              sourceController.text,
                              industryController.text,
                              territoryController.text);
                          setState(() {
                            _isLoading = false;
                          });
                          if (leadCreated) {
                            Get.offAllNamed("/homepage");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Create Lead'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildSearchField(String label, String errorMessage,
      TextEditingController controller, String doctype, List suggestion) {
    return Obx(
      () {
        return SearchField(
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
          suggestions:
              suggestion.map((String) => SearchFieldListItem(String)).toList(),
          suggestionStyle: const TextStyle(fontSize: 16),
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
        );
      },
    );
  }
}
