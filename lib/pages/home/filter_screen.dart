import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/range_slider.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../widgets/text_field.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

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
                  )),
            ),
          )),
          Positioned.fill(
            child: SafeArea(
              child: Scaffold(
                floatingActionButton: gradientButton("Apply",
                    font: 17,
                    txtColor: MyColors.white,
                    ontap: () {},
                    // _.loginUser();

                    width: 90,
                    height: 6.6,
                    isColor: true,
                    clr: MyColors.primary),
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          // text_widget("Filter",color: Colors.transparent),

                          Spacer(),
                          text_widget("Filter",
                              fontSize: 18.sp, fontWeight: FontWeight.w400),
                          Spacer(),
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(
                                Remix.close_line,
                                color: Color(0xff1E1E1E),
                                size: 3.h,
                              ))
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
                      SizedBox(height: 2.h),
                      text_widget(
                        "Location & Address",
                        fontSize: 18.sp,
                      ),
                      SizedBox(height: 2.h),
                      textFieldWithPrefixSuffuxIconAndHintText(
                        "City  ",
                        // controller: _.password,
                        fillColor: Colors.white,
                        mainTxtColor: Colors.black,
                        radius: 12,
                        bColor: Colors.transparent,
                        prefixIcon: "assets/icons/city.png",
                        isPrefix: true,
                      ),
                      SizedBox(height: 2.h),
                      textFieldWithPrefixSuffuxIconAndHintText(
                        "State  ",
                        // controller: _.password,
                        fillColor: Colors.white,
                        mainTxtColor: Colors.black,
                        radius: 12,
                        bColor: Colors.transparent,
                        prefixIcon: "assets/icons/state.png",
                        isPrefix: true,
                      ),
                      SizedBox(height: 2.h),
                      RangeSliderLabelWidget(title: "Search Radius"),
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
                    text_widget("Delete Service",
                        color: MyColors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                    SizedBox(height: 1.5.h),
                    text_widget("Are you sure to want delete this Event",
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
                    text_widget("Child Details ",
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
                            text_widget("Total num of children",
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
                                    text_widget(
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
                                    text_widget(
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
