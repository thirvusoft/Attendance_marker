import 'dart:async';

import 'package:attendancemarker/Controller/apiservice.dart';
import 'package:attendancemarker/Controller/dbhelpercontroller.dart';
import 'package:attendancemarker/widgets/resubale_popup.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/resuable_appbar.dart';

class Mapview extends StatefulWidget {
  const Mapview({super.key});

  @override
  State<Mapview> createState() => _MapviewState();
}

class _MapviewState extends State<Mapview> {
  @override
  initState() {
    super.initState();

    // getdata();
  }

  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();

    const LatLng _center = const LatLng(11.1271, 78.6569);

    void _onMapCreated(GoogleMapController controller) {
      _controller.complete(controller);
    }

    String fullname = "";
    late String imgurl = "";
    late String gmail = "";
    return Scaffold(
      appBar: ReusableAppBar(
        title: fullname,
        subtitle: gmail,
        actions: [
          GestureDetector(
            onTap: () {
              showPopup(context);
            },
            child: Container(
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white, width: 3.0, style: BorderStyle.solid),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(imgurl)),
              ),
            ),
          ),
        ],
      ),
      body: const GoogleMap(
          initialCameraPosition: CameraPosition(target: _center, zoom: 7.0)),
    );
  }

  void showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupWidget(
          title: 'Logout',
          content:
              '    Do you want to log out from \n             Attendance marker?',
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                      child: const Text(
                        'Cancel',
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFFEA5455)),
                      ),
                      onPressed: () {
                        Get.back();
                      }),
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                    child: const Text(
                      'Yes, Logout',
                      style: TextStyle(fontSize: 15, color: Color(0xFFEA5455)),
                    ),
                    onPressed: () async {
                      final ApiService apiService = ApiService();
                      final Databasehelper controller =
                          Get.put(Databasehelper());

                      final response =
                          await apiService.get("/api/method/logout", {});

                      if (response.statusCode == 200) {
                        final data = await controller.deleteAllItems();
                        final userlist = await controller.getUser();

                        // controller.deleteItem(location.length - 1);

                        Get.offAllNamed("/loginpage");
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
