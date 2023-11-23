import 'package:attendancemarker/Page/homepage.dart';
import 'package:attendancemarker/Page/lead.dart';
import 'package:attendancemarker/Page/loginpage.dart';
import 'package:attendancemarker/Page/loglistpage.dart';
import 'package:attendancemarker/Page/splash_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../Page/map.dart';

class Routes {
  static String loginpage = '/loginpage';
  static String homepage = '/homepage';
  static String mappage = '/mappage';
  static String splashscreen = '/Splashs';
  static String loglist = '/loglist';
  static String leadpage = '/leadpage';
}

final getPages = [
  GetPage(
    name: Routes.loginpage,
    page: () => Loginpage(),
  ),
  GetPage(
    name: Routes.homepage,
    page: () => const Homepage(),
  ),
  GetPage(
    name: Routes.mappage,
    page: () => const Mapview(),
  ),
  GetPage(
    name: Routes.splashscreen,
    page: () => const Splashscreen(),
  ),
  GetPage(
    name: Routes.loglist,
    page: () => const Loglist(),
  ),
  GetPage(
    name: Routes.leadpage,
    page: () =>  LeadPage(),
  ),
];
