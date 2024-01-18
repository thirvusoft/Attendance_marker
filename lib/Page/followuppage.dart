import 'dart:convert';

import 'package:attendancemarker/Controller/api.dart';
import 'package:flutter/material.dart';
import 'package:attendancemarker/widgets/resuable_datefield.dart';
import 'package:attendancemarker/widgets/resuable_searchbar.dart';
import 'package:attendancemarker/widgets/resuable_textfield.dart';
import 'package:attendancemarker/constant.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:searchfield/searchfield.dart';
import 'package:url_launcher/url_launcher.dart';

class FollowUpPage extends StatefulWidget {
  @override
  _FollowUpPageState createState() => _FollowUpPageState();
}

class _FollowUpPageState extends State<FollowUpPage> {
  String activeTab = 'todayFollowUp';
  TextEditingController todaySearchController = TextEditingController();
  TextEditingController missedSearchController = TextEditingController();
  List<String> todayItems = [];
  List<String> missedItems = [];
  List<String> displayedItems = [];
  List<String> filteredTodayItems = [];
  final Search searching = Search();
  final _formKey = GlobalKey<FormState>();

  TextEditingController nextFollowupDateController = TextEditingController();
  TextEditingController nextFollowupByController = TextEditingController();
  TextEditingController nextFollowDiscriptionController =
      TextEditingController();
  final LeadFollowup lead = Get.put(LeadFollowup());

  @override
  void initState() {
    super.initState();
    todayfollup();
    missedFollowup();
    searching.searchname("a", "User");

    todaySearchController.addListener(() {
      filterSearchResults(todaySearchController.text, todayItems);
    });
    missedSearchController.addListener(() {
      filterSearchResults(missedSearchController.text, missedItems);
    });
    displayedItems = todayItems;
    filteredTodayItems = todayItems;
  }

  void showListView(String option) {
    setState(() {
      activeTab = option;
      todaySearchController.clear();
      missedSearchController.clear();
      filterSearchResults(
          '', option == 'todayFollowUp' ? todayItems : missedItems);
    });
  }

  void filterSearchResults(String query, List<String> items) {
    setState(() {
      displayedItems = items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();

      if (activeTab == 'todayFollowUp') {
        filteredTodayItems = todayItems
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else if (activeTab == 'missedFollowUp') {
        filteredTodayItems = missedItems
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Widget buildListView(List<String> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        // Split the formatted string to extract details
        List<String> details = items[index].split(' - ');

        return Card(
          margin: EdgeInsets.all(10),
          elevation: 5,
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            title: Text(
              "Name: ${details[0]}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  'Company: ${details[1]}',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  'Mobile: ${details[2]}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.phone),
              onPressed: () {
                _makingPhoneCall(details[2]);
              },
            ),
            onTap: () {
              _showDetailsDialog(details[3]);
            },
          ),
        );
      },
    );
  }

  void _makingPhoneCall(String phoneNumber) async {
    var url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showDetailsDialog(leadname) async {
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
                      leadname,
                      user[0]['email'],
                      nextFollowupDateController.text,
                      nextFollowupByController.text,
                      "Open",
                    );
                    if (leadfollow) {
                      Get.offAllNamed("/homepage");
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

  void todayfollup() async {
    try {
      final user = await controller.getUser();
      final response = await apiService.get(
        '/api/method/thirvu__attendance.utils.api.api.today_followups',
        {"next_follow_up": user[0]['email']},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse["message"] is List) {
          List<String> extractedValues = (jsonResponse["message"] as List)
              .map((item) =>
                  "${item['first_name']} - ${item['company_name']} - ${item['mobile_no']} - ${item['name']}")
              .toList();

          setState(() {
            todayItems = extractedValues;
            displayedItems = todayItems;
            filteredTodayItems = todayItems;
          });
        } else {
          throw Exception('Invalid response format: "message" is not a list.');
        }
      }
    } catch (e) {
      print('Error: $e');
      // Handle the error appropriately
    }
  }

  void missedFollowup() async {
    try {
      final user = await controller.getUser();
      final response = await apiService.get(
        '/api/method/thirvu__attendance.utils.api.api.missed_followups',
        {"next_follow_up": user[0]['email']},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse["message"] is List) {
          List<String> extractedValues = (jsonResponse["message"] as List)
              .map((item) =>
                  "${item['first_name']} - ${item['company_name']} - ${item['mobile_no']} - ${item['name']}")
              .toList();

          setState(() {
            missedItems = extractedValues;
          });
        } else {
          throw Exception('Invalid response format: "message" is not a list.');
        }
      }
    } catch (e) {
      print('Error: $e');
      // Handle the error appropriately
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEA5455),
        title: const ListTile(
          title: Text(
            "Follow Up",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[200],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTab('Today Follow Up', 'todayFollowUp'),
                    buildTab('Missed Follow Up', 'missedFollowUp'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: activeTab == 'todayFollowUp'
                      ? SearchFieldWidget(controller: todaySearchController)
                      : SearchFieldWidget(
                          controller: missedSearchController,
                        ),
                ),
              ],
            ),
          ),
          Expanded(
            child: buildListView(displayedItems),
          ),
        ],
      ),
    );
  }

  Widget buildTab(String label, String option) {
    return GestureDetector(
      onTap: () => showListView(option),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color:
              activeTab == option ? const Color(0xFFEA5455) : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            activeTab == option
                ? const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  )
                : BoxShadow(color: Colors.transparent),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: activeTab == option ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
