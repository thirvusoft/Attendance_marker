import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class Batteryprecntage extends GetxController {
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
    print(position);
    List<Placemark> newPlace = await GeocodingPlatform.instance
        .placemarkFromCoordinates(position.latitude, position.longitude,
            localeIdentifier: "en");

    Placemark place = newPlace[0];
    print(place);
    address.value = {
      place.name,
      place.street,
      place.thoroughfare,
      place.locality,
      place.administrativeArea,
      place.postalCode
    }.toString();
    var des = [
      {"address": address}
    ];
    // address_.add(des);
    // address_.add(place.name);
    // address_.add(place.street);
    // address_.add(place.thoroughfare);
    // address_.add(place.administrativeArea);
    // address_.add(place.postalCode);

    return des;
  }
}
