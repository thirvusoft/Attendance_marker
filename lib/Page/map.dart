import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/resuable_appbar.dart';

class Mapview extends StatefulWidget {
  const Mapview({super.key});

  @override
  State<Mapview> createState() => _MapviewState();
}

class _MapviewState extends State<Mapview> {
  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();

    const LatLng _center = const LatLng(11.1271, 78.6569);

    void _onMapCreated(GoogleMapController controller) {
      _controller.complete(controller);
    }

    return Scaffold(
      appBar: ReusableAppBar(
        title: 'Vignesh M',
        subtitle: "Sales Executive",
        actions: [
          Container(
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white, width: 2.0, style: BorderStyle.solid),
              image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=1887&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")),
            ),
          ),
        ],
      ),
      body: const GoogleMap(
          initialCameraPosition: CameraPosition(target: _center, zoom: 7.0)),
    );
  }
}
