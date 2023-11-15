import 'package:attendancemarker/Controller/batterycontroller.dart';
import 'package:attendancemarker/Controller/dbhelpercontroller.dart';
import 'package:attendancemarker/constant.dart';
import 'package:attendancemarker/widgets/resuable_appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late String dateStr;
  final Databasehelper controller = Get.put(Databasehelper());
  final Batteryprecntage locationcontroller = Get.put(Batteryprecntage());
  List temp = [
    {"item_code": "2", "qty": "2"}
  ];
  @override
  initState() {
    super.initState();
    // ignore: avoid_print
    print("initState Called");
    DateTime today = DateTime.now();
    dateStr = "${today.day}.${today.month}.${today.year}";

    print(dateStr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        title: 'Vignesh M',
        subtitle: "Sales Executive",
        actions: [
          Container(
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white, width: 3.0, style: BorderStyle.solid),
              image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=1887&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")),
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
                                style: TextStyle(fontSize: 12),
                              )),
                              DataCell(Text('09:45:23 AM',
                                  style: TextStyle(fontSize: 12))),
                              DataCell(Text('09:45:23 PM',
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
                                    onPressed: () async {
                                      print("aaaa");
                                      final location = await locationcontroller
                                          .getLocation();
                                      final batteryprecntage =
                                          await locationcontroller
                                              .batteryprecntage();
                                      print(location);

                                      print(locationcontroller.longitude);
                                      final test = await controller.createItem(
                                          "vicky",
                                          dateStr,
                                          "",
                                          location.toString(),
                                          batteryprecntage.toString());
                                      print(test);
                                    },
                                    style: ElevatedButton.styleFrom(
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
                                          Text("Check In",
                                              style: TextStyle(fontSize: 15)),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Icon(Icons.arrow_forward),
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
                                  onPressed: () async {
                                    DateTime today = DateTime.now();
                                    dateStr =
                                        "${today.day}.${today.month}.${today.year}";
                                    final location =
                                        await locationcontroller.getLocation();
                                    print(location["position"]);
                                    final address = await locationcontroller
                                        .getAddressFromLatLang(
                                            location["position"]);
                                    print(address);
                                    final batteryprecntage =
                                        await locationcontroller
                                            .batteryprecntage();
                                    final test = await controller.updateItem(
                                        1,
                                        batteryprecntage.toString(),
                                        address.toString(),
                                        dateStr);
                                    print(test);
                                  },
                                  style: ElevatedButton.styleFrom(
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
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Icon(
                                          PhosphorIcons.telegram_logo_fill,
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
                                        letterSpacing: .1))),
                            DataColumn(
                                label: Text('Distance',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .1))),
                          ],
                          rows: data
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
                                          map['Name'] ?? '',
                                          style: const TextStyle(fontSize: 10),
                                        )),
                                      )),
                                      DataCell(SizedBox(
                                        height: 40.0,
                                        child: Center(
                                            child: Text(map['Code'] ?? '',
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
}
