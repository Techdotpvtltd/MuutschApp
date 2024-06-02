import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/auth/interest_page.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_widget.dart';
import 'package:place_picker/place_picker.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';
import '../../models/location_model.dart';
import '../../utils/dialogs/dialogs.dart';

class AllowLocation extends StatefulWidget {
  const AllowLocation({super.key});

  @override
  State<AllowLocation> createState() => _AllowLocationState();
}

class _AllowLocationState extends State<AllowLocation> {
  bool isAllowShow = false;
  bool isSelectLoactionShow = false;
  bool isLoading = false;

  void checkPermission() async {
    // Await for permission
    LocationPermission status = await Geolocator.checkPermission();
    setState(() {
      isAllowShow = status == LocationPermission.denied ||
          status == LocationPermission.deniedForever ||
          status == LocationPermission.denied ||
          status == LocationPermission.unableToDetermine;
      isSelectLoactionShow = status == LocationPermission.always ||
          status == LocationPermission.whileInUse;
    });
  }

  void allowPermission() async {
    // Await for permission
    LocationPermission status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
    }

    if (status == LocationPermission.denied ||
        status == LocationPermission.deniedForever) {
      CustomDialogs().alertBox(
          message: "Please allow location permission from settings.",
          title: "Location Permission Denied.",
          positiveTitle: "Okay",
          showNegative: false);
    }

    checkPermission(); // check again
  }

  void getLocation() async {
    final LocationResult result = await Get.to(PlacePicker(
      "AIzaSyCtEDCykUDeCa7QkT-LK63xQ7msSXNZoq0",
    ));

    final LocationModel userLocation = LocationModel(
        address: result.formattedAddress,
        city: result.city?.name,
        country: result.country?.name,
        latitude: result.latLng?.latitude ?? 0,
        longitude: result.latLng?.longitude ?? 0);
    triggerUpdateProfileEvent(context.read<UserBloc>(), userLocation);
  }

  void triggerUpdateProfileEvent(UserBloc bloc, LocationModel model) {
    bloc.add(UserEventUpdateProfile(location: model));
  }

  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserStateProfileUpdating ||
            state is UserStateProfileUpdated ||
            state is UserStateProfileUpdatingFailure) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is UserStateProfileUpdatingFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is UserStateProfileUpdated) {
            Get.to(InterestPage());
          }
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Color(0xffF2F2F2),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                "assets/images/shape.png",
                height: 25.h,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned.fill(
              child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Remix.arrow_left_s_line,
                              color: Colors.black,
                              size: 3.h,
                            ),
                          )
                        ],
                      ),
                      Center(
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 10.h,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      textWidget(
                        "Help them find you!",
                        fontSize: 21.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 0.4.h),
                      textWidget(
                        "Allow us to access your location while you’re using the app so we can help you find and meet members.",
                        fontSize: 15.sp,
                        color: Color(
                          0xff8C8C8C,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Center(
                        child: Image.asset(
                          "assets/icons/pin.png",
                          height: 20.h,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Visibility(
                        visible: isAllowShow,
                        child: gradientButton(
                          "Allow Location",
                          font: 16,
                          txtColor: MyColors.white,
                          ontap: () {
                            allowPermission();
                          },
                          width: 90,
                          height: 6.6,
                          isColor: true,
                          clr: MyColors.primary,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Visibility(
                        visible: isSelectLoactionShow,
                        child: gradientButton(
                          "Select Location",
                          isLoading: isLoading,
                          font: 16,
                          txtColor: MyColors.primary,
                          ontap: () {
                            getLocation();
                          },
                          width: 90,
                          height: 6.6,
                          isColor: false,
                          clr: MyColors.primary,
                        ),
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
