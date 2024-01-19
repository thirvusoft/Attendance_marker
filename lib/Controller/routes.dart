import 'package:attendancemarker/Page/call_log.dart';
import 'package:attendancemarker/Page/followuppage.dart';
import 'package:attendancemarker/Page/homepage.dart';
import 'package:attendancemarker/Page/lead.dart';
import 'package:attendancemarker/Page/loginpage.dart';
import 'package:attendancemarker/Page/loglistpage.dart';
import 'package:attendancemarker/Page/splash_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../Page/lead_home.dart';
import '../Page/map_page.dart';

class Routes {
  static String loginpage = '/loginpage';
  static String homepage = '/homepage';
  static String mappage = '/mappage';
  static String splashscreen = '/Splashs';
  static String loglist = '/loglist';
  static String leadpage = '/leadpage';

  static String calllog = '/calllog';
  static String followup = '/followup';
  static String leadhome = '/leadhome';
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
    page: () => LeadPage("", "", ""),
  ),
  GetPage(
    name: Routes.calllog,
    page: () => LeadManagerScreen(),
  ),
  GetPage(
    name: Routes.followup,
    page: () => FollowUpPage(),
  ),
  GetPage(
    name: Routes.leadhome,
    page: () => LeadHomePage(),
  ),
];
