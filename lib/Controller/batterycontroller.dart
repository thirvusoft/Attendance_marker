import 'dart:async';
import 'dart:convert';

import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/Controller/dbhelpercontroller.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class Batteryprecntage extends GetxController {
  final Databasehelper controller = Get.put(Databasehelper());
  final ApiService apiService = ApiService();
  double roundDistanceInKM = 0.0;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var address = ''.obs;
  var address_ = [].obs;
  var percentage = "".obs;
  Position? _currentPosition;
  late StreamSubscription<Position> streamSubscription;

  var battery = Battery();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    batteryprecntage();
  }

  batteryprecntage() async {
    final level = await battery.batteryLevel;
    percentage.value = level.toString();
    return percentage;
  }

  getLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.medium)
          .then((Position position) {
        _currentPosition = position;
        latitude.value = position.latitude;
        longitude.value = position.longitude;
        // getAddressFromLatLang(position);
      }).catchError((e) {
        debugPrint(e);
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    return {
      'latitude': latitude,
      'longitude': longitude,
      'position': _currentPosition
    };
  }

  getAddressFromLatLang(Position position) async {
    final data = await controller.getItems();

    print("[][][]");

    late List result = [];
    var myData = [];

    print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");

    print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");

    List<Placemark> newPlace = await GeocodingPlatform.instance
        .placemarkFromCoordinates(position.latitude, position.longitude,
            localeIdentifier: "en");

    Placemark place = newPlace[0];
    String addressString = [
      place.name,
      place.street,
      place.thoroughfare,
      place.locality,
      place.administrativeArea,
      place.postalCode
    ].join(', ');
    if (data.isNotEmpty) {
      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        data.last['lat'],
        data.last['long'],
      );
      double distanceInKilometers = distanceInMeters / 1000;
      roundDistanceInKM =
          double.parse((distanceInKilometers).toStringAsFixed(2));
    }

    print('Distance in kilometers: $roundDistanceInKM kilometers');
    final location = await controller.createAddress(
      addressString,
      "user",
      position.latitude.toString(),
      position.longitude.toString(),
      roundDistanceInKM.toString(),
    );

    result.add({"address": addressString});

    return location;
  }

  Future splash() async {
    final response =
        await apiService.get("/api/method/frappe.auth.get_logged_user", {});
    if (response.statusCode == 200) {
      Get.offAllNamed("/homepage");
    } else {
      Get.offAllNamed("/loginpage");
    }
  }
}
