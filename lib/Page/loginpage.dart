import 'dart:convert';

import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/Controller/batterycontroller.dart';
import 'package:attendancemarker/Controller/dbhelpercontroller.dart';
import 'package:attendancemarker/widgets/resuable_textfield.dart';
import 'package:attendancemarker/widgets/reusable_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatelessWidget {
  final _loginFormkey = GlobalKey<FormState>();
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
                      suffixIcon: HeroIcons.devicePhoneMobile,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Mobile Number can't be empty";
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
                        print(controller.percentage);
                        print("*********************************************");
                        final response = await apiService.get(
                            "/api/method/thirvu__attendance.utils.api.api.login",
                            {
                              "usr": _mobilenumberController.text,
                              "pwd": _passwordController.text
                            });
                        print(response.body);
                        if (response.statusCode == 200) {
                          // Get.toNamed("/homepage");
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          final Response = json.decode(response.body);
                          await prefs.setString(
                              'full_name', Response["full_name"]);
                          response.header['cookie'] =
                              "${response.header['set-cookie'].toString()};";
                          response.header.removeWhere((key, value) =>
                              ["set-cookie", 'content-length'].contains(key));

                          await prefs.setString(
                              'request-header', json.encode(response.header));
                          var temp =
                              json.encode(response.header["cookie"]).toString();
                          final location = await databasecontroller.createUser(
                            Response["full_name"],
                            response.header['set-cookie'].toString(),
                            json.encode(response.header),
                            "",
                            "",
                          );
                          print(location);
                          Object extractUserImage(String input) {
                            RegExp regExp = RegExp(r'user_image=([^;]+)');
                            RegExp regExp1 = RegExp(r'user_id=([^;]+)');

                            Match? match = regExp.firstMatch(input);
                            Match? match1 = regExp1.firstMatch(input);

                            if (match != null) {
                              return {
                                "image": Uri.decodeComponent(match.group(1)!),
                                "email": Uri.decodeComponent(match1!.group(1)!)
                              };
                            }

                            return "";
                          }

                          List t = [];
                          t.add((extractUserImage(temp)));
                          var userImage =
                              "${dotenv.env['API_URL']}${t[0]["image"].toString()}";
                          var email = t[0]["email"];
                          final userupdate = await databasecontroller
                              .updateUser(location.length, userImage, email);
                          print(
                              "+++++++++++++++++Finall data++++++++++++++++++++");
                          print(userupdate);
                          print(userupdate.length);
                          await prefs.setString('image', userImage);
                          await prefs.setString('email', email);
                        }
                      },
                      backgroundColor: const Color(0xFF212A1D),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
