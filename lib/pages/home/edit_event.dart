import 'dart:developer';

import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/filter_screen.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/map_sample.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditEvent extends StatefulWidget {
  // final bool isDrawer;
  // const EditEvent({super.key,required this.isDrawer});

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  Time _time = Time(hour: 11, minute: 30, second: 20);

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
    // log(jobModel.startTime.toString());
  }

  DateTime selectedDate = DateTime.now();
  bool isEdit = false;
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
                            setState(() {
                              isEdit
                                  ? setState(() {
                                      isEdit = false;
                                    })
                                  : Get.back();
                            });
                          },
                          child: Icon(
                            Remix.arrow_left_s_line,
                            color: Colors.black,
                            size: 3.8.h,
                          )),
                      SizedBox(width: 3.w),
                      text_widget(
                        isEdit ? "Edit Event " : "Event Detail",
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        // color: Color(0xff1E1E1E)
                      ),
                    ],
                  ),
                  // SizedBox(height: 1.h),
                  SizedBox(height: 3.h),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    shrinkWrap: true,
                    childAspectRatio: 1.2,
                    children: List.generate(
                      4,
                      (index) {
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    "assets/images/ii1.png",
                                    height: 10.h,
                                    width: Get.width,
                                    fit: BoxFit.fill,
                                  )),
                            ),
                            isEdit
                                ? Positioned.fill(
                                    child: Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                barrierColor: MyColors.primary
                                                    .withOpacity(0.88),
                                                builder: (context) =>
                                                    DeleteService());
                                          },
                                          child: Image.asset(
                                            "assets/icons/del1.png",
                                            height: 3.5.h,
                                          )),
                                    ),
                                  ))
                                : SizedBox()
                          ],
                        );
                      },
                    ),
                  ),
                  text_widget(
                    "Event Title",
                    fontSize: 15.6.sp,
                  ),

                  SizedBox(height: 1.h),
                  textFieldWithPrefixSuffuxIconAndHintText(
                      "Play date on playground",

                      // controller: _.password,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      isSuffix: isEdit,
                      suffixIcon: "assets/icons/edit.png"),
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
                              // controller: _.password,
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
                              // Optional onChange to receive value as DateTime
                              onChangeDateTime: (DateTime dateTime) {
                                // print(dateTime);
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
                              // controller: _.password,
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
                      // controller: _.password,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      isSuffix: isEdit,
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
                      // controller: _.password,
                      line: 5,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      isSuffix: isEdit,
                      suffixIcon: "assets/icons/edit.png"),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: gradientButton(isEdit ? "Discard" : "Delete",
                            font: 15.5, txtColor: MyColors.primary, ontap: () {
                          // isEdit?null:
                          // _.loginUser();
                        },
                            width: 90,
                            height: 6,
                            isColor: false,
                            clr: MyColors.primary),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: gradientButton(isEdit ? "Save Changes" : "Edit",
                            font: 15.5, txtColor: MyColors.white, ontap: () {
                          isEdit
                              ? setState(() {})
                              : setState(() {
                                  isEdit = true;
                                });
                          // _.loginUser();
                        },
                            width: 90,
                            height: 6,
                            isColor: true,
                            clr: MyColors.primary),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            )),
      ),
    );
  }
}
