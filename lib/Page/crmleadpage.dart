import 'dart:convert';

import 'package:attendancemarker/Controller/api.dart';
import 'package:attendancemarker/Page/lead.dart';
import 'package:attendancemarker/constant.dart';
import 'package:attendancemarker/widgets/resuable_datefield.dart';
import 'package:attendancemarker/widgets/resuable_textfield.dart';
import 'package:attendancemarker/widgets/reusable_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:searchfield/searchfield.dart';
import 'package:url_launcher/url_launcher.dart';

class CrmLead extends StatefulWidget {
  @override
  State<CrmLead> createState() => _CrmLeadState();
  final String id;
  const CrmLead(this.id);
}

final _formKey = GlobalKey<FormState>();

TextEditingController nextFollowupDateController = TextEditingController();
TextEditingController nextFollowupByController = TextEditingController();
TextEditingController nextFollowDiscriptionController = TextEditingController();
final Search searching = Search();
final LeadFollowup lead = Get.put(LeadFollowup());
String id = '';
String leadName = '';
String leadMobileNo = '';
String emailId = '';
String website = '';
String nextFollowBy = '';
String nextFollowDate = '';
String street = '';
String city = '';
String state = '';
String zipcode = '';

class _CrmLeadState extends State<CrmLead> {
  @override
  void initState() {
    id = widget.id;
    singlelead();
    super.initState();

    searching.searchname("a", "User");
  }

  Future<void> _refreshData() async {
    await singlelead();
  }

