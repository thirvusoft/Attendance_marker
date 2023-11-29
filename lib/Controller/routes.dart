import 'package:attendancemarker/Page/homepage.dart';
import 'package:attendancemarker/Page/loginpage.dart';
import 'package:attendancemarker/Page/loglistpage.dart';
import 'package:attendancemarker/Page/splash_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../Page/map_page.dart';

class Routes {
  static String loginpage = '/loginpage';
  static String homepage = '/homepage';
  static String mappage = '/mappage';
  static String splashscreen = '/Splashs';
  static String loglist = '/loglist';
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
];
