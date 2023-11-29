import 'dart:async';
import 'dart:convert';
import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heroicons/heroicons.dart';
import 'package:label_marker/label_marker.dart';
import 'package:http/http.dart' as http;

class Mapview extends StatefulWidget {
  const Mapview({super.key});

  @override
  State<Mapview> createState() => _MapviewState();
}

class _MapviewState extends State<Mapview> {
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
    final response = await apiService.get(
        "/api/method/thirvu__attendance.utils.api.api.get_employee_locations",
        {},http.get);

    if (response.statusCode == 200) {
      final Response = json.decode(response.body);
      setState(() {
        empLocations = Response["message"];
      });
      for (var empDetail in empLocations) {
        markers
            .addLabelMarker(LabelMarker(
          label: empDetail[0],
          textStyle: const TextStyle(fontSize: 50),
          markerId: MarkerId(empDetail[0]),
          position:
              LatLng(double.parse(empDetail[1]), double.parse(empDetail[2])),
          backgroundColor: Colors.red,
        ))
            .then(
          (value) {
            setState(() {});
          },
        );
      }

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
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: empLocations.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.red,
                    )
                  ],
                ),
              )
            : GoogleMap(
                onMapCreated: _onMapCreated,
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
                initialCameraPosition: const CameraPosition(
                  target: LatLng(15.3702058, 78.7362404),
                  zoom: 6,
                ),
                markers: markers,
              ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
