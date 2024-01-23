import 'dart:convert';
import 'package:attendancemarker/Page/crmleadpage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:attendancemarker/Page/lead.dart';
import 'package:attendancemarker/constant.dart';

class LeadHomePage extends StatefulWidget {
  @override
  _LeadHomePageState createState() => _LeadHomePageState();
}

class _LeadHomePageState extends State<LeadHomePage> {
  List<Map<String, dynamic>> allLeads = [];
  List<Map<String, dynamic>> filteredLeads = [];
  TextEditingController searchController = TextEditingController();
  String leadId = '';
  @override
  void initState() {
    super.initState();
    leadlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.offAllNamed("/homepage");
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: IconButton(
              icon: const Icon(FontAwesomeIcons.userPen, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const LeadPage("", "", '')),
                );
              },
            ),
          ),
        ],
        backgroundColor: Color(0xFFEA5455),
        title: ListTile(
          title: Text(
            "Lead List",
            style: GoogleFonts.sansita(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Search by name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
              onChanged: (value) {
                filterSearchResults(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredLeads.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 6,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text((index + 1).toString()),
                    ),
                    title: Text(
                      'Name: ${filteredLeads[index]["first_name"]} ',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Company Name: ${filteredLeads[index]["company_name"]}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          "Mobile No: ${filteredLeads[index]["mobile_no"]}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CrmLead(filteredLeads[index]["name"]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void leadlist() async {
    final user = await controller.getUser();
    allLeads = [];

    final response = await apiService.get(
      '/api/method/thirvu__attendance.utils.api.api.leadlist',
      {"user": user[0]['fullname']},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse["message"] is List) {
        setState(() {
          allLeads = List<Map<String, dynamic>>.from(jsonResponse["message"]);
          filteredLeads = List.from(allLeads);
        });
      } else {
        throw Exception('Invalid response format: "message" is not a list.');
      }
    }
  }

  void filterSearchResults(String query) {
    List<Map<String, dynamic>> searchResults = [];

    if (query.isNotEmpty) {
      searchResults = allLeads.where((item) {
        String name = item["first_name"].toLowerCase();
        String companyName = item["company_name"].toLowerCase();
        String mobileNumber = item["mobile_no"].toLowerCase();

        return name.contains(query.toLowerCase()) ||
            companyName.contains(query.toLowerCase()) ||
            mobileNumber.contains(query.toLowerCase());
      }).toList();
    } else {
      searchResults = List.from(allLeads);
    }

    setState(() {
      filteredLeads = searchResults;
    });
  }
}
