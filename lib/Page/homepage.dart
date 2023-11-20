import 'dart:convert';

import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/Controller/batterycontroller.dart';
import 'package:attendancemarker/Controller/dbhelpercontroller.dart';
import 'package:attendancemarker/constant.dart';
import 'package:attendancemarker/widgets/resuable_appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late String dateStr;
  final ApiService apiService = ApiService();
  final Databasehelper controller = Get.put(Databasehelper());
  final Batteryprecntage locationcontroller = Get.put(Batteryprecntage());
  late String imgurl = "";
  late String gmail = "";
  bool button = false;
  List temp = [
    {"item_code": "2", "qty": "2"}
  ];
  String fullname = "";

  List pinglocation_ = [];
  @override
  initState() {
    super.initState();

    print("initState Called");
    DateTime today = DateTime.now();
    dateStr = "${today.day}.${today.month}.${today.year}";
    getdata();
    print(dateStr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        title: fullname,
        subtitle: gmail,
        actions: [
          Container(
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white, width: 3.0, style: BorderStyle.solid),
              image: DecorationImage(
                  fit: BoxFit.cover, image: CachedNetworkImageProvider(imgurl)),
            ),
          ),
        ],
      ),
      body: Column(
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
                              label:
                                  Text('Date', style: TextStyle(fontSize: 12)),
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
                              const DataCell(Text('09:45:23 AM',
                                  style: TextStyle(fontSize: 12))),
                              const DataCell(Text('09:45:23 PM',
                                  style: TextStyle(fontSize: 12))),
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
                                            final user =
                                                await controller.getUser();

                                            final location =
                                                await locationcontroller
                                                    .getLocation(false);
                                            print(
                                                "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
                                            print(user);
                                            // final data =
                                            //     await controller.deleteAllItems();
                                            getdata();
                                            final response = await apiService.get(
                                                "/api/method/thirvu__attendance.utils.api.api.checkin",
                                                {
                                                  "username": user[0]
                                                      ["fullname"],
                                                  "long": location.longitude
                                                      .toString(),
                                                  "lat": location.latitude
                                                      .toString()
                                                });
                                            print(response.body);
                                            print(jsonDecode(response.body)[
                                                'attendance_id']);

                                            final userupdate =
                                                await controller.updateUser(
                                                    user[0]["id"],
                                                    user[0]["image"],
                                                    user[0]["email"],
                                                    jsonDecode(response.body)[
                                                            'attendance_id']
                                                        .toString());
                                            print(userupdate);
                                            Future.delayed(
                                                const Duration(seconds: 1), () {
                                              getdata();
                                            });
                                          }
                                        : () async {
                                            print("checkout");
                                            final user =
                                                await controller.getUser();
                                            print(pinglocation_);
                                            final response = await apiService.get(
                                                "/api/method/thirvu__attendance.utils.api.api.checkout",
                                                {
                                                  "username": user[0]
                                                      ["fullname"],
                                                  "attendance": user[0]
                                                      ["attendanceid"],
                                                  "address_list":
                                                      jsonEncode(pinglocation_)
                                                });
                                            print(response.statusCode);
                                            print(response.body);
                                          },
                                    style: OutlinedButton.styleFrom(
                                      primary: const Color(0xFFEA5455),
                                      side: const BorderSide(
                                          color: Color(0xFFEA5455), width: 2),
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
                                          print("ping......");
                                          DateTime today = DateTime.now();
                                          dateStr =
                                              "${today.day}.${today.month}.${today.year}";
                                          print("ping......1");
                                          final location =
                                              await locationcontroller
                                                  .getLocation(true);

                                          Future.delayed(
                                              const Duration(seconds: 1), () {
                                            getdata();
                                          });
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEA5455),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // <-- Radius
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
                                              fontSize: 13,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Icon(
                                          PhosphorIcons.telegram_logo_fill,
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
                                            color: const Color(0xFFEA5455),
                                          ),
                                          child: Center(
                                            child: Text((index + 1).toString(),
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
                                          style: const TextStyle(fontSize: 10),
                                        )),
                                      )),
                                      DataCell(SizedBox(
                                        height: 40.0,
                                        child: Center(
                                            child: Text(
                                                map['distance'] + " Km" ?? '',
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
    );
  }

  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Databasehelper controller = Get.put(Databasehelper());

    final data = await controller.getItems();
    final user = await controller.getUser();
    print("pppppppppppppppppppppppppppppppppppp");
    print(user);
    print(user.length);
    print(user[0]['image']);
    setState(() {
      pinglocation_ = data;
      print("oooooooooooooooooooooooooo");
      print(user[0]['attendanceid']);
      print(user[0]['attendanceid'].runtimeType);
      print(user[0]['attendanceid'].isEmpty);
      if (user[0]['attendanceid'].isEmpty) {
        print("user[0]['attendanceid'].runtimeType");
        setState(() {
          button = true;
        });
      } else {
        setState(() {
          button = false;
        });
      }

      if (user[0]['image'] != null) {
        print("img1");
        imgurl = user[0]['image'].toString();
      } else {
        print("img2");

        imgurl =
            "https://i.pinimg.com/736x/87/67/64/8767644bc68a14c50addf8cb2de8c59e.jpg";
      }
      fullname = user[0]['fullname'];
      gmail = user[0]['email'];
    });
    print("datatatata");
    print(jsonEncode(pinglocation_));
  }
}
