import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:attendancemarker/Page/lead.dart';
import 'package:attendancemarker/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadHomePage extends StatefulWidget {
  @override
  _LeadHomePageState createState() => _LeadHomePageState();
}

class _LeadHomePageState extends State<LeadHomePage> {
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          decoration: const BoxDecoration(
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
                    Navigator.pop(context);
                  }),
                  _buildSegmentedControlItem(
                      Icons.whatshot, Colors.green, "WhatsApp", () {
                    Navigator.pop(context);

                    _openWhatsApp(lead["mobile_no"]);
                  }),
                  _buildSegmentedControlItem(
                      Icons.edit, Color.fromARGB(255, 31, 3, 3), "Edit", () {
                    Navigator.pop(context);
                    Get.offAllNamed("/leadpage");
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
            padding: const EdgeInsets.all(12.0),
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
          const SizedBox(height: 8.0),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
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

  void _openWhatsApp(String mobileNumber) async {
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
                SizedBox(height: 16.0),
                Column(
                  children: List.generate(messageTemplates.length, (index) {
                    return ListTile(
                      title: Text(messageTemplates[index]),
                      onTap: () {
                        Navigator.pop(context); // Close the dialog
                        _launchWhatsAppWithMessage(
                          mobileNumber,
                          messageTemplates[index],
                        );
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
}
