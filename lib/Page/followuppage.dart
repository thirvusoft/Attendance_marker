import 'package:attendancemarker/widgets/resuable_appbar.dart';
import 'package:attendancemarker/widgets/resuable_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

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
                ? BoxShadow(
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

  // Widget buildSearchField(TextEditingController controller) {
  //   return TextField(
  //     controller: controller,
  //     decoration: const InputDecoration(
  //       labelText: 'Search',
  //       prefixIcon: Icon(Icons.search),
  //       border: OutlineInputBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(50.0)),
  //           borderSide: BorderSide(color: Color(0xFFEA5455))),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //         borderSide:
  //             BorderSide(color: Color(0xFFEA5455)), // Set border color here
  //       ),
  //     ),
  //   );
  // }

  Widget buildListView(List<String> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text(items[index]),
          ),
        );
      },
    );
  }
}
