import 'package:battery_plus/battery_plus.dart';
import 'package:get/get.dart';

class Batteryprecntage extends GetxController {
  var percentage = "".obs;
  var battery = Battery();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    batteryprecntage();
  }

  batteryprecntage() async {
    final level = await battery.batteryLevel;
    // battery.onBatteryStateChanged.listen((BatteryState state) {
    //   print("#######################################");
    //   print(state);
    //   percentage.value = state.toString();
    // });
    percentage.value = level.toString();
  }
}
