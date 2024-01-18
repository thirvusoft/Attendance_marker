import 'dart:convert';

import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/Controller/batterycontroller.dart';
import 'package:attendancemarker/Controller/dbhelpercontroller.dart';
import 'package:attendancemarker/Page/call_log.dart';
import 'package:attendancemarker/Page/followuppage.dart';
import 'package:attendancemarker/Page/lead_home.dart';
import 'package:attendancemarker/constant.dart';
import 'package:attendancemarker/widgets/resuable_appbar.dart';
import 'package:attendancemarker/widgets/resubale_popup.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late String dateStr;
  late String nowtime;
  String checkintime = "-";
  String checkouttime = "-";

  late String imgurl = "";
  late String gmail = "";
  bool button = false;
  List temp = [
    {"item_code": "2", "qty": "2"}
  ];
  String fullname = "";
  final PageController bottomcontroller = PageController();
  int currentIndex = 0;

  List pinglocation_ = [];
  final List<Map<String, dynamic>> dataList = [
    {'title': 'Lead', 'image': 'assets/images/lead.png'},
    {'title': 'Follow Up', 'image': 'assets/images/followup.png'},
    {'title': 'CallHistory', 'image': 'assets/images/callhistory.png'},
  ];

  @override
  initState() {
    super.initState();
    DateTime today = DateTime.now();

    dateStr = "${today.day}.${today.month}.${today.year}";
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        title: fullname,
        subtitle: gmail,
        actions: [
          GestureDetector(
            onTap: () {
              showPopup(context);
            },
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white, width: 3.0, style: BorderStyle.solid),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(imgurl.isEmpty
                        ? "https://i.pinimg.com/736x/87/67/64/8767644bc68a14c50addf8cb2de8c59e.jpg"
                        : imgurl)),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBarBubble(
        items: [
          BottomBarItem(
            iconData: Icons.home,
          ),
          BottomBarItem(
            iconData: Icons.person_add_alt,
          ),
        ],
        selectedIndex: currentIndex,
        color: const Color(0xFFEA5455),
        onSelect: (index) {
          // setState(() {
          //   currentIndex = index;
          //   if (currentIndex == 1) {
          //     print("fdfdfdf");
          //   }
          // });
          bottomcontroller.jumpToPage(index);
        },
      ),
      body: PageView(
        controller: bottomcontroller,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3.1,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 0,
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        child: Container(
                          color: const Color(0xFFEA5455),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 15,
                        width: MediaQuery.of(context).size.width / 1.09,
                        height: 225,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("  Today",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: .1))),
                              DataTable(
                                columns: const [
                                  DataColumn(
                                    label: Text('Date',
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                  DataColumn(
                                    label: Text('Check In',
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                  DataColumn(
                                    label: Text('Check Out',
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                                rows: [
                                  DataRow(cells: [
                                    DataCell(Text(
                                      dateStr.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    )),
                                    DataCell(Text(checkintime,
                                        style: const TextStyle(fontSize: 12))),
                                    DataCell(Text(checkouttime,
                                        style: const TextStyle(fontSize: 12))),
                                  ])
                                ],
                                dividerThickness: 0,
                                horizontalMargin: 15.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 50,
                                        child: OutlinedButton(
                                          onPressed: (button)
                                              ? () async {
                                                  final user = await controller
                                                      .getUser();

                                                  final location =
                                                      await locationcontroller
                                                          .getLocation(false);
                                                  print(location);
                                                  print("lo");
                                                  if (location ==
                                                      "Locatuon not enabled") {
                                                    print("lo");
                                                    showLocationServicesDialog();
                                                  }
                                                  // final data = await controller
                                                  //     .deleteAllItems();
                                                  getdata();
                                                  final response =
                                                      await apiService.get(
                                                          "/api/method/thirvu__attendance.utils.api.api.checkin",
                                                          {
                                                        "username": user[0]
                                                            ["fullname"],
                                                        "long": location
                                                            .longitude
                                                            .toString(),
                                                        "lat": location.latitude
                                                            .toString()
                                                      });
                                                  print(response.body);
                                                  if (response.statusCode ==
                                                      200) {
                                                    final Response = json
                                                        .decode(response.body);

                                                    Get.snackbar(
                                                      "Success",
                                                      Response["message"]
                                                          .toString(),
                                                      icon: const HeroIcon(
                                                          HeroIcons.check,
                                                          color: Colors.white),
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF212A1D),
                                                      borderRadius: 20,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              15),
                                                      colorText: Colors.white,
                                                      duration: const Duration(
                                                          seconds: 2),
                                                      isDismissible: true,
                                                      forwardAnimationCurve:
                                                          Curves.easeOutBack,
                                                    );
                                                    DateTime today =
                                                        DateTime.now();
                                                    nowtime =
                                                        "${today.hour}:${today.minute}:${today.second}";
                                                    final userupdate =
                                                        await controller.updateUser(
                                                            user[0]["id"],
                                                            user[0]["image"],
                                                            user[0]["email"],
                                                            jsonDecode(response
                                                                        .body)[
                                                                    'attendance_id']
                                                                .toString(),
                                                            nowtime,
                                                            "-");
                                                    Future.delayed(
                                                        const Duration(
                                                            seconds: 1), () {
                                                      getdata();
                                                    });
                                                  } else {
                                                    final Response = json
                                                        .decode(response.body);

                                                    Get.snackbar(
                                                      "fail",
                                                      Response["message"]
                                                          .toString(),
                                                      icon: const HeroIcon(
                                                          HeroIcons.check,
                                                          color: Colors.white),
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF212A1D),
                                                      borderRadius: 20,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              15),
                                                      colorText: Colors.white,
                                                      duration: const Duration(
                                                          seconds: 2),
                                                      isDismissible: true,
                                                      forwardAnimationCurve:
                                                          Curves.easeOutBack,
                                                    );
                                                  }
                                                }
                                              : () async {
                                                  print(1);
                                                  final user = await controller
                                                      .getUser();
                                                  final response =
                                                      await apiService.get(
                                                          "/api/method/thirvu__attendance.utils.api.api.checkout",
                                                          {
                                                        "username": user[0]
                                                            ["fullname"],
                                                        "attendance": user[0]
                                                            ["attendanceid"],
                                                        "address_list":
                                                            jsonEncode(
                                                                pinglocation_)
                                                      });
                                                  print(response.body);
                                                  print(response.statusCode);
                                                  if (response.statusCode ==
                                                      200) {
                                                    final Response = json
                                                        .decode(response.body);
                                                    Get.snackbar(
                                                      "Success",
                                                      Response["message"]
                                                          .toString(),
                                                      icon: const HeroIcon(
                                                          HeroIcons.check,
                                                          color: Colors.white),
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF212A1D),
                                                      borderRadius: 20,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              15),
                                                      colorText: Colors.white,
                                                      duration: const Duration(
                                                          seconds: 2),
                                                      isDismissible: true,
                                                      forwardAnimationCurve:
                                                          Curves.easeOutBack,
                                                    );
                                                    final data =
                                                        await controller
                                                            .deleteAllItems();
                                                    DateTime today =
                                                        DateTime.now();
                                                    nowtime =
                                                        "${today.hour}:${today.minute}:${today.second}";
                                                    final user =
                                                        await controller
                                                            .getUser();
                                                    final userupdate =
                                                        await controller
                                                            .updateUser(
                                                                user[0]["id"],
                                                                user[0]
                                                                    ["image"],
                                                                user[0]
                                                                    ["email"],
                                                                "",
                                                                user[0]
                                                                    ["checkin"],
                                                                nowtime);

                                                    Future.delayed(
                                                        const Duration(
                                                            seconds: 1), () {
                                                      getdata();
                                                    });
                                                  } else if (response
                                                          .statusCode ==
                                                      417) {
                                                    Get.snackbar(
                                                      "Failed",
                                                      "Duplicate entry detected",
                                                      icon: const HeroIcon(
                                                          HeroIcons.xMark,
                                                          color: Colors.white),
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF212A1D),
                                                      borderRadius: 20,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              15),
                                                      colorText: Colors.white,
                                                      duration: const Duration(
                                                          seconds: 2),
                                                      isDismissible: true,
                                                      forwardAnimationCurve:
                                                          Curves.easeOutBack,
                                                    );
                                                  }
                                                },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor:
                                                const Color(0xFFEA5455),
                                            side: const BorderSide(
                                                color: Color(0xFFEA5455),
                                                width: 2),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    (button)
                                                        ? "Check In"
                                                        : "Check Out",
                                                    style: const TextStyle(
                                                        fontSize: 13)),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                const Icon(Icons.arrow_forward),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                        child: SizedBox(
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: (button)
                                            ? () {}
                                            : () async {
                                                DateTime today = DateTime.now();
                                                dateStr =
                                                    "${today.day}.${today.month}.${today.year}";
                                                final location =
                                                    await locationcontroller
                                                        .getLocation(true);
                                                if (location ==
                                                    "Location not enabled") {
                                                  showLocationServicesDialog();
                                                }
                                                Future.delayed(
                                                    const Duration(seconds: 1),
                                                    () {
                                                  getdata();
                                                });
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFEA5455),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Ping",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255)),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Icon(
                                                PhosphorIcons.map_pin_bold,
                                                color: Color.fromARGB(
                                                    255, 250, 249, 249),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 0.4,
                    height: MediaQuery.of(context).size.height / 2,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("  Pinned Location",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: .1))),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2.2,
                            child: SingleChildScrollView(
                              child: DataTable(
                                dataRowMinHeight: 60.0,
                                dataRowMaxHeight: 65.0,
                                columns: const [
                                  DataColumn(label: Text('')),
                                  DataColumn(
                                      label: Text('Addresss',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              letterSpacing: .1))),
                                  DataColumn(
                                      label: Text('Distance',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              letterSpacing: .1))),
                                ],
                                rows: pinglocation_
                                    .asMap()
                                    .map((index, map) {
                                      return MapEntry(
                                        index,
                                        DataRow(
                                          cells: [
                                            DataCell(SizedBox(
                                              height: 40.0,
                                              width: 40,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color:
                                                      const Color(0xFFEA5455),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      (index + 1).toString(),
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            )),
                                            DataCell(SizedBox(
                                              height: 80.0,
                                              child: Center(
                                                  child: Text(
                                                map['address'] ?? '',
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              )),
                                            )),
                                            DataCell(SizedBox(
                                              height: 40.0,
                                              child: Center(
                                                  child: Text(
                                                      map['distance'] + " Km" ??
                                                          '',
                                                      style: const TextStyle(
                                                          fontSize: 10))),
                                            )),
                                          ],
                                        ),
                                      );
                                    })
                                    .values
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          (dataList.isEmpty)
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  ],
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  padding: const EdgeInsets.only(top: 25.0),
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: 2,
                      child: ScaleAnimation(
                        child: GestureDetector(
                          onTap: () {
                            navigateToScreen(context, dataList[index]['title']);
                          },
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                Hero(
                                  tag: "imageHero${dataList[index]['title']}",
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                    child: Image.asset(
                                      dataList[index]['image'],
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black
                                        ],
                                      ),
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(20)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dataList[index]['title'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }

  void getdata() async {
    final Databasehelper controller = Get.put(Databasehelper());

    final data = await controller.getItems();
    final user = await controller.getUser();

    setState(() {
      pinglocation_ = data;
      checkintime = user[0]['checkin'].toString();
      checkouttime = user[0]['checkout'].toString();

      if (user[0]['attendanceid'].isEmpty) {
        setState(() {
          button = true;
        });
      } else {
        setState(() {
          button = false;
        });
      }

      if (user[0]['image'].contains("files")) {
        imgurl = user[0]['image'].toString();
      }
      fullname = user[0]['fullname'];
      gmail = user[0]['email'];
    });
    final response = await apiService.get(
        "/api/method/thirvu__attendance.utils.api.api.locationtable_updation", {
      "attendance": user[0]["attendanceid"],
      "address_list": jsonEncode(pinglocation_)
    });
    print(response.statusCode);
    print(response.body);
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
                        await controller.deleteAllItems();
                        await controller.getUser();
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

  void showLocationServicesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Services Disabled'),
          content: const Text(
              'Please enable location services to fetch the current location.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFFEA5455)),
              ),
            ),
          ],
        );
      },
    );
  }

  void navigateToScreen(BuildContext context, String title) {
    if (title == 'Lead') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else if (title == 'CallHistory') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LeadManagerScreen()));
    } else if (title == 'Follow Up') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FollowUpPage()));
    } else {
      // Handle other cases as needed
    }
  }
}
