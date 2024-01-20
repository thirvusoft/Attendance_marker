import 'dart:convert';

import 'package:attendancemarker/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class Employee {
  final String name;
  final String designation;
  final String id;

  Employee({required this.name, required this.designation, required this.id});
}

class EmployeeList extends StatefulWidget {
  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  List<Employee> employeeList = [];
  List<Employee> filteredEmployeeList = [];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEmployeeList();
  }

  Future<void> fetchEmployeeList() async {
    final user = await controller.getUser();
    final response = await apiService.get(
      '/api/method/thirvu__attendance.utils.api.api.emp_attendance_list',
      {},
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final message = jsonResponse['message'] as List<dynamic>;

      List<Employee> employees = message.map((data) {
        return Employee(
            name: data['employee_name'] ?? '',
            designation: data['designation'] ?? 'No Designation',
            id: data['id']);
      }).toList();

      setState(() {
        employeeList = employees;
        filteredEmployeeList = employees;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEA5455),
        title: ListTile(
          title: Text(
            "Employee Log",
            style: GoogleFonts.sansita(fontSize: 20, color: Colors.white),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.offAllNamed("/loglist");
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                filterEmployeeList(value);
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  borderSide: BorderSide(color: Color(0xFFEA5455)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  borderSide: BorderSide(
                    color: Color(0xFFEA5455),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: filteredEmployeeList.length,
            itemBuilder: (context, index) {
              Employee employee = filteredEmployeeList[index];
              return _buildListItem(index, employee);
            },
          )),
        ],
      ),
    );
  }

  Widget _buildListItem(int index, Employee employee) {
    return Card(
      color: Colors.white,
      child: ListTile(
        leading: Text((index + 1).toString()),
        title: Text(' ${employee.name}'),
        subtitle: Text('${employee.designation}'),
        onTap: () {
          Get.offAllNamed("/mappage");
        },
      ),
    );
  }

  void filterEmployeeList(String query) {
    List<Employee> filteredList = employeeList
        .where((employee) =>
            employee.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredEmployeeList = filteredList;
    });
  }
}