  singlelead() async {
    final response = await apiService.get(
        '/api/method/thirvu__attendance.utils.api.api.single_lead',
        {"name": id});
    final jsonResponse = json.decode(response.body);
    if (jsonResponse['message'].isNotEmpty) {
      final leadData = jsonResponse['message'];
      setState(() {
        leadName = leadData['lead_name'] ?? '';
        leadMobileNo = leadData['mobile_no'] ?? '';
        emailId = leadData['email_id'] ?? '';
        website = leadData['website'] ?? '';

        if (leadData['custom_follow_ups'] != null &&
            leadData['custom_follow_ups'].isNotEmpty) {
          final List<dynamic> tableFollowupList =
              leadData['custom_follow_ups'] ?? '';
          final Map<String, dynamic> lastTableFollowupList =
              tableFollowupList.last ?? '';
          nextFollowDate = lastTableFollowupList['next_followup_date'] ?? '';
          nextFollowBy = lastTableFollowupList['next_follow_up_by'] ?? '';
        }
        if (leadData['address_list'] != null &&
            leadData['address_list'].isNotEmpty) {
          final List<dynamic> tableAddress = leadData['address_list'] ?? '';
          final Map<String, dynamic> lastaddress = tableAddress.last ?? '';
          street = lastaddress['address_line1'] ?? '';
          city = lastaddress['city'] ?? '';
          state = lastaddress['state'] ?? '';
          zipcode = lastaddress['pincode'] ?? '';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFEA5455),
          title: const ListTile(
            title: Text(
              "Lead",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.offAllNamed("/leadhome");
            },
          ),
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              await _refreshData();
            },
            child: ListView(
              children: [
                // Lead Card
                Container(
                  height: 170,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xFFEA5455),
                                radius: 20,
                                child: Text(
                                  leadName[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white, // Text color
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      leadName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      leadMobileNo,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                buildOption(
                                    const Color.fromARGB(255, 51, 14, 216),
                                    FontAwesomeIcons.phone,
                                    'Call'),
                                buildOption(Colors.green,
                                    FontAwesomeIcons.whatsapp, 'WhatsApp'),
                                buildOption(Colors.blue,
                                    FontAwesomeIcons.message, 'Message'),
                                buildOption(Colors.red,
                                    FontAwesomeIcons.envelope, 'Email'),
                                buildOption(
                                    const Color.fromARGB(255, 231, 103, 18),
                                    FontAwesomeIcons.calendar,
                                    'Calendar'),
                                buildOption(
                                    const Color.fromARGB(255, 167, 6, 241),
                                    FontAwesomeIcons.locationDot,
                                    'Location'),
                                buildOption(Colors.black, FontAwesomeIcons.edit,
                                    'Edit'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Follow-up Card
                Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        _showDetailsDialog();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ListTile(
                              title: Text(
                                "Follow-up Details",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Icon(Icons.arrow_forward),
                            ),
                            const Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            const TextSpan(
                                              text: 'Next Follow-up By: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 175, 19, 19),
                                                fontSize: 14,
                                              ),
                                            ),
                                            TextSpan(
                                              text: nextFollowBy,
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            const TextSpan(
                                              text: 'Next Follow-up Date: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 175, 19, 19),
                                                fontSize: 14,
                                              ),
                                            ),
                                            TextSpan(
                                              text: nextFollowDate,
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.info_outline,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    _showDetailsDialog();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Address Info Card

                ExpansionTile(
                  title: const Text(
                    "Address Information",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(
                                FontAwesomeIcons.mapLocationDot,
                                color: Color.fromARGB(255, 167, 6, 241),
                              ),
                              title: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "Street: ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16),
                                    ),
                                    TextSpan(
                                      text: street,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                FontAwesomeIcons.city,
                                color: Colors.red,
                              ),
                              title: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "City: ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16),
                                    ),
                                    TextSpan(
                                      text: city,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                FontAwesomeIcons.flag,
                                color: Colors.green,
                              ),
                              title: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "State: ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16),
                                    ),
                                    TextSpan(
                                      text: state,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                FontAwesomeIcons.locationDot,
                                color: Color.fromARGB(255, 51, 14, 216),
                              ),
                              title: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "Zip Code: ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16),
                                    ),
                                    TextSpan(
                                      text: zipcode,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Contact Info Card
                ExpansionTile(
                  title: const Text(
                    "Contact Information",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(
                                FontAwesomeIcons.phone,
                                color: Color.fromARGB(255, 167, 6, 241),
                              ),
                              title: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "Contact No. : ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16),
                                    ),
                                    TextSpan(
                                      text: leadMobileNo,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                FontAwesomeIcons.envelopeCircleCheck,
                                color: Colors.red,
                              ),
                              title: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "Email Id: ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16),
                                    ),
                                    TextSpan(
                                      text: emailId,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                FontAwesomeIcons.globe,
                                color: Colors.blue,
                              ),
                              title: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "Website: ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16),
                                    ),
                                    TextSpan(
                                      text: website,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }

  Widget buildOption(Color color, IconData icon, String option) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: IconButton(
              icon: FaIcon(
                icon,
                color: Colors.white,
              ),
              onPressed: () {
                if (option == 'Call') {
                  _makingPhoneCall(leadMobileNo);
                } else if (option == 'Message') {
                  _openMessageApp();
                } else if (option == 'WhatsApp') {
                  _openWhatsApp(leadMobileNo, option);
                } else if (option == 'Email') {
                  _openWhatsApp(emailId, option);
                } else if (option == 'Calendar') {
                  _openGoogleCalendar();
                } else if (option == 'Location') {
                  _openLocationMap();
                } else if (option == 'Edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeadPage("", "", id),
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 4),
          Text(
            option,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            title: const Text('Next Followup'),
            content: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ResuableDateFormField(
                    controller: nextFollowupDateController,
                    label: 'Next Followup-Date',
                    errorMessage: 'Select the next Followup-date',
                  ),
                  const SizedBox(height: 10),
                  _buildSearchField(
                      'Next Followup By',
                      'Please next followup by',
                      nextFollowupByController,
                      'User',
                      searching.searchuserlist),
                  const SizedBox(height: 10),
                  ReusableTextField(
                    labelText: 'Description',
                    controller: nextFollowDiscriptionController,
                    obscureText: false,
                    keyboardType: TextInputType.multiline,
                    readyonly: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxline: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final user = await controller.getUser();

                    bool leadfollow = await lead.leadFollowup(
                      id,
                      user[0]['email'],
                      nextFollowupDateController.text,
                      nextFollowupByController.text,
                      "Open",
                    );
                    if (leadfollow) {
                      singlelead();
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchField(String label, String errorMessage,
      TextEditingController controller, String doctype, List suggestion) {
    return Obx(
      () {
        return SearchField(
          controller: controller,
          searchInputDecoration: InputDecoration(
            labelText: label,
            isDense: true,
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

  void _makingPhoneCall(String phoneNumber) async {
    var url = 'tel:$phoneNumber';
    try {
      await launch(url);
    } catch (e) {
      print('Error launching phone call: $e');
    }
  }

  void _openWhatsApp(String mobileNumber, String options) async {
    List<String> messageTemplates = [
      'Hello, I want to contact you.',
      'Hi, how can I assist you?',
      'Greetings! Let\'s connect.',
    ];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: const Text(
                    'Select a Message Template',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Column(
                  children: List.generate(messageTemplates.length, (index) {
                    return ListTile(
                      title: Text(messageTemplates[index]),
                      onTap: () {
                        Navigator.pop(context); // Close the dialog
                        if (options == "WhatsApp") {
                          _launchWhatsAppWithMessage(
                            mobileNumber,
                            messageTemplates[index],
                          );
                        } else if (options == "Email") {
                          _sendEmail(
                            mobileNumber,
                            messageTemplates[index],
                          );
                        }
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _launchWhatsAppWithMessage(String mobileNumber, String message) async {
    var encodedMessage = Uri.encodeQueryComponent(message);
    var url = 'https://wa.me/$mobileNumber?text=$encodedMessage';

    try {
      await launch(url);
    } catch (e) {
      print('Error launching WhatsApp: $e');
    }
  }

  void _openMessageApp() {
    // Example: Open the default messaging app with a pre-filled message
    launch("sms:1234567890?body=Hello%20from%20your%20app");
  }

  void _openGoogleCalendar() async {
    final now = DateTime.now();
    final start = now.add(const Duration(days: 1)); // Event starts tomorrow
    final end =
        now.add(const Duration(days: 2)); // Event ends the day after tomorrow

    const calendarEvent = 'New Event';
    const location = 'Event Location';

    final url = 'https://www.google.com/calendar/render'
        '?action=TEMPLATE'
        '&text=${Uri.encodeComponent(calendarEvent)}'
        '&dates=${start.toUtc().toIso8601String()}/${end.toUtc().toIso8601String()}'
        '&details=Event%20description'
        '&location=${Uri.encodeComponent(location)}';

    try {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } catch (e) {
      print('Could not open Google Calendar: $e');
    }
  }

  void _openLocationMap() async {
    const latitude = 37.7749;
    const longitude = -122.4194;

    const url = 'https://www.google.com/maps?q=$latitude,$longitude';

    if (await canLaunch(url)) {
      await launch(url);
    } 
  }

  void _sendEmail(String emailid, String message) async {
    final email = emailid;
    const subject = 'Lead';
    final body = message;

    final url =
        'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

    try {
      await launch(url);
    } catch (e) {
      print('Could not open the email app: $e');
    }
  }
}
