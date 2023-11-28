import 'dart:convert';

import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/Controller/dbhelpercontroller.dart';
import 'package:attendancemarker/widgets/resubale_popup.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heroicons/heroicons.dart';
import 'package:label_marker/label_marker.dart';

import '../widgets/resuable_appbar.dart';

class Mapview extends StatefulWidget {
  const Mapview({super.key});

  @override
  State<Mapview> createState() => _MapviewState();
}

class _MapviewState extends State<Mapview> {
  final LatLng initialPosition = const LatLng(15.3702058, 78.7362404);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  late GoogleMapController mapController;
  MapType currentMapType = MapType.normal;

  Set<Marker> markers = {};

  List empLocations = [];
  final ApiService apiService = ApiService();
  @override
  initState() {
    super.initState();
    getEmployeeData();
  }

  Future getEmployeeData() async {
    ApiService();

    final response = await apiService.get(
        "/api/method/thirvu__attendance.utils.api.api.get_employee_locations",
        {});
        print(response.body);
    if (response.statusCode == 200) {
      final Response = json.decode(response.body);
      empLocations = Response["message"];
      if (empLocations.isEmpty) {
        Get.snackbar(
          "No Records Found",
          "",
          icon: const HeroIcon(HeroIcons.check, color: Colors.white),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xff35394e),
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
        );
      }
    }
    createMarkers();
  }

  void createMarkers() {
    for (var empDetail in empLocations) {
      markers
          .addLabelMarker(LabelMarker(
              label: empDetail["name"].toString(),
              markerId: MarkerId(empDetail["name"].toString()),
              position: LatLng(double.parse(empDetail["latitude"] ?? 0.0),
                  double.parse(empDetail["longitude"] ?? 0.0)),
              icon: markerIcon))
          .then((value) => setState(() => {}));
    }
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    String fullname = "";
    late String imgurl = "";
    late String gmail = "";
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
                width: 60,
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
          ],
        ),
        body: GoogleMap(
          onMapCreated: onMapCreated,
          myLocationEnabled: false,
          trafficEnabled: true,
          indoorViewEnabled: true,
          mapType: currentMapType,
          padding: EdgeInsets.fromLTRB(
            8,
            MediaQuery.of(context).padding.top,
            8,
            MediaQuery.of(context).padding.bottom,
          ),
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: 6,
          ),
          markers: markers,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              currentMapType = currentMapType == MapType.normal
                  ? MapType.satellite
                  : MapType.normal;
            });
          },
          child: const Icon(Icons.layers),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat);
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
                      final ApiService apiService = ApiService();
                      final Databasehelper controller =
                          Get.put(Databasehelper());

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
}
