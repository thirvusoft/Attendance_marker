import 'package:attendancemarker/Page/homepage.dart';
import 'package:attendancemarker/Page/loginpage.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../Page/map.dart';

class Routes {
  static String loginpage = '/loginpage';
  static String homepage = '/homepage';
  static String mappage = '/mappage';
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
];
