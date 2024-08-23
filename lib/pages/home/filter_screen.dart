import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/range_slider.dart';
import 'package:musch/widgets/text_widget.dart';
import 'package:place_picker/place_picker.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/event/event_bloc.dart';
import '../../blocs/event/events_event.dart';
import '../../models/location_model.dart';
import '../../utils/constants/constants.dart';
import '../../widgets/text_field.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen(
      {super.key, this.searchText, this.location, this.rangeValues});
  final String? searchText;
  final LocationModel? location;
  final RangeValues? rangeValues;

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  late RangeValues? rangeValues = widget.rangeValues;
  late LocationModel? location = widget.location;

  void triggerApplyFilterEvent(EventBloc bloc) {
    bloc.add(EventsEventApplyFilter(
      searchText: searchController.text,
      values: rangeValues,
      location: location,
    ));
  }

  void triggerClearFilterEvent(EventBloc bloc) {
    bloc.add(EventsEventClearFilter());
  }

  void pickLocation() async {
    final LocationResult result = await Get.to(
      PlacePicker(
        "AIzaSyAqSjBWxORHHKlLY7ISV5BmookK7fQlw4U",
        displayLocation:
            (location?.latitude != null || location?.longitude != null)
                ? LatLng(location!.latitude, location!.longitude)
                : null,
      ),
    );

    location = LocationModel(
      address: result.formattedAddress,
      city: result.city?.name,
      country: result.country?.name,
      latitude: result.latLng?.latitude ?? 0,
      longitude: result.latLng?.longitude ?? 0,
    );

    setState(() {
      locationController.text = location?.address ?? "";
    });
  }

  @override
  void initState() {
    searchController.text = widget.searchText ?? "";
    locationController.text = widget.location?.address ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Stack(
        children: [
          Container(
            height: 20.h,
            color: Color(0xffBD9691),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 93.h,
                decoration: BoxDecoration(
                  color: Color(0xfff2f2f2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: Row(
                  children: [
                    gapW20,
                    Expanded(
                      child: gradientButton(
                        "Clear",
                        font: 17,
                        txtColor: MyColors.primary,
                        ontap: () {
                          triggerClearFilterEvent(context.read<EventBloc>());
                          Get.back();
                        },
                        height: 6.6,
                        isColor: false,
                      ),
                    ),
                    gapW10,
                    Expanded(
                      child: gradientButton(
                        "Apply",
                        font: 17,
                        txtColor: MyColors.white,
                        ontap: () {
                          triggerApplyFilterEvent(context.read<EventBloc>());
                          Get.back();
                        },
                        height: 6.6,
                        isColor: true,
                        clr: MyColors.primary,
                      ),
                    ),
                    gapW20,
                  ],
                ),
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Spacer(),
                          textWidget(
                            "Filter",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Remix.close_line,
                              color: Color(0xff1E1E1E),
                              size: 3.h,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      textFieldWithPrefixSuffuxIconAndHintText(
                        "Search by event name",
                        controller: searchController,
                        fillColor: Colors.white,
                        mainTxtColor: Colors.black,
                        radius: 12,
                        bColor: Colors.transparent,
                        prefixIcon: "assets/nav/s1.png",
                        isPrefix: true,
                      ),
                      SizedBox(height: 2.h),
                      textWidget(
                        "Location & Address",
                        fontSize: 18.sp,
                      ),
                      SizedBox(height: 2.h),
                      InkWell(
                        onTap: () {
                          pickLocation();
                        },
                        child: textFieldWithPrefixSuffuxIconAndHintText(
                          "Select Address",
                          controller: locationController,
                          fillColor: Colors.white,
                          mainTxtColor: Colors.black,
                          radius: 12,
                          enable: false,
                          bColor: Colors.transparent,
                          prefixIcon: "assets/icons/city.png",
                          isPrefix: true,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      RangeSliderLabelWidget(
                        title: "Search Radius",
                        startedValue: rangeValues?.start ?? 0,
                        endedValue: rangeValues?.end ?? 50,
                        onValueChange: (value) {
                          rangeValues = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeleteService extends StatelessWidget {
  const DeleteService({super.key});

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
                      "assets/icons/del.png",
                      height: 8.h,
                    ),
                    SizedBox(height: 1.4.h),
                    textWidget("Delete Service",
                        color: MyColors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                    SizedBox(height: 1.5.h),
                    textWidget("Are you sure to want delete this Event",
                        textAlign: TextAlign.center,
                        color: Color(0xff2F3342).withOpacity(0.50),
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Expanded(
                          child: gradientButton("Cancel",
                              ontap: () {},
                              height: 5.5,
                              font: 13.5,
                              txtColor: MyColors.primary,
                              width: 60,
                              isColor: false,
                              clr: MyColors.primary),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: gradientButton("Delete", ontap: () async {
                            Navigator.pop(context);
                          },
                              height: 5.5,
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

class ChildDetails extends StatelessWidget {
  const ChildDetails({super.key});

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
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xffF2F2F2)),
              // color: Color(0xfff9f8f6),

              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 1.4.h),
                    textWidget("Child Details ",
                        color: MyColors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                    SizedBox(height: 1.5.h),
                    Container(
                      height: 7.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          children: [
                            textWidget("Total num of children",
                                fontSize: 15.sp, fontWeight: FontWeight.w400),
                            Spacer(),
                            Container(
                              width: 20.w,
                              height: 4.4.h,
                              decoration: BoxDecoration(
                                color: MyColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                style: GoogleFonts.poppins(color: Colors.white),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "    4  ",
                                    enabled: false,
                                    hintStyle: GoogleFonts.poppins(
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    ...List.generate(
                      4,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  children: [
                                    Image.asset("assets/icons/dp.png",
                                        height: 2.4.h),
                                    SizedBox(width: 3.w),
                                    textWidget(
                                      "12 years old",
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                    )
                                  ],
                                ),
                              ),
                            )),
                            SizedBox(width: 2.w),
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  children: [
                                    Image.asset("assets/icons/date.png",
                                        height: 2.4.h),
                                    SizedBox(width: 3.w),
                                    textWidget(
                                      "12-3-2016",
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                    )
                                  ],
                                ),
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    gradientButton("Next",
                        font: 17,
                        txtColor: MyColors.white,

                        // _.loginUser();

                        width: 90,
                        height: 6.6,
                        isColor: true,
                        clr: MyColors.primary),
                    SizedBox(height: 1.h),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
