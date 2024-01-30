import 'dart:async';
import 'dart:convert';

import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  MapType currentMapType = MapType.normal;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List empLocations = [];
  final ApiService apiService = ApiService();

  @override
  initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await apiService.get(
        "/api/method/thirvu__attendance.utils.api.api.get_employee_locations",
        {'name': "HR-EMP-00001"},
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        updateMarkersAndPolylines(decodedResponse["message"]);
      } else {
        showErrorSnackbar("Failed to fetch data");
      }
    } catch (error) {
      showErrorSnackbar("An error occurred");
    }
  }

  void updateMarkersAndPolylines(List locations) {
    setState(() {
      empLocations = locations;
    });

    if (empLocations.length > 1) {
      List<LatLng> points = empLocations
          .map((location) =>
              LatLng(double.parse(location[1]), double.parse(location[2])))
          .toList();

      polylines.add(Polyline(
        polylineId: PolylineId('route'),
        points: points,
        color: Color.fromARGB(255, 241, 5, 5),
        width: 5,
      ));
    }

    for (int i = 0; i < empLocations.length; i++) {
      var empDetail = empLocations[i];

      markers.add(Marker(
        markerId: MarkerId(empDetail[0]),
        position: LatLng(
          double.parse(empDetail[1]),
          double.parse(empDetail[2]),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: "Location ${i + 1}",
        ),
      ));
    }

    if (empLocations.isEmpty) {
      showErrorSnackbar("No Records Found");
    }
  }

  void showErrorSnackbar(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff35394e),
      borderRadius: 20,
      margin: const EdgeInsets.all(15),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      isDismissible: true,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEA5455),
        title: ListTile(
          title: Text(
            "Map View",
            style: GoogleFonts.sansita(fontSize: 20, color: Colors.white),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.offAllNamed("/employeelist");
          },
        ),
      ),
      body: SafeArea(
        child: empLocations.isEmpty
            ? buildLoadingWidget()
            : GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                trafficEnabled: true,
                indoorViewEnabled: true,
                mapType: currentMapType,
                padding: EdgeInsets.fromLTRB(
                  8,
                  MediaQuery.of(context).padding.top,
                  8,
                  MediaQuery.of(context).padding.bottom,
                ),
                initialCameraPosition: const CameraPosition(
                  target: LatLng(15.3702058, 78.7362404),
                  zoom: 6,
                ),
                markers: markers,
                polylines: polylines,
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.red,
      ),
    );
  }
}
