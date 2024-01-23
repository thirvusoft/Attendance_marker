import 'dart:convert';

import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class Search extends GetxController {
  final ApiService apiService = ApiService();
  List searchlist_ = [].obs;
  List searchlistindustry_ = [].obs;
  List searchlistterritory_ = [].obs;
  List searchuserlist = [].obs;

  Future searchname(name, doctype) async {
    print('-------------------------------');
    print(doctype);
    final response = await apiService.get(
      "/api/method/frappe.desk.search.search_link",
      {
        "txt": name,
        "doctype": doctype,
        "ignore_user_permissions": "1",
        "reference_doctype": "Lead"
      },
    );
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

    if (response.statusCode == 200 && doctype == "User") {
      searchuserlist.clear();
      List<String> valuesList = [];

      final jsonResponse = json.decode(response.body);

      for (var item in jsonResponse['results']) {
        if (item.containsKey('value')) {
          valuesList.add(item['value']);
        }
      }
      searchuserlist += (valuesList);
    }
  }
}

class LeadCreation extends GetxController {
  final ApiService apiService = ApiService();

  Future<bool> leadCreation(
      id,
      doctype,
      name,
      org_name,
      mobile,
      email,
      source,
      industry,
      territory,
      nextfollowup,
      nextfollowby,
      discription,
      street,
      city,
      state,
      zipcode,
      website) async {
    final currentDate = DateTime.now();
    final formattedDate =
        "${currentDate.year}-${currentDate.month}-${currentDate.day}";
    final user = await controller.getUser();

    final docvalue = {
      "doctype": doctype,
      "id": id,
      "first_name": name,
      'email_id': email,
      'mobile_no': mobile,
      'company_name': org_name,
      'source': source,
      'industry': industry,
      'territory': territory,
      'website': website,
      'street': street,
      'city': city,
      'state': state,
      'zipcode': zipcode,
      'custom_follow_ups': {
        'date': formattedDate,
        'followed_by': user[0]['email'],
        'next_followup_date': nextfollowup,
        'next_follow_up_by': nextfollowby,
        'description': discription
      },
      "ignore_user_permissions": "1",
    };

    var response;

    if (id == "") {
      print('111111');
      response = await apiService.post(
        'thirvu__attendance.utils.api.api.new_lead',
        {"data": jsonEncode(docvalue)},
      );
    } else {
      print('2222222222');

      response = await apiService.post(
        'thirvu__attendance.utils.api.api.edit_lead',
        {"data": jsonEncode(docvalue)},
      );
    }

    if (response.statusCode == 200) {
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

class LeadFollowup extends GetxController {
  final ApiService apiService = ApiService();

  Future<bool> leadFollowup(lead, user, nextdate, nextby, status) async {
    final docvalue = {
      "lead": lead,
      "user": user,
      'nextfollowup_date': nextdate,
      'nextfollowup_by': nextby,
      'status': status,
    };

    final response = await apiService.post(
        "thirvu__attendance.utils.api.api.followup_table_updating", docvalue);

    if (response.statusCode == 200) {
      Get.snackbar(
        "Success",
        'Followup Updated',
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
