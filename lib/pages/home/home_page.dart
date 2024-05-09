import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/controller/drawer_controller.dart';
import 'package:musch/pages/home/all_events.dart';
import 'package:musch/pages/home/all_friends.dart';
import 'package:musch/pages/home/notification_screen.dart';
import 'package:musch/widgets/event_widget.dart';
import 'package:musch/widgets/request_widget.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../widgets/text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 53.h,
              color: Color(0xffBD9691),
            ),
            Expanded(
                child: Container(
              color: Colors.white,
            ))
          ],
        ),
        Positioned.fill(
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    Get.find<MyDrawerController>()
                                        .toggleDrawer();
                                  },
                                  child: Image.asset(
                                    "assets/images/logo.png",
                                    height: 5.h,
                                  )),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Get.to(NotificationScreen(isDrawer: false));
                                },
                                child: Image.asset(
                                  "assets/nav/d3.png",
                                  color: Colors.white,
                                  height: 4.5.h,
                                ),
                              ),
                              SizedBox(
                                width: 1.5.w,
                              ),
                              CircleAvatar(
                                radius: 2.5.h,
                                backgroundColor: MyColors.primary,
                                backgroundImage:
                                    AssetImage("assets/images/girl.png"),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.5.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 8),
                            decoration: BoxDecoration(
                              color: MyColors.primary,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: text_widget("Hello, Haider",
                                color: Colors.white, fontSize: 15.sp),
                          ),
                          SizedBox(height: 1.h),
                          text_widget("Find Amazing Friends",
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600),
                          SizedBox(height: 2.5.h),
                          textFieldWithPrefixSuffuxIconAndHintText(
                            "Search products or services",
                            // controller: _.password,
                            fillColor: Colors.white,
                            mainTxtColor: Colors.black,
                            radius: 12,
                            bColor: Colors.transparent,
                            prefixIcon: "assets/nav/s1.png",
                            isPrefix: true,
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              text_widget(
                                "Friend Requests",
                                color: Colors.white,
                                fontSize: 17.5.sp,
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Get.to(AllFriends());
                                },
                                child: text_widget(
                                  "View All",
                                  fontSize: 14.sp,
                                  color: MyColors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Row(
                          children: [
                            requestWidget(),
                            SizedBox(width: 2.w),
                            requestWidget(),
                            SizedBox(width: 2.w),
                            requestWidget(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              text_widget(
                                "Nearby Events",
                                color: Colors.black,
                                fontSize: 17.5.sp,
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Get.to(AllEvents());
                                },
                                child: text_widget("View All",
                                    fontSize: 14.sp,
                                    color: MyColors.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: MyColors.primary),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          eventWidget(),
                          SizedBox(height: 2.h),
                          eventWidget(),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
