import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/pages/home/add_event.dart';
import 'package:musch/pages/home/edit_event.dart';
import 'package:musch/widgets/event_widget.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../widgets/text_field.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  bool isGrid = true;
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
                floatingActionButton: InkWell(
                  onTap: () {
                    Get.to(AddEvent());
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      text_widget(
                        "Add Event",
                        fontSize: 15.6.sp,
                      ),
                      SizedBox(width: 3.w),
                      FloatingActionButton(
                        onPressed: () {
                          Get.to(AddEvent());
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        backgroundColor: Colors.white,
                        child: Icon(
                          Remix.add_line,
                          color: Color(0xffFFAD85),
                        ),
                      ),
                    ],
                  ),
                ),
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
                                crossAxisCount: 1,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                shrinkWrap: true,
                                childAspectRatio: 2.2,
                                children: List.generate(
                                  3,
                                  (index) {
                                    return InkWell(
                                      onTap: () {
                                        Get.to(EditEvent());
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 1.h),
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.asset(
                                                    "assets/images/ii1.png",
                                                    height: 10.h,
                                                    width: Get.width,
                                                    fit: BoxFit.fill,
                                                  )),
                                              SizedBox(height: 1.h),
                                              text_widget("Party With Friends",
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600),
                                              SizedBox(height: 0.5.h),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/p5.png",
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
                                            ],
                                          ),
                                        ),
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
