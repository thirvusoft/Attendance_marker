import 'dart:convert';

import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class Search extends GetxController {
  final ApiService apiService = ApiService();
  List searchlist_ = [].obs;
  List searchlistindustry_ = [].obs;
  List searchlistterritory_ = [].obs;

  Future searchname(name, doctype) async {
    final response = await apiService.get("frappe.desk.search.search_link", {
      "txt": name,
      "doctype": doctype,
      "ignore_user_permissions": "1",
      "reference_doctype": "Lead"
    });
    if (response.statusCode == 200 && doctype == "Lead Source") {
      searchlist_.clear();
      List<String> valuesList = [];

      final jsonResponse = json.decode(response.body);

      for (var item in jsonResponse['results']) {
        if (item.containsKey('value')) {
          valuesList.add(item['value']);
        }
      }
      searchlist_ += (valuesList);
    }

    if (response.statusCode == 200 && doctype == "Industry Type") {
      searchlistindustry_.clear();
      List<String> valuesList = [];

      final jsonResponse = json.decode(response.body);

      for (var item in jsonResponse['results']) {
        if (item.containsKey('value')) {
          valuesList.add(item['value']);
        }
      }
      searchlistindustry_ += (valuesList);
    }

    if (response.statusCode == 200 && doctype == "Territory") {
      searchlistterritory_.clear();
      List<String> valuesList = [];

      final jsonResponse = json.decode(response.body);

      for (var item in jsonResponse['results']) {
        if (item.containsKey('value')) {
          valuesList.add(item['value']);
        }
      }
      searchlistterritory_ += (valuesList);
    }
  }
}

class LeadCreation extends GetxController {
  final ApiService apiService = ApiService();
  Future Lead(doctype, name, org_name, mobile, email, source, indusrty,
      territory) async {
    final docvalue = {
      "doctype": doctype,
      "first_name": name,
      'email_id': email,
      'mobile_no': mobile,
      'company_name': org_name,
      'source': source,
      'indusrty': indusrty,
      "ignore_user_permissions": "1",
    };
    final response =
        await apiService.post("frappe.client.insert", {'doc': docvalue});

    if (response.statusCode == 200) {
      final Response = json.decode(response.body);
      Get.snackbar(
        "Success",
        'Lead Created',
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
      return true;
    } else {
      final Response = json.decode(response.body);
      Get.snackbar(
        "Failed",
        '',
        icon: const HeroIcon(HeroIcons.xMark, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff35394e),
        borderRadius: 20,
        margin: const EdgeInsets.all(15),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return false;
    }
  }
}
