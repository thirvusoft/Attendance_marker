import 'dart:convert';

import 'package:attendancemarker/Controller/api.dart';
import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/Page/crmleadpage.dart';
import 'package:attendancemarker/widgets/resuable_datefield.dart';
import 'package:attendancemarker/widgets/resuable_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchfield/searchfield.dart';
import 'package:geolocator/geolocator.dart';

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
  TextEditingController websiteController = TextEditingController();

  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  int currentStep = 0;
  bool _isLoading = false;
  String id = '';

  final ApiService apiService = ApiService();
  final LeadCreation lead = Get.put(LeadCreation());
  final List<GlobalKey<FormState>> _formKeys = List.generate(
    4,
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
            onStepTapped: (value) {
              if (_formKeys[currentStep].currentState?.validate() ?? false) {
                setState(() {
                  currentStep = value;
                });
              }
            },
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
                title: 'Address Information',
                fields: [
                  Form(
                    key: _formKeys[1],
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                Position position =
                                    await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.high,
                                );

                                try {
                                  List<Placemark> placemarks =
                                      await placemarkFromCoordinates(
                                    position.latitude,
                                    position.longitude,
                                  );
                                  String street = '';
                                  if (placemarks.isNotEmpty) {
                                    Placemark currentPlace = placemarks[0];
                                    street =
                                        '${currentPlace.street ?? ''}, ${currentPlace.thoroughfare ?? ''}';
                                  }
                                  setState(() {
                                    streetController.text = street;
                                    cityController.text = placemarks.isNotEmpty
                                        ? placemarks[0].locality ?? ''
                                        : '';
                                    stateController.text = placemarks.isNotEmpty
                                        ? placemarks[0].administrativeArea ?? ''
                                        : '';
                                    zipCodeController.text =
                                        placemarks.isNotEmpty
                                            ? placemarks[0].postalCode ?? ''
                                            : '';
                                  });
                                } catch (e) {
                                  print('Error retrieving address: $e');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEA5455),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.locationDot,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  Text(
                                    'Get Current Address',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ReusableTextField(
                          labelText: 'Street',
                          controller: streetController,
                          obscureText: false,
                          readyonly: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(height: 10),
                        ReusableTextField(
                          labelText: 'City',
                          controller: cityController,
                          obscureText: false,
                          readyonly: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(height: 10),
                        ReusableTextField(
                          labelText: 'State',
                          controller: stateController,
                          obscureText: false,
                          readyonly: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(height: 10),
                        ReusableTextField(
                          labelText: 'Zip Code',
                          controller: zipCodeController,
                          obscureText: false,
                          readyonly: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
                isCompleted: currentStep > 1,
              ),
              _buildStep(
                title: 'Organization Information',
                fields: [
                  Form(
                      key: _formKeys[2],
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
                          ReusableTextField(
                            labelText: 'Website Name',
                            controller: websiteController,
                            obscureText: false,
                            readyonly: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 10),
                          _buildSearchField('Territory', territoryController,
                              'Territory', searching.searchlistterritory_),
                        ],
                      ))
                ],
                isCompleted: currentStep > 2,
              ),
              _buildStep(
                  title: 'Follow-up Information',
                  fields: [
                    Form(
                      key: _formKeys[3],
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
                  isCompleted: currentStep > 3),
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
                          if (currentStep == 3) {
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
                                followDiscription.text,
                                streetController.text,
                                cityController.text,
                                stateController.text,
                                zipCodeController.text,
                                websiteController.text);
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
                        currentStep == 3 ? 'Submit' : 'Next',
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
    if (jsonResponse['message'].isNotEmpty) {
      final leadData = jsonResponse['message'];
      nameController.text = leadData['lead_name'] ?? '';
      organizationController.text = leadData['company_name'] ?? '';
      mobilenoController.text = leadData['mobile_no'] ?? '';
      emailController.text = leadData['email_id'] ?? '';
      websiteController.text = leadData['website'] ?? '';

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

      if (leadData['address_list'] != null &&
          leadData['address_list'].isNotEmpty) {
        final List<dynamic> tableAddress = leadData['address_list'] ?? '';
        final Map<String, dynamic> lastaddress = tableAddress.last ?? '';
        streetController.text = lastaddress['address_line1'] ?? '';
        cityController.text = lastaddress['city'] ?? '';
        stateController.text = lastaddress['state'] ?? '';
        zipCodeController.text = lastaddress['pincode'] ?? '';
      }
      setState(() {
        sourceController.text = leadData['source'] ?? '';
        industryController.text = leadData['industry'] ?? '';
        territoryController.text = leadData['territory'] ?? '';
      });
    }
  }
}
