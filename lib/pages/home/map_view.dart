import 'dart:async';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/bottom_navigation.dart';
import 'package:musch/pages/home/subscription_plan.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';

import 'dart:ui' as ui;

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../widgets/text_field.dart';

class MapSample extends StatefulWidget {
  final VoidCallback updateParentState; // Define callback
  const MapSample({Key? key, required this.updateParentState})
      : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  // late String _mapStyle;
  Set<Marker> markers = {};

  GoogleMapController? _controller;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();
    addMarkers();
    setState(() {});
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }
  // Uint8List? resizeImage(Uint8List data, width, height) {
  //   Uint8List? resizedData = data;
  //   IMG.Image? img = IMG.decodeImage(data);
  //   IMG.Image resized = IMG.copyResize(img!, width: width, height: height);
  //   resizedData = Uint8List.fromList(IMG.encodePng(resized));
  //   return resizedData;
  // }

  LatLng startLocation = LatLng(27.6602292, 85.308027);
  LatLng endLocation = LatLng(27.6599592, 85.3102498);

  addMarkers() async {
    markers.add(
      Marker(
        onTap: () {
          showDialog(
              context: context,
              barrierColor: MyColors.primary.withOpacity(0.8),
              builder: (context) => NotAccess());
        },
        markerId: MarkerId(startLocation.toString()),
        position: LatLng(33.489044, 73.089211),
        icon: await getMarkerIcon(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTUzn7-qinvq-jbUgQWNL-OfnXUFXfxbtwMs6-Utey3A&s",
            Size(170.0, 170.0)),
      ),
    );

    if (_controller == null) return;
    await _controller!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(33.489044, 73.089211), zoom: 14.4746)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xfff2f2f2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: Image.asset(
          "assets/icons/mag.png",
          height: 3.h,
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF4F4F4),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22.0, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      current = 0;
                                    });
                                    Get.find<NavScreenController>()
                                        .controller
                                        .jumpToTab(current);
                                    widget.updateParentState();
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Remix.arrow_left_s_line,
                                    color: Colors.black,
                                    size: 3.h,
                                  )),
                              SizedBox(width: 3.w),
                              text_widget(
                                "Find Near by",
                                fontSize: 19.sp,
                              )
                            ],
                          ),
                          SizedBox(height: 2.h),
                          textFieldWithPrefixSuffuxIconAndHintText(
                            "Search  ",
                            // controller: _.password,
                            fillColor: Colors.white,
                            mainTxtColor: Colors.black,
                            radius: 12,
                            bColor: Colors.transparent,
                            prefixIcon: "assets/nav/s1.png",
                            isPrefix: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GoogleMap(
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(33.489044, 73.089211), zoom: 40.0),
                      zoomControlsEnabled: false,
                      markers: markers,
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                        // _controller!.setMapStyle(_mapStyle);
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  final Radius radius = Radius.circular(size.width / 1.8);

  final Paint tagPaint = Paint()..color = Colors.transparent;
  final double tagWidth = 40.0;

  final Paint shadowPaint = Paint()..color = MyColors.primary.withAlpha(100);
  final double shadowWidth = 15.0;

  final Paint borderPaint = Paint()..color = MyColors.primary;
  final double borderWidth = 3.0;

  final double imageOffset = shadowWidth + borderWidth;

  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      shadowPaint);

  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(shadowWidth, shadowWidth, size.width - (shadowWidth * 2),
            size.height - (shadowWidth * 2)),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      borderPaint);

  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(size.width - tagWidth, 0.0, tagWidth, tagWidth),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      tagPaint);

  Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
      size.width - (imageOffset * 2), size.height - (imageOffset * 2));

  canvas.clipPath(Path()..addOval(oval));

  // Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imagePath)).load(imagePath))
  //     .buffer
  //     .asUint8List();// Alternatively use your own method to get the image
  // paintImage(canvas: canvas, image: by, rect: oval, fit: BoxFit.fitWidth);
  ui.Image image = await getImageFromPath(
      imagePath); // Alternatively use your own method to get the image
  paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fill);

  // Convert canvas to image
  final ui.Image markerAsImage = await pictureRecorder
      .endRecording()
      .toImage(size.width.toInt(), size.height.toInt());

  // Convert image to bytes
  final ByteData? byteData =
      await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List uint8List = byteData!.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(uint8List);
}

Future<ui.Image> getImageFromPath(String imagePath) async {
  // String imgurl =
  //       vendor.profileImg;
  Uint8List bytes =
      (await NetworkAssetBundle(Uri.parse(imagePath)).load(imagePath))
          .buffer
          .asUint8List();
  // Uint8List? smallimg = resizeImage(bytes, 150, 150);

  final Completer<ui.Image> completer = new Completer();

  ui.decodeImageFromList(bytes, (ui.Image img) {
    return completer.complete(img);
  });

  return completer.future;
}

class NotAccess extends StatelessWidget {
  NotAccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              width: 90.w,
              // height: 45.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              // color: Color(0xfff9f8f6),

              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 1.4.h),
                    Image.asset(
                      "assets/icons/noa.png",
                      height: 8.h,
                    ),
                    SizedBox(height: 1.4.h),
                    text_widget("Couldn't access This Feiends",
                        color: MyColors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                    SizedBox(height: 1.5.h),
                    text_widget(
                        " In the free version you can just see people in the nearby area of 5km or you are not able to filter and in the premium version (subscription) you have the full function",
                        textAlign: TextAlign.center,
                        color: Color(0xff2F3342).withOpacity(0.50),
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Expanded(
                          child: gradientButton("See Plan", ontap: () async {
                            Navigator.pop(context);
                            Get.to(SubscriptionPlan());
                          },
                              height: 4.8,
                              font: 13.5,
                              width: 60,
                              isColor: true,
                              clr: MyColors.primary),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
