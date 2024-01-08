import 'dart:convert';
import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/Page/lead.dart';
import 'package:flutter/material.dart';
import 'package:attendancemarker/constant.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
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
            "Follow Up",
            style: GoogleFonts.sansita(fontSize: 20, color: Colors.white),
          ),
        ),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 6,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text((index + 1).toString()),
                ),
                title: Text(
                  'Name: ${items[index]["first_name"]} ',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Company Name: ${items[index]["company_name"]}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      "Mobile No: ${items[index]["mobile_no"]}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: 
           FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LeadPage("","")));
                // Get.offAllNamed("/leadhome");
              },
              tooltip: "Lead Creation",
              child: const Icon(Icons.add),
            )
          );
  }

  void leadlist() async {
    final user = await controller.getUser();
    items = [];
    final response = await apiService.get(
        '/api/method/thirvu__attendance.utils.api.api.leadlist',
        {"user": user[0]['fullname']});
    print("==============================================================");
    print(response.body);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        if (jsonResponse["message"] is List) {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              items = jsonResponse["message"];
            });
          });
        } else {
          throw Exception('Invalid response format: "message" is not a list.');
        }
      });
    }
  }
}
