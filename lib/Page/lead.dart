import 'dart:convert';

import 'package:attendancemarker/Controller/api.dart';
import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/constant.dart';
import 'package:attendancemarker/widgets/resuable_datefield.dart';
import 'package:attendancemarker/widgets/resuable_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchfield/searchfield.dart';

class LeadPage extends StatefulWidget {
  @override
  State<LeadPage> createState() => _LeadPageState();
  final String? initialName;
  final String? initialPhoneNumber;
  final String id;

  const LeadPage(this.initialName, this.initialPhoneNumber, this.id);
}

class _LeadPageState extends State<LeadPage> {
  // final _formKey = GlobalKey<FormState>();
  final Search searching = Search();
  TextEditingController nameController = TextEditingController();
  TextEditingController organizationController = TextEditingController();
  TextEditingController mobilenoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController industryController = TextEditingController();
  TextEditingController territoryController = TextEditingController();
  TextEditingController followUpDateController = TextEditingController();
  TextEditingController followUpByController = TextEditingController();
  TextEditingController followDiscription = TextEditingController();
  int currentStep = 0;
  bool _isLoading = false;
  String id = '';

  final ApiService apiService = ApiService();
  final LeadCreation lead = Get.put(LeadCreation());
  List<GlobalKey<FormState>> _formKeys = List.generate(
    3,
    (index) => GlobalKey<FormState>(),
  );

  @override
  void initState() {
    id = widget.id;

    super.initState();

    singlelead();
    searching.searchname("a", "User");
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
              Get.offAllNamed("/leadhome");
            },
          ),
        ),
        body: Form(
          child: Stepper(
            type: StepperType.vertical,
            currentStep: currentStep,
            connectorColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              return const Color(0xFFEA5455);
            }),
            steps: [
              _buildStep(
                  title: 'Personal Information',
                  fields: [
                    Form(
                      key: _formKeys[0],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          ReusableTextField(
                            labelText: 'Name',
                            controller: nameController,
                            obscureText: false,
                            readyonly: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            maxline: 3,
                          ),
                          const SizedBox(height: 10),
                          ReusableTextField(
                            labelText: 'Mobile No',
                            controller: mobilenoController,
                            obscureText: false,
                            readyonly: false,
                            keyboardType: TextInputType.phone,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            maxLength: 10,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Mobile no';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          ReusableTextField(
                            labelText: 'Email',
                            controller: emailController,
                            obscureText: false,
                            readyonly: false,
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                          ),
                        ],
                      ),
                    ),
                  ],
                  isCompleted: currentStep > 0),
              _buildStep(
                title: 'Organization Information',
                fields: [
                  Form(
                      key: _formKeys[1],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          ReusableTextField(
                            labelText: 'Organization Name',
                            controller: organizationController,
                            obscureText: false,
                            readyonly: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 10),
                          _buildSearchField('Source', sourceController,
                              'Lead Source', searching.searchlist_),
                          const SizedBox(height: 10),
                          _buildSearchField('Industry Type', industryController,
                              'Industry Type', searching.searchlistindustry_),
                          const SizedBox(height: 10),
                          _buildSearchField('Territory', territoryController,
                              'Territory', searching.searchlistterritory_),
                        ],
                      ))
                ],
                isCompleted: currentStep > 1,
              ),
              _buildStep(
                  title: 'Follow-up Information',
                  fields: [
                    Form(
                      key: _formKeys[2],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          ResuableDateFormField(
                            controller: followUpDateController,
                            label: 'Next Followup-Date',
                            errorMessage: 'Select the next Followup-date',
                          ),
                          const SizedBox(height: 10),
                          _buildSearchField(
                              'Next Follow-up By',
                              followUpByController,
                              'user',
                              searching.searchuserlist),
                          const SizedBox(height: 10),
                          ReusableTextField(
                            labelText: 'Description',
                            controller: followDiscription,
                            obscureText: false,
                            keyboardType: TextInputType.multiline,
                            readyonly: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            maxline: 5,
                          ),
                        ],
                      ),
                    )
                  ],
                  isCompleted: currentStep > 2),
            ],
            controlsBuilder: (
              BuildContext context,
              ControlsDetails controlsDetails,
            ) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (currentStep > 0)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentStep--;
                          });
                        },
                        child: Text('Back'),
                      ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKeys[currentStep].currentState?.validate() ??
                            false) {
                          if (currentStep == 2) {
                            setState(() {
                              _isLoading = true;
                            });
                            bool leadCreated = await lead.leadCreation(
                                id,
                                "Lead",
                                nameController.text,
                                organizationController.text,
                                mobilenoController.text,
                                emailController.text,
                                sourceController.text,
                                industryController.text,
                                territoryController.text,
                                followUpDateController.text,
                                followUpByController.text,
                                followDiscription.text);
                            setState(() {
                              _isLoading = false;
                            });

                            if (leadCreated) {
                              Get.offAllNamed("/leadhome");
                            }
                          } else {
                            setState(() {
                              currentStep++;
                            });
                          }
                        }
                      },
                      child: Text(
                        currentStep == 2 ? 'Submit' : 'Next',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  Step _buildStep(
      {required String title,
      required List<Widget> fields,
      required bool isCompleted}) {
    return Step(
      title: Text(title),
      state: isCompleted ? StepState.complete : StepState.indexed,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: fields,
      ),
    );
  }

  Widget _buildSearchField(String label, TextEditingController controller,
      String doctype, List suggestion) {
    return SearchField(
      controller: controller,
      searchInputDecoration: InputDecoration(
        isDense: true,
        counterText: "",
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x0ff2d2e4))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
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
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      textInputAction: TextInputAction.next,
      marginColor: const Color(0xFFEDEFFE),
      searchStyle: TextStyle(
        fontSize: 17,
        color: Colors.black.withOpacity(0.8),
      ),
      onSearchTextChanged: (p0) {
        searching.searchname(controller.text, doctype);
      },
    );
  }

  singlelead() async {
    final response = await apiService.get(
        '/api/method/thirvu__attendance.utils.api.api.single_lead',
        {"name": id});
    final jsonResponse = json.decode(response.body);
    print(id);
    if (jsonResponse['message'].isNotEmpty) {
      final leadData = jsonResponse['message'];
      nameController.text = leadData['lead_name'] ?? '';
      organizationController.text = leadData['company_name'] ?? '';
      mobilenoController.text = leadData['mobile_no'] ?? '';
      emailController.text = leadData['email_id'] ?? '';

      if (leadData['custom_follow_ups'] != null &&
          leadData['custom_follow_ups'].isNotEmpty) {
        final List<dynamic> tableFollowupList =
            leadData['custom_follow_ups'] ?? '';
        final Map<String, dynamic> lastTableFollowupList =
            tableFollowupList.last ?? '';
        followUpDateController.text =
            lastTableFollowupList['next_followup_date'] ?? '';
        followUpByController.text =
            lastTableFollowupList['next_follow_up_by'] ?? '';
        followDiscription.text = lastTableFollowupList['description'] ?? '';
      }
      setState(() {
        print(leadData['industry']);
        sourceController.text = leadData['source'] ?? '';
        industryController.text = leadData['industry'] ?? '';
        territoryController.text = leadData['territory'] ?? '';
      });
    }
  }
}
