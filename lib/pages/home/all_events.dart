import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/event_detail.dart';
import 'package:musch/pages/home/filter_screen.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/event_widget.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../widgets/text_field.dart';

class AllEvents extends StatefulWidget {
  const AllEvents({super.key});

  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  bool isGrid = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 20.h,
                color: Color(0xffBD9691),
              ),
              Expanded(
                  child: Container(
                color: Color(0xfff2f2f2),
              ))
            ],
          ),
          Positioned.fill(
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(Remix.arrow_left_s_line,
                                    color: Colors.white, size: 4.h)),
                            SizedBox(width: 2.w),
                            text_widget("All Events",
                                color: Colors.white, fontSize: 18.sp),
                            Spacer(),
                            isGrid
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        isGrid = false;
                                      });
                                    },
                                    child: Image.asset("assets/icons/list.png",
                                        height: 2.5.h))
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        isGrid = true;
                                      });
                                    },
                                    child: Image.asset("assets/icons/grid.png",
                                        height: 2.5.h)),
                            SizedBox(width: 4.w),
                            InkWell(
                                onTap: () {
                                  Get.to(FilterScreen());
                                },
                                child: Image.asset("assets/icons/filter.png",
                                    height: 2.5.h)),
                            SizedBox(width: 4.w),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        textFieldWithPrefixSuffuxIconAndHintText(
                          "Search Event",
                          // controller: _.password,
                          fillColor: Colors.white,
                          isPrefix: true,
                          prefixIcon: "assets/nav/s1.png",
                          mainTxtColor: Colors.black,
                          radius: 12,
                          bColor: Colors.transparent,
                        ),
                        SizedBox(height: 4.h),
                        isGrid
                            ? GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                shrinkWrap: true,
                                childAspectRatio: 0.8,
                                children: List.generate(
                                  4,
                                  (index) {
                                    return InkWell(
                                      onTap: () {
                                        Get.to(EventView());
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.asset(
                                                "assets/images/ii1.png",
                                                height: 10.h,
                                                width: Get.width,
                                                fit: BoxFit.cover,
                                              )),
                                          SizedBox(height: 1.h),
                                          text_widget("Party With Friends",
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600),
                                          SizedBox(height: 0.5.h),
                                          Row(
                                            children: [
                                              Image.asset(
                                                "assets/images/p2.png",
                                                height: 1.4.h,
                                              ),
                                              SizedBox(width: 1.w),
                                              Expanded(
                                                child: text_widget(
                                                    "456 Park Avenue, New York",
                                                    fontSize: 12.8.sp,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 0.8.h),
                                          text_widget(
                                              "Created by: Hammad Habib",
                                              fontSize: 12.2.sp,
                                              color: MyColors.primary,
                                              fontWeight: FontWeight.w600),
                                          SizedBox(height: 1.4.h),
                                          gradientButton("Join Event",
                                              font: 15,
                                              txtColor: MyColors.white,
                                              ontap: () {
                                            // _.loginUser();
                                          },
                                              width: 90,
                                              height: 3.5,
                                              isColor: true,
                                              clr: MyColors.primary),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  eventWidget(isEvent: true),
                                  SizedBox(height: 2.h),
                                  eventWidget(isEvent: true),
                                  SizedBox(height: 2.h),
                                  eventWidget(isEvent: true),
                                  SizedBox(height: 2.h),
                                  eventWidget(isEvent: true),
                                ],
                              ),
                        SizedBox(height: 2.h),
                      ],
                    ),
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
