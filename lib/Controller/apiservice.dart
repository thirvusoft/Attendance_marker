import 'dart:convert';

import 'package:attendancemarker/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'dbhelpercontroller.dart';

class ApiService extends GetxService {
  final Databasehelper controller = Get.put(Databasehelper());

  Future<ApiResponse> get(String methodName, args) async {
    print(args);
    print(methodName);
    final data = await controller.getUser();

    final url = "${dotenv.env['API_URL']}$methodName";

    if (data.isEmpty) {
      if (args.toString() == '{}') {
        final uri = Uri.parse(url);
        final response = await http.get(uri, headers: apiHeaders);
        // if (response.headers.toString().contains("system_user=no")) {
        //   Get.toNamed("/loginpage");
        // }
        return ApiResponse(
            statusCode: response.statusCode,
            body: response.body,
            header: response.headers);
      } else {
        final uri = Uri.parse(url).replace(queryParameters: args);
        final response = await http.get(uri, headers: apiHeaders);
        // if (response.headers.toString().contains("system_user=no")) {
        //   Get.toNamed("/loginpage");
        // }
        return ApiResponse(
            statusCode: response.statusCode,
            body: response.body,
            header: response.headers);
      }
    } else {
      if ((data[0]["requestheader"] ?? "").toString().isNotEmpty) {
        json
            .decode(data[0]["requestheader"].toString())
            .forEach((k, v) => {apiHeaders[k.toString()] = v.toString()});
      }
      if (args.toString() == '{}') {
        final uri = Uri.parse(url);
        final response = await http.get(uri, headers: apiHeaders);
        // if (response.headers.toString().contains("system_user=no")) {
        //   Get.toNamed("/loginpage");
        // }
        return ApiResponse(
            statusCode: response.statusCode,
            body: response.body,
            header: response.headers);
      } else {
        final uri = Uri.parse(url).replace(queryParameters: args);
        final response = await http.get(uri, headers: apiHeaders);
        // if (response.headers.toString().contains("system_user=no")) {
        //   Get.toNamed("/loginpage");
        // }
        return ApiResponse(
            statusCode: response.statusCode,
            body: response.body,
            header: response.headers);
      }
    }
  }

  Future<ApiResponse> post(String methodName, args) async {
    final data = await controller.getUser();

    final url = "${dotenv.env['API_URL']}/api/method/$methodName";
    if (data.isNotEmpty) {
      if ((data[0]["requestheader"] ?? "").toString().isNotEmpty) {
        json
            .decode(data[0]["requestheader"].toString())
            .forEach((k, v) => {apiHeaders[k.toString()] = v.toString()});
      }
    }

    final uri = Uri.parse(url);
    final response =
        await http.post(uri, headers: apiHeaders, body: json.encode(args));
    
    // if (response.headers.toString().contains("system_user=no")) {
    //   Get.toNamed("/loginpage");
    // }
    return ApiResponse(
        statusCode: response.statusCode,
        body: response.body,
        header: response.headers);
  }
}

class ApiResponse {
  final int statusCode;
  final String body;
  var header = {};

  ApiResponse(
      {required this.statusCode, required this.body, required this.header});
}
