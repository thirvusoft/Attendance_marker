import 'dart:convert';

import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/Controller/batterycontroller.dart';
import 'package:attendancemarker/Controller/dbhelpercontroller.dart';
import 'package:attendancemarker/widgets/resuable_textfield.dart';
import 'package:attendancemarker/widgets/reusable_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:http/http.dart' as http;

class Loginpage extends StatelessWidget {
  final loginFormkey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  final Batteryprecntage controller = Get.put(Batteryprecntage());
  final Databasehelper databasecontroller = Get.put(Databasehelper());

  final TextEditingController _mobilenumberController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: const Color(0xFFEA5455),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 250,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: loginFormkey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Login",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: .1))),
                      const SizedBox(
                        height: 15,
                      ),
                      ReusableTextField(
                        labelText: 'Mobile Number',
                        controller: _mobilenumberController,
                        obscureText: false,
                        inputFormatters: FilteringTextInputFormatter.digitsOnly,
                        suffixIcon: HeroIcons.devicePhoneMobile,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Mobile number can't be empty";
                          } else if (value.length != 10) {
                            return "Invalid Mobile Number ";
                          }
                          return null;
                        },
                        maxLength: 10,
                        readyonly: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      ReusableTextField(
                        labelText: 'Password',
                        controller: _passwordController,
                        obscureText: true,
                        suffixIcon: HeroIcons.lockClosed,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password can't be empty";
                          }
                          return null;
                        },
                        readyonly: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(180, 0, 0, 0),
                        child: const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'Forget Password ? '),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomFormButton(
                        innerText: 'Login',
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          if (loginFormkey.currentState!.validate()) {
                            final response = await apiService.get(
                                "/api/method/thirvu__attendance.utils.api.api.login",
                                {
                                  "usr": _mobilenumberController.text,
                                  "pwd": _passwordController.text
                                });

                            if (response.statusCode == 200) {
                              final Response = json.decode(response.body);

                              response.header['cookie'] =
                                  "${response.header['set-cookie'].toString()};";
                              response.header.removeWhere((key, value) => [
                                    "set-cookie",
                                    'content-length'
                                  ].contains(key));

                              var userImage =
                                  "${dotenv.env['API_URL']}${Response["image"].toString()}";

                              final location =
                                  await databasecontroller.createUser(
                                      Response["full_name"],
                                      Response["role"],
                                      json.encode(response.header),
                                      userImage,
                                      Response["email"],
                                      Response["role"].toString());

                              if (location.length > 1) {
                                databasecontroller
                                    .deleteItem(location.last['id'] - 1);
                              }
                              if (Response["role"] == "Mobile admin user") {
                                Get.offAllNamed("/loglist");
                              } else {
                                Get.offAllNamed("/homepage");
                              }

                              Get.snackbar(
                                "Success",
                                Response["message"],
                                icon: const HeroIcon(HeroIcons.check,
                                    color: Colors.white),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: const Color(0xff35394e),
                                borderRadius: 20,
                                margin: const EdgeInsets.all(15),
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                                isDismissible: true,
                                forwardAnimationCurve: Curves.easeOutBack,
                              );
                            } else {
                              final Response = json.decode(response.body);

                              Get.snackbar(
                                "Success",
                                Response["message"]["message"].toString(),
                                icon: const HeroIcon(HeroIcons.xMark,
                                    color: Colors.white),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: const Color(0xFF212A1D),
                                borderRadius: 20,
                                margin: const EdgeInsets.all(15),
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                                isDismissible: true,
                                forwardAnimationCurve: Curves.easeOutBack,
                              );
                            }
                          }
                        },
                        backgroundColor: const Color(0xFF212A1D),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
