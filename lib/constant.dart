import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/Controller/batterycontroller.dart';
import 'package:attendancemarker/Controller/dbhelpercontroller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


 final Databasehelper controller = Get.put(Databasehelper());
  final Batteryprecntage locationcontroller = Get.put(Batteryprecntage());
List<dynamic> items = [];
 final ApiService apiService = ApiService();
final List<Map<String, String>> data = [
  {
    'ID': '1',
    'Name':
        '45 Sunshine Avenue,Flat 302, Emerald Heights,Mumbai, Maharashtra 400001',
    'Code': '1.5 KM'
  },
  {
    'ID': '2',
    'Name': '67 Hillside RoadApartment 3ABangalore, Karnataka 560001',
    'Code': '3.5 KM'
  },
  {
    'ID': '3',
    'Name':
        '22 River View TerraceBlock C, 5th FloorKolkata, West Bengal 700002',
    'Code': '2.5 KM'
  },
  {
    'ID': '3',
    'Name':
        '22 River View TerraceBlock C, 5th FloorKolkata, West Bengal 700002',
    'Code': '5 KM'
  },
  {
    'ID': '3',
    'Name':
        '22 River View TerraceBlock C, 5th FloorKolkata, West Bengal 700002',
    'Code': '15 KM'
  },
  {
    'ID': '3',
    'Name':
        '22 River View TerraceBlock C, 5th FloorKolkata, West Bengal 700002',
    'Code': '115 KM'
  },
];
Map<String, String> apiHeaders = {};
