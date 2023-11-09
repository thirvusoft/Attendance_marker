import 'dart:convert';

import 'package:attendancemarker/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService extends GetxService {
  Future<ApiResponse> get(
    String methodName,
    args,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = "${dotenv.env['API_URL']}$methodName";
    print(url);
    if ((prefs.getString('request-header') ?? "").toString().isNotEmpty) {
      json
          .decode(prefs.getString('request-header').toString())
          .forEach((k, v) => {apiHeaders[k.toString()] = v.toString()});
    }
    if (args.toString() == '{}') {
      final uri = Uri.parse(url);
      final response = await http.get(uri, headers: apiHeaders);
      if (response.headers.toString().contains("system_user=no")) {
        Get.toNamed("/loginpage");
      }
      return ApiResponse(
          statusCode: response.statusCode,
          body: response.body,
          header: response.headers);
    } else {
      final uri = Uri.parse(url).replace(queryParameters: args);
      final response = await http.get(uri, headers: apiHeaders);
      if (response.headers.toString().contains("system_user=no")) {
        Get.toNamed("/loginpage");
      }
      return ApiResponse(
          statusCode: response.statusCode,
          body: response.body,
          header: response.headers);
    }
  }
}

class ApiResponse {
  final int statusCode;
  final String body;
  var header = {};

  ApiResponse(
      {required this.statusCode, required this.body, required this.header});
}
