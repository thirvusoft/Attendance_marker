import 'dart:convert';

import 'package:attendancemarker/Controller/batterycontroller.dart';
import 'package:attendancemarker/Controller/dbhelpercontroller.dart';
import 'package:attendancemarker/widgets/button.dart';
import 'package:attendancemarker/widgets/resuable_textfield.dart';
import 'package:attendancemarker/widgets/textform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:heroicons/heroicons.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/apiservice.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  PageController _pageController = PageController();
  bool _isPasswordVisible = true;
  final GlobalKey<FormState> _siteUrlFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  final loginFormkey = GlobalKey<FormState>();
  final Batteryprecntage controller = Get.put(Batteryprecntage());
  final Databasehelper databasecontroller = Get.put(Databasehelper());

  final TextEditingController _mobilenumberController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController mobilNumberLogin = TextEditingController();
  final TextEditingController passwordLogin = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (isFirstLaunch) {
      _pageController.jumpToPage(0);
      await prefs.setBool('first_launch', false);
    } else {
      _pageController.jumpToPage(1);
    }
  }

  Future<bool> isUrlAvailable(String url) async {
    FocusScope.of(context).unfocus();

    try {
      var request = http.Request(
        'GET',
        Uri.parse(
            '$url/api/method/thirvu_mobile.thirvu_mobile.api.api.site_ckeck'),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('stored_url', url);
      } else {}
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (loginFormkey.currentState!.validate()) {
      final response = await apiService.get(
          "/api/method/thirvu__attendance.utils.api.api.login", {
        "usr": _mobilenumberController.text,
        "pwd": _passwordController.text
      });

      if (response.statusCode == 200) {
        final Response = json.decode(response.body);

        response.header['cookie'] =
            "${response.header['set-cookie'].toString()};";
        response.header.removeWhere(
            (key, value) => ["set-cookie", 'content-length'].contains(key));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final baseUrl = prefs.getString('stored_url');
        var userImage = "$baseUrl${Response["image"].toString()}";

        final location = await databasecontroller.createUser(
            Response["full_name"],
            Response["role"],
            json.encode(response.header),
            userImage,
            Response["email"],
            Response["role"].toString());

        if (location.length > 1) {
          databasecontroller.deleteItem(location.last['id'] - 1);
        }
        if (Response["role"] == "Mobile admin user") {
          Get.offAllNamed("/loglist");
        } else {
          Get.offAllNamed("/homepage");
        }

        Get.snackbar(
          "Success",
          Response["message"],
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
      } else {
        final Response = json.decode(response.body);

        Get.snackbar(
          "Success",
          Response["message"]["message"].toString(),
          icon: const HeroIcon(HeroIcons.xMark, color: Colors.white),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          buildSiteCard(),
          buildLoginCard(),
        ],
      ),
    );
  }

  Widget buildSiteCard() {
    return Stack(
      children: [
        const ColoredBox(
          color: Colors.deepPurple,
        ),
        FadeTransition(
          opacity: _animation,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _siteUrlFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Site URL',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ReusableTextFieldNew(
                          iconValue: const Icon(Icons.link),
                          label: 'URL',
                          controller: urlController,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 20),
                        ReusableButton(
                          text: 'Next',
                          onPressed: () async {
                            if (_siteUrlFormKey.currentState!.validate()) {
                              final url = urlController.text;
                              final isAvailable = await isUrlAvailable(url);

                              if (isAvailable) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                Get.snackbar(
                                  "Success",
                                  "Please Check The UPL",
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoginCard() {
    return FadeTransition(
      opacity: _animation,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _loginFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ReusableTextFieldNew(
                      iconValue: const Icon(Icons.phone),
                      label: 'Mobile Number',
                      controller: mobilNumberLogin,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid mobile number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ReusableTextFieldNew(
                      isPasswordVisible: _isPasswordVisible,
                      onTogglePasswordVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      iconValue: const Icon(Icons.lock),
                      label: 'Password',
                      controller: passwordLogin,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableButton(
                          text: 'Back',
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                        ReusableButton(
                          text: 'Login',
                          onPressed: () {
                            if (_loginFormKey.currentState!.validate()) {
                              _login();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
