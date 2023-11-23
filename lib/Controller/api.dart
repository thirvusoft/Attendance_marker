import 'dart:convert';

import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:get/get.dart';

class Search extends GetxController {
  final ApiService apiService = ApiService();
  List searchlist_ = [].obs;

  Future searchname(name, doctype) async {
    final response = await apiService.get("frappe.desk.search.search_link", {
      "txt": name,
      "doctype": doctype,
      "ignore_user_permissions": "1",
      "reference_doctype": "Lead"
    });
    if (response.statusCode == 200) {
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
  }
}
