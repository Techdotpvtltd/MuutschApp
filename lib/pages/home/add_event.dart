import 'dart:developer';

import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/map_sample.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utils/constants/constants.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../widgets/image_collection_widget.dart';

class AddEvent extends StatefulWidget {
  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  Time _time = Time(hour: 11, minute: 30, second: 20);

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String? selectedValue;
  List<String> attributes = [
    "Marriage Event",
    "Private Party",
    "Club",
    "Cruise Party"
  ];
  bool status4 = false;
  int current = 0;
  final List<String> images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2).withOpacity(0.94),
      body: SingleChildScrollView(
        child: SafeArea(
            bottom: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
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
                          size: 3.8.h,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      text_widget(
                        "Create Event",
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  SizedBox(
                    width: SCREEN_WIDTH,
                    height: SCREEN_HEIGHT * 0.40,
                    child: ImageCollectionWidget(
                      height: SCREEN_HEIGHT * 0.35,
                      images: images,
                      onClickUploadImage: (file) {
                        setState(() {
                          images.add(file.path);
                        });
                      },
                      onClickDeleteButton: (index) {
                        CustomDialogs().deleteBox(
                          title: "Remove Image",
                          message: 'Are you sure to remove this image?',
                          onPositivePressed: () {
                            setState(() {
                              images.removeAt(index);
                            });
                          },
                        );
                      },
                      onClickCard: (index) {},
                    ),
                  ),
                  text_widget(
                    "Event Title",
                    fontSize: 15.6.sp,
                  ),
                  SizedBox(height: 1.h),
                  textFieldWithPrefixSuffuxIconAndHintText(
                    "Enter event title",
                    fillColor: Colors.white,
                    mainTxtColor: Colors.black,
                    radius: 12,
                    bColor: Colors.transparent,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text_widget(
                              "Date",
                              fontSize: 15.6.sp,
                            ),
                            SizedBox(height: 1.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              "Select Date",
                              enable: false,
                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                              radius: 12,
                              bColor: Colors.transparent,
                              suffixIcon: "assets/icons/d1.png",
                              isSuffix: true,
                            ),
                          ],
                        ),
                      )),
                      SizedBox(width: 2.w),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            showPicker(
                              showSecondSelector: false,
                              context: context,
                              value: _time,
                              iosStylePicker: true,
                              onChange: onTimeChanged,
                              minuteInterval: TimePickerInterval.FIVE,
                              onChangeDateTime: (DateTime dateTime) {
                                log("[debug datetime]:  $dateTime");
                              },
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text_widget(
                              "Time",
                              fontSize: 15.6.sp,
                            ),
                            SizedBox(height: 1.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              "Select Time",
                              enable: false,
                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                              radius: 12,
                              bColor: Colors.transparent,
                              suffixIcon: "assets/icons/t2.png",
                              isSuffix: true,
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                  SizedBox(height: 2.h),
                  text_widget(
                    "Location",
                    fontSize: 15.6.sp,
                  ),
                  SizedBox(height: 1.h),
                  textFieldWithPrefixSuffuxIconAndHintText("New York",
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      isSuffix: false,
                      suffixIcon: "assets/icons/edit.png"),
                  SizedBox(height: 2.h),
                  Card(
                    elevation: 3,
                    child: SizedBox(
                      height: 25.h,
                      child: MapCard(isPin: true),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  text_widget(
                    "Description",
                    fontSize: 15.6.sp,
                  ),
                  SizedBox(height: 1.h),
                  textFieldWithPrefixSuffuxIconAndHintText("Write Here",
                      line: 5,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      isSuffix: false,
                      suffixIcon: "assets/icons/edit.png"),
                  SizedBox(height: 4.h),
                  gradientButton("Create Event",
                      font: 17,
                      txtColor: MyColors.white,
                      ontap: () {},
                      width: 90,
                      height: 6.6,
                      isColor: true,
                      clr: MyColors.primary),
                  SizedBox(height: 10.h),
                ],
              ),
            )),
      ),
    );
  }
}
