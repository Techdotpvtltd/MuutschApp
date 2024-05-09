import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/controller/drawer_controller.dart';
import 'package:musch/pages/home/home_drawer.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NotificationScreen extends StatelessWidget {
  final bool isDrawer;
  const NotificationScreen({super.key, required this.isDrawer});

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
            ],
          ),
          Positioned.fill(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 87.h,
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
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  Get.find<MyDrawerController>().closeDrawer();
                                  Get.to(HomeDrawer());
                                },
                                child: Icon(Remix.arrow_left_s_line,
                                    color: Colors.white, size: 4.h)),
                            SizedBox(width: 2.w),
                            text_widget("Notifications",
                                color: Colors.white, fontSize: 18.sp),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                leading: Image.asset("assets/icons/n1.png"),
                                title: text_widget(
                                  'Password Update Successful',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                subtitle: text_widget(
                                    "Notify customers when a product is dropping",
                                    fontSize: 13.sp,
                                    color: Color(0xff8F8F8F)),
                              ),
                            )),
                        SizedBox(height: 2.h),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                leading: Image.asset("assets/icons/n2.png"),
                                title: text_widget(
                                  'Account Setup Successful',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                subtitle: text_widget(
                                    "Notify customers when a product is dropping",
                                    fontSize: 13.sp,
                                    color: Color(0xff8F8F8F)),
                              ),
                            )),
                        SizedBox(height: 2.h),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                leading: Image.asset("assets/icons/n3.png"),
                                title: text_widget(
                                  'Debit Card added Successfully',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                subtitle: text_widget(
                                    "Notify customers when a product is dropping",
                                    fontSize: 13.sp,
                                    color: Color(0xff8F8F8F)),
                              ),
                            )),
                        SizedBox(height: 2.h),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                leading: Image.asset("assets/icons/n4.png"),
                                title: text_widget(
                                  'Password Update Successful',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                subtitle: text_widget(
                                    "Notify customers when a product is dropping",
                                    fontSize: 13.sp,
                                    color: Color(0xff8F8F8F)),
                              ),
                            )),
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

