import 'dart:convert';

import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/Controller/dbhelpercontroller.dart';
import 'package:attendancemarker/widgets/resubale_popup.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

class Loglist extends StatefulWidget {
  const Loglist({super.key});

  @override
  State<Loglist> createState() => _LoglistState();
}

class _LoglistState extends State<Loglist> with TickerProviderStateMixin {
  late final TabController _tabController;
  final Databasehelper controller = Get.put(Databasehelper());
  final ApiService apiService = ApiService();

  String fullname = "";
  late String imgurl = "";
  late String gmail = "";
  List log = [];
  List nolog_ = [];
  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEA5455),
        title: ListTile(
          title: Text(
            "Hi  $fullname !",
            style: GoogleFonts.sansita(fontSize: 20, color: Colors.white),
          ),
          subtitle: Text(
            gmail,
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                Get.toNamed("/mappage");
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: HeroIcon(HeroIcons.mapPin, color: Colors.white),
              )),
          GestureDetector(
            onTap: () {
              showPopup(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white,
                      width: 3.0,
                      style: BorderStyle.solid),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(imgurl)),
                ),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          onTap: (index) {
            getdata();
          },
          tabs: const <Widget>[
            Tab(
              text: 'Loged',
              icon: Icon(PhosphorIcons.fingerprint_simple),
            ),
            Tab(
              text: 'Not Loged',
              icon: Icon(PhosphorIcons.prohibit),
            ),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 2, 4),
          child: (log.isEmpty)
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                )
              : RefreshIndicator(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: log.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: Text((index + 1).toString()),
                          title: Text(log[index]["employee_name"].trim()),
                          trailing: Text("Status: ${log[index]["log_type"]}"),
                          subtitle: Text("Time: ${log[index]["time"]}"),
                        ),
                      );
                    },
                  ),
                  onRefresh: () {
                    return Future.delayed(const Duration(seconds: 1), () {
                      getdata();
                    });
                  }),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 2, 4),
          child: RefreshIndicator(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: nolog_.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: Text((index + 1).toString()),
                      title: Text(nolog_[index]),
                    ),
                  );
                },
              ),
              onRefresh: () {
                return Future.delayed(const Duration(seconds: 1), () {
                  getdata();
                });
              }),
        ),
      ]),
    );
  }

  void showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupWidget(
          title: 'Logout',
          content:
              '    Do you want to log out from \n             Attendance marker?',
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                      child: const Text(
                        'Cancel',
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFFEA5455)),
                      ),
                      onPressed: () {
                        Get.back();
                      }),
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                    child: const Text(
                      'Yes, Logout',
                      style: TextStyle(fontSize: 15, color: Color(0xFFEA5455)),
                    ),
                    onPressed: () async {
                      final response =
                          await apiService.get("/api/method/logout", {});

                      if (response.statusCode == 200) {
                        final data = await controller.deleteAllItems();
                        final userlist = await controller.getUser();

                        // controller.deleteItem(location.length - 1);

                        Get.offAllNamed("/loginpage");
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void getdata() async {
    final Databasehelper controller = Get.put(Databasehelper());
    final user = await controller.getUser();
    final checkinstatus = await apiService
        .get("/api/method/thirvu__attendance.utils.api.api.loglist", {});
    final nolog = await apiService
        .get("/api/method/thirvu__attendance.utils.api.api.nolog", {});

    setState(() {
      if (user[0]['image'] != null) {
        imgurl = user[0]['image'].toString();
      } else {
        imgurl =
            "https://i.pinimg.com/736x/87/67/64/8767644bc68a14c50addf8cb2de8c59e.jpg";
      }
      print(
          "**********************************************************************************************************************************88");
      print(imgurl);
      fullname = user[0]['fullname'];
      gmail = user[0]['email'];
      if (checkinstatus.statusCode == 200) {
        final responsedata = json.decode(checkinstatus.body);
        log = responsedata["message"];
      }
      if (nolog.statusCode == 200) {
        final responsedata = json.decode(nolog.body);
        nolog_ = responsedata["message"];
      }
    });
  }
}
