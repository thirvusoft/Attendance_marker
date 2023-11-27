import 'dart:async';
import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/Controller/dbhelpercontroller.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

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

  getLocation(bool value) async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return "Locatuon not enabled";
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
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
          .then((Position position) {
        _currentPosition = position;
        latitude.value = position.latitude;
        longitude.value = position.longitude;
        if (value) {
          print("ttttttttttttttttttttttttttttttttttttt");
          print(position);
          getAddressFromLatLang(position);
        }
      }).catchError((e) {
        print('Error obtaining location: $e');
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }

    return _currentPosition;
  }

  getAddressFromLatLang(Position position) async {
    print(position);
    final data = await controller.getItems();

    late List result = [];
    var myData = [];

    List<Placemark> newPlace = await GeocodingPlatform.instance
        .placemarkFromCoordinates(position.latitude, position.longitude,
            localeIdentifier: "en");
    print(newPlace);
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
      final user = await controller.getUser();
      print(user);
      print(user[0]['cookie']);
      if (user[0]['cookie'] == "Mobile admin user" && user.isNotEmpty) {
        Get.offAllNamed("/loglist");
      } else {
        Get.offAllNamed("/homepage");
      }
    } else {
      Get.offAllNamed("/loginpage");
    }
  }
}
