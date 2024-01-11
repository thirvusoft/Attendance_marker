import 'package:attendancemarker/widgets/resuable_appbar.dart';
import 'package:attendancemarker/widgets/resuable_datefield.dart';
import 'package:attendancemarker/widgets/resuable_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../widgets/resuable_textfield.dart';

class FollowUpPage extends StatefulWidget {
  @override
  _FollowUpPageState createState() => _FollowUpPageState();
}

class _FollowUpPageState extends State<FollowUpPage> {
  String activeTab = 'todayFollowUp';
  TextEditingController todaySearchController = TextEditingController();
  TextEditingController missedSearchController = TextEditingController();
  List<String> todayItems = ['Item 1A', 'Item 1B', 'Item 1C'];
  List<String> missedItems = ['Item 2A', 'Item 2B', 'Item 2C'];
  List<String> displayedItems = [];
  TextEditingController nextFollowupDateController = TextEditingController();
  TextEditingController nextFollowupByController = TextEditingController();

  @override
  void initState() {
    super.initState();
    todaySearchController.addListener(() {
      filterSearchResults(todaySearchController.text, todayItems);
    });
    missedSearchController.addListener(() {
      filterSearchResults(missedSearchController.text, missedItems);
    });
    // Initialize with today items
    displayedItems = todayItems;
  }

  @override
  void dispose() {
    todaySearchController.dispose();
    missedSearchController.dispose();
    super.dispose();
  }

  void showListView(String option) {
    setState(() {
      activeTab = option;
      // Reset search when switching tabs
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEA5455),
        title: ListTile(
          title: Text(
            "Follow Up",
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
                        // ? buildSearchField(todaySearchController)
                        ? SearchFieldWidget(controller: todaySearchController)
                        : SearchFieldWidget(
                            controller: missedSearchController)),
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

  Widget buildListView(List<String> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text(items[index]),
            onTap: () {
              _showDetailsDialog(items[index]);
            },
          ),
        );
      },
    );
  }

  void _showDetailsDialog(String itemName) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Next Followup Details $itemName'),
          content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ResuableDateFormField(
                  controller: nextFollowupDateController,
                  label: 'Next Followup-Date',
                  errorMessage: 'select the next Followup-date',
                ),
                const SizedBox(height: 10),
                ReusableTextField(
                  labelText: 'Next Follow-By',
                  controller: nextFollowupByController,
                  obscureText: false,
                  readyonly: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ]),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
