import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MapCard extends StatefulWidget {
  final bool isPin;
  const MapCard({Key? key, required this.isPin, this.defaultLocation})
      : super(key: key);

  final LatLng? defaultLocation;
  @override
  State<MapCard> createState() => MapCardState();
}

class MapCardState extends State<MapCard> {
  @override
  void initState() {
    super.initState();
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late final CameraPosition _kGooglePlex = CameraPosition(
    target:
        widget.defaultLocation ?? LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              initialCameraPosition: _kGooglePlex,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                // controller.setMapStyle(_mapStyle);
              },
            ),
            widget.isPin
                ? Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/icons/pinn.png",
                        height: 10.h,
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
