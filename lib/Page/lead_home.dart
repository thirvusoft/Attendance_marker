import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:attendancemarker/Page/lead.dart';
import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allLeads = [];
  List<Map<String, dynamic>> filteredLeads = [];

  TextEditingController searchController = TextEditingController();

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
            Navigator.pop(context);
          },
        ),
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
              decoration: InputDecoration(
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
                      showFeatureBottomSheet(context, filteredLeads[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const LeadPage("", "")),
          );
        },
        tooltip: "Lead Creation",
        child: const Icon(Icons.add),
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

    print("==============================================================");
    print(response.body);

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

  void showFeatureBottomSheet(BuildContext context, Map<String, dynamic> lead) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSegmentedControlItem(Icons.phone, Colors.blue, "Call",
                      () {
                    _makingPhoneCall(lead["mobile_no"]);
                    print(lead['mobile_no'].runtimeType);
                    print('0000000000000000000000000000');
                    Navigator.pop(context);
                  }),
                  _buildSegmentedControlItem(Icons.message, Colors.green, "SMS",
                      () {
                    _sendSMS(lead["mobile_no"]);
                    Navigator.pop(context);
                  }),
                  _buildSegmentedControlItem(
                      Icons.whatshot, Colors.green, "WhatsApp", () {
                    _openWhatsApp(lead["mobile_no"]);
                    Navigator.pop(context);
                  }),
                  _buildSegmentedControlItem(
                      Icons.edit, Color.fromARGB(255, 31, 3, 3), "Edit", () {
                    _openWhatsApp(lead["mobile_no"]);
                    Navigator.pop(context);
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSegmentedControlItem(
      IconData icon, Color color, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(
              icon,
              size: 30.0,
              color: color,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  void _makingPhoneCall(String mobileNumber) async {
    final phoneCallUrl = 'tel:$mobileNumber';
    try {
      if (await canLaunch(phoneCallUrl)) {
        await launch(phoneCallUrl);
      } else {
        throw 'Could not launch $phoneCallUrl';
      }
    } catch (e) {
      // Handle error
      print('Error making phone call: $e');
    }
  }

  void _sendSMS(String mobileNumber) async {
    final smsUrl = 'sms:$mobileNumber';
    if (await canLaunch(smsUrl)) {
      await launch(smsUrl);
    } else {
      print('Could not launch $smsUrl');
    }
  }

  void _openWhatsApp(String mobileNumber) async {
    final whatsappUrl = 'https://wa.me/$mobileNumber';
    try {
      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        throw 'Could not launch $whatsappUrl';
      }
    } catch (e) {
      // Handle error
      print('Error launching WhatsApp: $e');
    }
  }
}
