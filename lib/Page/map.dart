import 'dart:convert';

import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/Controller/dbhelpercontroller.dart';
import 'package:attendancemarker/constant.dart';
import 'package:attendancemarker/widgets/resubale_popup.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heroicons/heroicons.dart';
import 'package:label_marker/label_marker.dart';
import 'package:heroicons/heroicons.dart';

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
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final Response = json.decode(response.body);
      empLocations = Response["message"];

      for (var empDetail in empLocations) {
        String empName = empDetail[0];
        double latitude = double.parse(empDetail[1]);
        double longitude = double.parse(empDetail[2]);

        markers.addLabelMarker(LabelMarker(
          label: empName,
          textStyle: const TextStyle(fontSize: 150),
          markerId: MarkerId(empName),
          position: LatLng(latitude, longitude),
          backgroundColor: Colors.red,
        ));
      }

      print(markers);
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
    // createMarkers();
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: markers.isEmpty
            ? const Center(
                child: Column(
                  children: [CircularProgressIndicator()],
                ),
              )
            : GoogleMap(
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
                markers: Set<Marker>.of(markers),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              currentMapType = currentMapType == MapType.normal
                  ? MapType.hybrid
                  : MapType.normal;
            });
          },
          child: const Icon(Icons.layers),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat);
  }
}
