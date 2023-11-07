import 'package:attendancemarker/Page/homepage.dart';
import 'package:attendancemarker/Page/loginpage.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class Routes {
  static String loginpage = '/loginpage';
  static String homepage = '/homepage';
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
];
